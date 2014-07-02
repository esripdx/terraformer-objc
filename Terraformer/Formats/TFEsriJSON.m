//
//  TFEsriJSON
//  Terraformer
//
//  Created by ryana on 6/19/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFEsriJSON.h"
#import "TFPrimitive.h"
#import "TFPoint.h"
#import "TFMultiPoint.h"
#import "TFLineString.h"
#import "TFMultiLineString.h"
#import "TFPolygon.h"
#import "TFMultiPolygon.h"
#import "TFFeature.h"
#import "TFFeatureCollection.h"
#import "TFGeometryCollection.h"


// Class Categories for additional functionality on the primitives to help with encoding/decoding of EsriJSON
@interface TFLineString (esrijson)
- (BOOL)isClockwise;
- (BOOL)containsPoint:(TFPoint *)point;
- (BOOL)contains:(TFLineString *)ring;
- (BOOL)isIntersectingLineString:(TFLineString *)lineString;
- (TFLineString *)reversed;
@end

@interface TFPolygon (esrijson)
- (BOOL)containsLineString:(TFLineString *)lineString;
- (NSArray *)orientedRings;
@end

@interface TFMultiPolygon (esrijson)
- (NSArray *)orientedRings;
@end

@implementation TFEsriJSON {

}

static NSString *const TFSRKey = @"spatialReference";
static NSString *const TFWKIDKey = @"wkid";
static NSString *const TFWKTKey = @"wkt";

static NSString *const TFPointsKey = @"points";
static NSString *const TFHasMKey = @"hasM";
static NSString *const TFHasZKey = @"hasZ";

static NSString *const TFRingsKey = @"rings";

static NSString *const TFPathsKey = @"paths";
static NSString *const TFGeometryKey = @"geometry";
static NSString *const TFAttributesKey = @"attributes";

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _spatialReference = @{ TFWKIDKey: @(4326) };
        _featureIdentifierKey = @"OBJECTID";
    }
    return self;
}

- (NSNumber *)wkid {
    return self.spatialReference[TFWKIDKey];
}

- (void)setWkid:(NSNumber *)wkid {
    NSMutableDictionary *sr = [self.spatialReference mutableCopy];
    sr[TFWKIDKey] = wkid;
    self.spatialReference = sr;
}

- (NSString *)wkt {
    return self.spatialReference[TFWKTKey];
}

- (void)setWkt:(NSString *)wkt {
    NSMutableDictionary *sr = [self.spatialReference mutableCopy];
    sr[TFWKTKey] = wkt;
    self.spatialReference = sr;
}

