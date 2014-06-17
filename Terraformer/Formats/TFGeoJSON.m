//
//  TFGeoJSON
//  Terraformer
//
//  Created by ryana on 6/16/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFGeoJSON.h"
#import "TFPrimitive.h"
#import "TFPoint.h"
#import "TFLineString.h"
#import "TFMultiPoint.h"
#import "TFMultiLineString.h"
#import "TFPolygon.h"
#import "TFMultiPolygon.h"
#import "TFFeature.h"
#import "TFFeatureCollection.h"
#import "TFGeometryCollection.h"

static NSString *const TFTypeKey = @"type";
static NSString *const TFCoordinatesKey = @"coordinates";
static NSString *const TFGeometryKey = @"geometry";
static NSString *const TFGeometriesKey = @"geometries";
static NSString *const TFFeaturesKey = @"features";
static NSString *const TFIdKey = @"id";
static NSString *const TFPropertiesKey = @"properties";

@implementation TFGeoJSON {

}

+ (NSData *)encodePrimitive:(TFPrimitive *)primitive error:(NSError **)error {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[TFTypeKey] = [self stringForType:primitive.type];

    switch(primitive.type) {
        case TFPrimitiveTypePoint: {
            TFPoint *p = (TFPoint *)primitive;
            dict[TFCoordinatesKey] = p.coordinates;
            break;
        }
        case TFPrimitiveTypeMultiPoint: {
            TFMultiPoint *mp = (TFMultiPoint *)primitive;
            dict[TFCoordinatesKey] = [self arrayOfPointCoordinates:mp.points];
            break;
        }
        case TFPrimitiveTypeLineString: {
            TFLineString *ls = (TFLineString *)primitive;
            dict[TFCoordinatesKey] = [self arrayOfPointCoordinates:ls.points];
            break;
        }
        case TFPrimitiveTypeMultiLineString: {
            TFMultiLineString *mls = (TFMultiLineString *)primitive;
            dict[TFCoordinatesKey] = [self arrayOfLineStringCoordinates:mls.lineStrings];
            break;
        }
        case TFPrimitiveTypePolygon: {
            TFPolygon *polygon = (TFPolygon *)primitive;
            dict[TFCoordinatesKey] = [self arrayOfLineStringCoordinates:polygon.lineStrings];
            break;
        }
        case TFPrimitiveTypeMultiPolygon: {
            TFMultiPolygon *mp = (TFMultiPolygon *)primitive;
            dict[TFCoordinatesKey] = [self arrayOfPolygonCoordinates:mp.polygons];
            break;
        }
        case TFPrimitiveTypeFeature: {
            TFFeature *feature = (TFFeature *)primitive;

            NSData *geometryData = [self encodePrimitive:feature.geometry error:error];
            if (!geometryData) {
                return nil;
            }
            NSDictionary *geometryDict = [NSJSONSerialization JSONObjectWithData:geometryData options:0 error:error];
            if (!geometryDict) {
                return nil;
            }
            dict[TFGeometryKey] = geometryDict;

            if (feature.identifier != nil) {
                dict[TFIdKey] = feature.identifier;
            }

            if (feature.properties != nil) {
                dict[TFPropertiesKey] = feature.properties;
            }
            break;
        }
        case TFPrimitiveTypeFeatureCollection: {
            TFFeatureCollection *featureCollection = (TFFeatureCollection *)primitive;

            NSMutableArray *featuresArray = [NSMutableArray new];
            for (TFFeature *f in featureCollection.features) {
                NSData *featureData = [self encodePrimitive:f error:error];
                if (!featureData) {
                    return nil;
                }
                NSDictionary *featureDict = [NSJSONSerialization JSONObjectWithData:featureData options:0 error:error];
                if (!featureDict) {
                    return nil;
                }
                [featuresArray addObject:featureDict];
            }
            dict[TFFeaturesKey] = featuresArray;
            break;
        }
        case TFPrimitiveTypeGeometryCollection: {
            TFGeometryCollection *geometryCollection = (TFGeometryCollection *)primitive;

            NSMutableArray *geometriesArray = [NSMutableArray new];
            for (TFGeometry *geometry in geometryCollection.geometries) {
                NSData *geometryData = [self encodePrimitive:geometry error:error];
                if (!geometryData) {
                    return nil;
                }
                NSDictionary *geometryDict = [NSJSONSerialization JSONObjectWithData:geometryData options:0 error:error];
                if (!geometryDict) {
                    return nil;
                }
                [geometriesArray addObject:geometryDict];
            }
            dict[TFGeometriesKey] = geometriesArray;
            break;
        }
        default:
            NSAssert(NO, @"not yet implemented");
    }

    return [NSJSONSerialization dataWithJSONObject:dict options:0 error:error];
}

