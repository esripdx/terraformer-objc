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
        case TFPrimitiveTypePolygon:
        case TFPrimitiveTypeMultiPolygon:
            #warning unimplemented types.
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
        for (NSDictionary *p in points) {
            TFPoint *point = (TFPoint *)[self decodeDict:p error:error];
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
        #warning stub
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

@end