- (NSDictionary *)encodePrimitiveToDictionary:(TFPrimitive *)primitive error:(NSError **)error {
    NSMutableDictionary *dict = [NSMutableDictionary new];

    if ([primitive isKindOfClass:[TFGeometry class]]) {
        dict[TFSRKey] = self.spatialReference;
    }

    switch(primitive.type) {
        case TFPrimitiveTypePoint: {
            TFPoint *p = (TFPoint *)primitive;
            if (p.x != nil) {
                dict[@"x"] = p.x;
                if (p.y != nil) {
                    dict[@"y"] = p.y;
                    if (p.z != nil) {
                        dict[@"z"] = p.z;
                        if (p.m != nil) {
                            dict[@"m"] = p.m;
                        }
                    }
                }
            }
            break;
        }
        case TFPrimitiveTypeMultiPoint: {
            TFMultiPoint *mp = (TFMultiPoint *)primitive;
            [self populateHasZAndMKeysForPoints:mp.points inDict:dict];
            dict[TFPointsKey] = [mp coordinateArray];
            break;
        }
        case TFPrimitiveTypeLineString: {
            TFLineString *ls = (TFLineString *)primitive;
            [self populateHasZAndMKeysForPoints:ls.points inDict:dict];
            dict[TFPathsKey] = [ls coordinateArray];
            break;
        }
        case TFPrimitiveTypeMultiLineString: {
            TFMultiLineString *mls = (TFMultiLineString *)primitive;
            [self populateHasZAndMKeysForLineStrings:mls.lineStrings inDict:dict];
            dict[TFPathsKey] = [mls coordinateArray];
            break;
        }
        case TFPrimitiveTypeFeature: {
            TFFeature *feature = (TFFeature *)primitive;

            NSDictionary *geometryDict;
            NSAssert(![feature.geometry isKindOfClass:[TFGeometryCollection class]], @"Can't encode a Feature with a geometry of type GeometryCollection to EsriJSON. You will need to separate the geometries into separate features in order to produce valid EsriJSON with this object.");
            // in a non DEBUG build we will still make it to here, so we still have to check for the GeometryCollection type and handle it.
            // We do so by creating technically invalid esriJSON (but still valid JSON).
            if ([feature.geometry isKindOfClass:[TFGeometryCollection class]]) {
                NSData *geometryData = [self encodePrimitive:feature.geometry error:error];
                if (!geometryData) {
                    return nil;
                }
                geometryDict = [NSJSONSerialization JSONObjectWithData:geometryData options:0 error:error];
                // TODO: Not sure this log call is necessary, and even if it is, there's probably a nicer way to log it than NSLog.
                NSLog(@"Encoding an EsriJSON Feature with an array of geometries in the geometry key. This is not valid EsriJSON.");
            } else {
                geometryDict = [self encodePrimitiveToDictionary:feature.geometry error:error];
            }
            if (!geometryDict) {
                return nil;
            }
            dict[TFGeometryKey] = geometryDict;

            if (feature.identifier != nil && self.featureIdentifierKey != nil) {
                if (feature.properties == nil) {
                    feature.properties = @{};
                }

                NSMutableDictionary *props = [feature.properties mutableCopy];
                props[self.featureIdentifierKey] = feature.identifier;
                feature.properties = props;
            }

            if (feature.properties != nil) {
                dict[TFAttributesKey] = feature.properties;
            }
            break;
        }
        case TFPrimitiveTypeGeometryCollection:
        case TFPrimitiveTypeFeatureCollection:
            // EsriJSON doesn't have an equivalent for the collection types, so we just build an array of the items
            // in the collection, therefore there is no NSDictionary version of these.
            return nil;
        case TFPrimitiveTypePolygon: {
            TFPolygon *p = (TFPolygon *)primitive;
            [self populateHasZAndMKeysForLineStrings:p.lineStrings inDict:dict];
            dict[TFRingsKey] = [p orientedRings];
            break;
        }
        case TFPrimitiveTypeMultiPolygon: {
            TFMultiPolygon *mp = (TFMultiPolygon *)primitive;
            [self populateHasZAndMKeysForLineStrings:((TFPolygon *)mp.polygons[0]).lineStrings inDict:dict];
            dict[TFRingsKey] = [mp orientedRings];
        }
        default:
            NSAssert(NO, @"not yet implemented");
    }

    return dict;
}

- (NSData *)encodePrimitive:(TFPrimitive *)primitive error:(NSError **)error {
    switch(primitive.type) {
        case TFPrimitiveTypeGeometryCollection: {
            // EsriJSON doesn't have an equivalent for the collection types, so we just build an array of the items
            // in the collection and serialize that.

            TFGeometryCollection *gc = (TFGeometryCollection *) primitive;
            NSMutableArray *geometries = [NSMutableArray new];
            for (TFGeometry *geometry in gc.geometries) {
                NSData *geometryData = [self encodePrimitive:geometry error:error];
                if (!geometryData) {
                    return nil;
                }
                NSDictionary *geometryDict = [NSJSONSerialization JSONObjectWithData:geometryData options:0 error:error];
                if (!geometryDict) {
                    return nil;
                }
                [geometries addObject:geometryDict];
            }
            return [NSJSONSerialization dataWithJSONObject:geometries options:0 error:error];
        }
        case TFPrimitiveTypeFeatureCollection: {
            // EsriJSON doesn't have an equivalent for the collection types, so we just build an array of the items
            // in the collection and serialize that.

            TFFeatureCollection *fc = (TFFeatureCollection *)primitive;
            NSMutableArray *features = [NSMutableArray new];
            for (TFFeature *f in fc.features) {
                NSData *featureData = [self encodePrimitive:f error:error];
                if (!featureData) {
                    return nil;
                }
                NSDictionary *featureDict = [NSJSONSerialization JSONObjectWithData:featureData options:0 error:error];
                if (!featureDict) {
                    return nil;
                }
                [features addObject:featureDict];
            }
            return [NSJSONSerialization dataWithJSONObject:features options:0 error:error];
        }
        default: {
            NSDictionary *dict = [self encodePrimitiveToDictionary:primitive error:error];
            return [NSJSONSerialization dataWithJSONObject:dict options:0 error:error];
        }
    }
}