+ (TFPrimitive *)decode:(NSData *)data error:(NSError **)error {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

    switch([self typeForString:dict[TFTypeKey]]) {
        case TFPrimitiveTypePoint: {
            /*
                {
                   "type": "Point",
                   "coordinates": [100.0, 0.0]
                }
            */

            NSArray *coords = [self coordsFromDict:dict error:error];
            if (!coords) {
                return nil;
            }

            return [self parsePointCoordinates:coords error:error];
        }
        case TFPrimitiveTypeMultiPoint: {
            /*
                {
                   "type": "MultiPoint",
                   "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
                }
            */

            NSArray *coords = [self coordsFromDict:dict error:error];
            if (!coords) {
                return nil;
            }

            NSMutableArray *points = [NSMutableArray new];
            for (NSArray *pointCoords in coords) {
                TFPoint *point = [self parsePointCoordinates:pointCoords error:error];
                if (!point) {
                    return nil;
                }
                [points addObject:point];
            }

            return [TFMultiPoint multiPointWithPoints:points];
        }
        case TFPrimitiveTypeLineString: {
            /*
                {
                   "type": "LineString",
                   "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
                }
            */

            NSArray *coords = [self coordsFromDict:dict error:error];
            if (!coords) {
                return nil;
            }

            return [self parseLineStringCoordinates:coords error:error];
        }
        case TFPrimitiveTypeMultiLineString: {
            /*
                {
                    "type": "MultiLineString",
                    "coordinates": [
                        [ [100.0, 0.0], [101.0, 1.0] ],
                        [ [102.0, 2.0], [103.0, 3.0] ]
                    ]
                }
             */

            NSArray *coords = [self coordsFromDict:dict error:error];
            if (!coords) {
                return nil;
            }

            NSMutableArray *lineStrings = [NSMutableArray new];
            for (NSArray *lsCoords in coords) {
                TFLineString *lineString = [self parseLineStringCoordinates:lsCoords error:error];
                if (!lineString) {
                    return nil;
                }
                [lineStrings addObject:lineString];
            }

            return [TFMultiLineString multiLineStringWithLineStrings:lineStrings];
        }
        case TFPrimitiveTypePolygon: {
            /*
            Without holes:
            {
                "type": "Polygon",
                "coordinates": [
                  [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
                ]
            }

            With holes:
            {
                "type": "Polygon",
                "coordinates": [
                  [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
                  [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
                ]
            }
            */

            NSArray *coords = [self coordsFromDict:dict error:error];
            if (!coords) {
                return nil;
            }

            return [self parsePolygonCoordinates:coords error:error];
        }
        case TFPrimitiveTypeMultiPolygon: {
            /*
            {
                "type": "MultiPolygon",
                "coordinates": [
                    [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
                    [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
                    [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
                ]
            }
            */
            NSArray *coords = [self coordsFromDict:dict error:error];
            if (!coords) {
                return nil;
            }

            NSMutableArray *polys = [NSMutableArray new];
            for (NSArray *polyCoords in coords) {
                TFPolygon *polygon = [self parsePolygonCoordinates:polyCoords error:error];
                if (!polygon) {
                    return nil;
                }
                [polys addObject:polygon];
            }

            return [TFMultiPolygon multiPolygonWithPolygons:polys];
        }
        case TFPrimitiveTypeFeature: {
            NSDictionary *geometryDict = dict[TFGeometryKey];
            if (!geometryDict) {
                [self populateError:error withMessage:@"No geometry key found in Feature"];
                return nil;
            }
            NSData *geometryData = [NSJSONSerialization dataWithJSONObject:geometryDict options:0 error:error];
            if (!geometryData) {
                return nil;
            }
            TFGeometry *geometry = (TFGeometry *)[self decode:geometryData error:error];

            return [TFFeature featureWithGeometry:geometry properties:dict[TFPropertiesKey] identifier:dict[TFIdKey]];
        }
        case TFPrimitiveTypeFeatureCollection: {
            NSArray *featureDictsArray = dict[TFFeaturesKey];
            if (!featureDictsArray) {
                [self populateError:error withMessage:@"No features key found in FeatureCollection"];
                return nil;
            }
            NSMutableArray *features = [NSMutableArray new];
            for (NSDictionary *featureDict in featureDictsArray) {
                NSData *featureData = [NSJSONSerialization dataWithJSONObject:featureDict options:0 error:error];
                if (!featureData) {
                    return nil;
                }

                TFFeature *feature = (TFFeature *)[self decode:featureData error:error];
                if (!feature) {
                    return nil;
                }

                [features addObject:feature];
            }

            return [TFFeatureCollection featureCollectionWithFeatures:features];
        }
        case TFPrimitiveTypeGeometryCollection: {
            NSArray *geometryDictsArray = dict[TFGeometriesKey];
            if (!geometryDictsArray) {
                [self populateError:error withMessage:@"No geometries key found in GeometryCollection"];
                return nil;
            }

            NSMutableArray *geometries = [NSMutableArray new];
            for (NSDictionary *geometryDict in geometryDictsArray) {
                NSData *geometryData = [NSJSONSerialization dataWithJSONObject:geometryDict options:0 error:error];
                if (!geometryData) {
                    return nil;
                }

                TFGeometry *geometry = (TFGeometry *)[self decode:geometryData error:error];
                if (!geometry) {
                    return nil;
                }

                [geometries addObject:geometry];
            }

            return [TFGeometryCollection geometryCollectionWithGeometries:geometries];
        }
        default:
            NSAssert(NO, @"not yet implemented");
    }

    return nil;
}

