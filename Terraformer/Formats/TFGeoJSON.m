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
        default:
            NSAssert(NO, @"not yet implemented");
    }

    return nil;
}

+ (NSArray *)coordsFromDict:(NSDictionary *)dict error:(NSError **)error {
    NSArray *coords = dict[TFCoordinatesKey];
    if (!coords) {
        *error = [self errorWithMessage:@"No coordinates property found."];
        return nil;
    }
    if ([coords count] < 1) {
        *error = [self errorWithMessage:@"No coordinates found in coordinates property."];
        return nil;
    }
    return coords;
}

+ (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:TFTerraformerErrorDomain code:kTFTerraformerParseError userInfo:@{
            NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Could not parse GeoJSON: %@", message]
    }];
}

+ (TFPoint *)parsePointCoordinates:(NSArray *)coords error:(NSError **)error {
    if ([coords count] < 2) {
        *error = [self errorWithMessage:@"Not enough coordinates"];
        return nil;
    }

    if (![coords[0] isKindOfClass:[NSNumber class]] || ![coords[1] isKindOfClass:[NSNumber class]]) {
        *error = [self errorWithMessage:@"Invalid value found in coordinates array."];
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
        *error = [self errorWithMessage:@"Not enough points in coordinates array."];
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