- (TFPrimitive *)decodeDict:(NSDictionary *)dict error:(NSError **)error {
    if (!dict) {
        return nil;
    }

    // Point
    if (dict[@"x"] != nil && dict[@"y"] != nil) {
        NSMutableArray *coords = [@[dict[@"x"], dict[@"y"]] mutableCopy];
        NSNumber *z = dict[@"z"];
        if (z != nil) {
            [coords addObject:z];
            NSNumber *m = dict[@"m"];
            if (m != nil) {
                [coords addObject:m];
            }
        }
        return [TFPoint pointWithCoordinates:coords];
    }

    // MultiPoint
    if (dict[TFPointsKey] != nil) {
        NSArray *points = dict[TFPointsKey];
        NSMutableArray *decodedPoints = [NSMutableArray new];
        for (NSArray *p in points) {
            TFPoint *point = [TFPoint pointWithCoordinates:p];
            if (!point) {
                return nil;
            }
            [decodedPoints addObject:point];
        }
        return [TFMultiPoint multiPointWithPoints:decodedPoints];
    }

    // LineString/MultiLineString
    if (dict[TFPathsKey] != nil) {
        NSArray *paths = dict[TFPathsKey];
        NSMutableArray *lineStrings = [NSMutableArray new];
        for (NSArray *ls in paths) {
            [lineStrings addObject:[TFLineString lineStringWithCoords:ls]];
        }

        if ([lineStrings count] == 1) {
            return lineStrings[0];
        }

        return [TFMultiLineString multiLineStringWithLineStrings:lineStrings];
    }

    // Polygon/MultiPolygon
    if (dict[TFRingsKey] != nil) {
        // In summary, this is how we handle EsriJSON Polygon interpretation:
        // * In esrijson, each ring is either an outerRing or a hole, determined by whether they are counter-/clockwise.
        // * They can come in any order.
        // * Each outer ring we find is stored in a TFPolygon in the outerRings array.
        // * Each hole we find is stored in a TFLineString in the holes array.
        // * We iterate over the holes and find the the outerRing that contains them and add the hole to that outerRing
        // * If we end up with multiple outerRings, we have a MultiPolygon, otherwise just a Polygon.

        NSArray *rings = dict[TFRingsKey];
        NSMutableArray *outerRings = [NSMutableArray new];
        NSMutableArray *holes = [NSMutableArray new];

        // Separate rings into outerRing TFPolygons and TFLineString holes.
        for (NSArray *ring in rings) {
            TFLineString *r = [TFLineString lineStringWithCoords:ring];
            if (!r) {
                return nil;
            }

            [r closeRing]; // no-op on an already closed ring.
            if ([r count] < 4) {
                continue;
            }

            if ([r isClockwise]) {
                [outerRings addObject:[TFPolygon polygonWithLineStrings:@[r]]];
            } else {
                [holes addObject:r];
            }
        }

        // Iterate over each of our holes and see if we have an outerRing that contains it. Add it to that polygon if we
        // do, or reverse it and make it into its own polygon if we don't.
        for (TFLineString *h in holes) {
            BOOL contained = NO;
            for (TFPolygon *polygon in outerRings) {
                if ([polygon containsLineString:h]) {
                    polygon.lineStrings = [polygon.lineStrings arrayByAddingObject:h];
                    contained = YES;
                    break;
                }
            }

            if (!contained) {
                [outerRings addObject:[TFPolygon polygonWithLineStrings:@[h]]];
            }
        }

        if ([outerRings count] == 1) {
            return outerRings[0];
        } else {
            return [TFMultiPolygon multiPolygonWithPolygons:outerRings];
        }
    }

    // Feature
    if (dict[TFGeometryKey] != nil && dict[TFAttributesKey] != nil) {
        TFGeometry *geometry = (TFGeometry *)[self decodeDict:dict[TFGeometryKey] error:error];
        if (!geometry) {
            return nil;
        }
        NSDictionary *attributes = dict[TFAttributesKey];
        return [TFFeature featureWithGeometry:geometry
                                   properties:attributes
                                   identifier:attributes[self.featureIdentifierKey]];
    }

    NSAssert(NO, @"Unable to detect geometry type.");
    return nil;
}

- (TFPrimitive *)decode:(NSData *)data error:(NSError **)error {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    return [self decodeDict:dict error:error];
}