+ (NSArray *)coordsFromDict:(NSDictionary *)dict error:(NSError **)error {
    NSArray *coords = dict[TFCoordinatesKey];
    if (!coords) {
        [self populateError:error withMessage:@"No coordinates property found."];
        return nil;
    }
    if ([coords count] < 1) {
        [self populateError:error withMessage:@"No coordinates found in coordinates property."];
        return nil;
    }
    return coords;
}

+ (void)populateError:(NSError **)error withMessage:(NSString *)message {
    if (*error != nil) {
        *error = [NSError errorWithDomain:TFTerraformerErrorDomain code:kTFTerraformerParseError userInfo:@{
                NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Could not parse GeoJSON: %@", message]
        }];
    }
}

+ (TFPoint *)parsePointCoordinates:(NSArray *)coords error:(NSError **)error {
    if ([coords count] < 2) {
        [self populateError:error withMessage:@"Not enough coordinates"];
        return nil;
    }

    if (![coords[0] isKindOfClass:[NSNumber class]] || ![coords[1] isKindOfClass:[NSNumber class]]) {
        [self populateError:error withMessage:@"Invalid value found in coordinates array."];
        return nil;
    }

    return [TFPoint pointWithCoordinates:coords];
}

+ (NSArray *)arrayOfPointCoordinates:(NSArray *)points {
    NSMutableArray *coords = [NSMutableArray new];
    for (TFPoint *point in points) {
        [coords addObject:point.coordinates];
    }
    return [coords copy];
}

+ (TFLineString *)parseLineStringCoordinates:(NSArray *)coords error:(NSError **)error {
    // we need at least 2 points to make a lineString
    if ([coords count] < 2) {
        [self populateError:error withMessage:@"Not enough points in coordinates array."];
        return nil;
    }

    // each item in the coordinates array must be a point
    NSMutableArray *points = [NSMutableArray new];
    for (NSArray *point in coords) {
        TFPoint *p = [self parsePointCoordinates:point error:error];
        if (!p) {
            // error will be hydrated by parsePoint
            return nil;
        }
        [points addObject:p];
    }

    return [TFLineString lineStringWithPoints:points];
}

+ (NSArray *)arrayOfLineStringCoordinates:(NSArray *)lineStrings {
    NSMutableArray *coords = [NSMutableArray new];
    for (TFLineString *ls in lineStrings) {
        [coords addObjectsFromArray:[self arrayOfPointCoordinates:ls.points]];
    }
    return [coords copy];
}

+ (TFPolygon *)parsePolygonCoordinates:(NSArray *)coords error:(NSError **)error {
    NSMutableArray *lineStrings = [NSMutableArray new];
    for (NSArray *lsCoords in coords) {
        TFLineString *lineString = [self parseLineStringCoordinates:lsCoords error:error];
        if (!lineString) {
            return nil;
        }
        [lineStrings addObject:lineString];
    }
    return [TFPolygon polygonWithLineStrings:lineStrings];
}

+ (NSArray *)arrayOfPolygonCoordinates:(NSArray *)polygons {
    NSMutableArray *coords = [NSMutableArray new];
    for (TFPolygon *poly in polygons) {
        [coords addObjectsFromArray:[self arrayOfLineStringCoordinates:poly.lineStrings]];
    }
    return [coords copy];
}

+ (NSString *)stringForType:(TFPrimitiveType)type {
    NSString *name;

    switch ( type ) {
        case TFPrimitiveTypePoint:
            name = @"Point";
            break;
        case TFPrimitiveTypeMultiPoint:
            name = @"MultiPoint";
            break;
        case TFPrimitiveTypeLineString:
            name = @"LineString";
            break;
        case TFPrimitiveTypeMultiLineString:
            name = @"MultiLineString";
            break;
        case TFPrimitiveTypePolygon:
            name = @"Polygon";
            break;
        case TFPrimitiveTypeMultiPolygon:
            name = @"MultiPolygon";
            break;
        case TFPrimitiveTypeGeometryCollection:
            name = @"GeometryCollection";
            break;
        case TFPrimitiveTypeFeature:
            name = @"Feature";
            break;
        case TFPrimitiveTypeFeatureCollection:
            name = @"FeatureCollection";
            break;
        default:
            NSAssert( NO, @"unknown type" );
    }

    return name;
}

+ (TFPrimitiveType)typeForString:(NSString *)string; {
    TFPrimitiveType type;

    if ( [string isEqualToString:@"Point"] ) {
        type = TFPrimitiveTypePoint;
    } else if ( [string isEqualToString:@"MultiPoint"] ) {
        type = TFPrimitiveTypeMultiPoint;
    } else if ( [string isEqualToString:@"LineString"] ) {
        type = TFPrimitiveTypeLineString;
    } else if ( [string isEqualToString:@"MultiLineString"] ) {
        type = TFPrimitiveTypeMultiLineString;
    } else if ( [string isEqualToString:@"Polygon"] ) {
        type = TFPrimitiveTypePolygon;
    } else if ( [string isEqualToString:@"MultiPolygon"] ) {
        type = TFPrimitiveTypeMultiPolygon;
    } else if ( [string isEqualToString:@"GeometryCollection"] ) {
        type = TFPrimitiveTypeGeometryCollection;
    } else if ( [string isEqualToString:@"Feature"] ) {
        type = TFPrimitiveTypeFeature;
    } else if ( [string isEqualToString:@"FeatureCollection"] ) {
        type = TFPrimitiveTypeFeatureCollection;
    } else {
        NSAssert( NO, @"unknown type" );
        type = TFPrimitiveTypeUnknown;
    }

    return type;
}

@end