#pragma mark Helpers

- (void)populateHasZAndMKeysForPoints:(NSArray *)points inDict:(NSMutableDictionary *)dict {
    if ([points count] > 0) {
        TFPoint *p = points[0];
        if (p.m != nil) {
            dict[TFHasMKey] = @YES;
        }
        if (p.z != nil) {
            dict[TFHasZKey] = @YES;
        }
    }
}

- (void)populateHasZAndMKeysForLineStrings:(NSArray *)lineStrings inDict:(NSMutableDictionary *)dict {
    if ([lineStrings count] > 0) {
        TFLineString *ls = lineStrings[0];
        [self populateHasZAndMKeysForPoints:ls.points inDict:dict];
    }
}

@end

#pragma mark TFPrimitive Categories

@implementation TFLineString (esrijson)

/** Determines whether or not the direction of the coordinates in a ring is clockwise using the Shoelace Formula.
* http://en.wikipedia.org/wiki/Shoelace_formula
**/
- (BOOL)isClockwise {
    double total = 0;
    TFPoint *p1, *p2;
    p1 = self[0];
    for (NSUInteger i = 0; i < self.count - 1; i++) {
        p2 = self[i + 1];
        total += ([p2.x doubleValue] - [p1.x doubleValue]) * ([p2.y doubleValue] + [p1.y doubleValue]);
        p1 = p2;
    }
    return (total >= 0);
}

/** Determines whether ot not the given point is contained by the ring. */
- (BOOL)containsPoint:(TFPoint *)point {
    if (point == nil || ![self isLinearRing]) {
        return NO;
    }

    BOOL contains = NO;
    NSUInteger i, j, nvert = [self count];

    // Ray casting algorithm to determine if the point is inside the
    // ring. For each segment with the coordinates a and b, check to see if
    // point.y is within a.y and b.y. If so, check to see if the point is
    // to the left of the edge. If this is also true, a line drawn from the
    // point to the right will intersect the edge-- if the line intersects
    // the polygon an odd number of times, it is inside.

    // If an edge is horizontal it will not pass the checkY test. This is
    // important, since otherwise you run the risk of dividing by zero in
    // the horizontal check.

    // This stackoverflow answer explains it nicely: http://stackoverflow.com/a/218081/52561
    // This is good too: http://geomalgorithms.com/a03-_inclusion.html
    for (i = 0, j = nvert - 1; i < nvert; j = i++) {
        TFPoint *a = self[i];
        TFPoint *b = self[j];

        double ax = [a.x doubleValue];
        double ay = [a.y doubleValue];
        double bx = [b.x doubleValue];
        double by = [b.y doubleValue];
        double px = [point.x doubleValue];
        double py = [point.y doubleValue];

        BOOL checkY = ((ay >= py) != (by >= py));
        BOOL checkX = (px <= ( bx - ax ) * (py - ay) / (by - ay) + ax);

        if (checkY && checkX) {
            contains = !contains;
        }
    }

    return contains;
}

/** Determines whether or not the coordinates of one ring are contained by the other */
- (BOOL)contains:(TFLineString *)ring {
    BOOL intersects = [self isIntersectingLineString:ring];
    BOOL contains = [self containsPoint:ring[0]];

    return (!intersects && contains);
}

/**
* Determines whether one linestring intersects with another
* See: http://geomalgorithms.com/a05-_intersect-1.html
*/
- (BOOL)isIntersectingLineString:(TFLineString *)lineString {
    for (NSUInteger i = 0; i < [self count] - 1; i++) {
        TFLineString *a = [TFLineString lineStringWithPoints:@[self[i], self[i + 1]]];
        TFPoint *a1 = (TFPoint *)a[0];
        TFPoint *a2 = (TFPoint *)a[1];
        double a1_x = [a1.x doubleValue];
        double a1_y = [a1.y doubleValue];
        double a2_x = [a2.x doubleValue];
        double a2_y = [a2.y doubleValue];

        double aVector[2] = { a2_x - a1_x, a2_y - a1_y };
        BOOL aIsPoint = (aVector[0] == 0 && aVector[1] == 0);

        for (NSUInteger j = 0; j < [lineString count] - 1; j++) {
            TFLineString *b = [TFLineString lineStringWithPoints:@[lineString[j], lineString[j + 1]]];
            TFPoint *b1 = (TFPoint *)b[0];
            TFPoint *b2 = (TFPoint *)b[1];

            double b1_x = [b1.x doubleValue];
            double b1_y = [b1.y doubleValue];
            double b2_x = [b2.x doubleValue];
            double b2_y = [b2.y doubleValue];

            double bVector[2] = { b2_x - b1_x, b2_y - b1_y };
            BOOL bIsPoint = (bVector[0] == 0 && bVector[1] == 0);

            // Determine if a and b are parallel. They are parallel if they are both perpendicular to the same vector,
            // which can be boiled down to checking if the difference of the perp products of the two vectors is equal
            // to 0.
            if ((aVector[0] * bVector[1] - aVector[1] * bVector[0]) == 0) {
                // If both segments are points they can only intersect if they are equivalent
                if (aIsPoint && bIsPoint) {
                    if ([a1 isEqual:b1]) {
                        return YES;
                    }
                    continue;
                }

                // If only one segment is a point check whether it lies on the other line segment
                if (aIsPoint && [b containsPoint:a1]) {
                    return YES;
                }
                if (bIsPoint && [a containsPoint:b1]) {
                    return YES;
                }

                // Segments are parallel and have a length > 0. Check if any of the end points lie on the other segment
                if ([a containsPoint:b1] || [a containsPoint:b2] || [b containsPoint:a1] || [b containsPoint:a2]) {
                    return YES;
                }

                // These two segments are parallel but not collinear... next!
                continue;
            }

            // At this point we have 2 non-parallel lines. Get the direction vector for the difference between their
            // first points, which is used to calculate the distance from those points along their corresponding line
            // at which the intersection occurs. This distance is presented as a ratio of the line segment's length,
            // so if that distance is between 0 and 1, the intersection happens on that line segment. Therefore both
            // the a and the b intersection distance ratio must be between 0 and 1 for this to be a valid intersection.

            // See the Non-Parallel Lines section in the link above for a detailed explanation.
            double abVector[2] = { a1_x - b1_x, a1_y - b1_y };
            double aIntersectionDistance = (bVector[1] * abVector[0] - bVector[0] * abVector[1]) /
                    (bVector[0] * aVector[1] - bVector[1] * aVector[0]);
            double bIntersectionDistance = (aVector[0] * abVector[1] - aVector[1] * abVector[0]) /
                    (aVector[0] * bVector[1] - aVector[1] * bVector[0]);

            if (aIntersectionDistance >= 0 && aIntersectionDistance <= 1 &&
                    bIntersectionDistance >= 0 && bIntersectionDistance <= 1) {
                return YES;
            }
        }
    }
    return NO;
}

- (TFLineString *)reversed {
    return [TFLineString lineStringWithPoints:[[self.points reverseObjectEnumerator] allObjects]];
}

@end

@implementation TFPolygon (esrijson)

- (BOOL)containsLineString:(TFLineString *)lineString {
    // I am not a real polygon, I contain no LineStrings.
    if ([self count] < 1) {
        return NO;
    }

    // Is the given LineString inside this polygon?
    if (![self[0] contains:lineString]) {
        return NO;
    }

    // Is the given LineString inside one of the holes in this polygon?
    for (NSUInteger i = 1; i < [self count]; i++) {
        if ([self[i] contains:lineString]) {
            return NO;
        }
    }

    // The LineString is inside my boundary and outside of all of my holes' boundaries.
    return YES;
}

- (NSArray *)orientedRings {
    NSMutableArray *rings = [NSMutableArray new];
    for (NSUInteger i=0; i < [self count]; i++) {
        TFLineString *lineString = self[i];
        TFLineString *ring;

        // ignore invalid rings
        if ([lineString count] < 4) {
            continue;
        }

        // if the first lineString (the outer ring) is not clockwise, or any other lineString (holes) *is* clockwise, reverse it.
        if ((i == 0) != [lineString isClockwise]) {
            ring = [lineString reversed];
        } else {
            ring = lineString;
        }

        [ring closeRing];
        [rings addObject:[ring coordinateArray]];
    }
    return [rings copy];
}

@end

@implementation TFMultiPolygon (esrijson)

- (NSArray *)orientedRings {
    NSMutableArray *rings = [NSMutableArray new];
    for (TFPolygon *p in self.polygons) {
        [rings addObject:[p orientedRings]];
    }
    return [rings copy];
}

@end

