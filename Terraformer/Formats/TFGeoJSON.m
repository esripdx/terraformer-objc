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

static NSString *const TFTypeKey = @"type";
static NSString *const TFCoordinatesKey = @"coordinates";
static NSString *const TFGeometryKey = @"geometry";
static NSString *const TFGeometriesKey = @"geometries";
static NSString *const TFFeaturesKey = @"features";
static NSString *const TFIdKey = @"id";
static NSString *const TFPropertiesKey = @"properties";

@implementation TFGeoJSON {

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

+ (TFPrimitiveType)typeForString:(NSString *)string;
{
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
    }

    return type;
}

+ (NSData *)encodePrimitive:(TFPrimitive *)primitive error:(NSError **)error {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[TFTypeKey] = [self stringForType:primitive.type];

    switch(primitive.type) {
        case TFPrimitiveTypePoint: {
            TFPoint *p = (TFPoint *) primitive;
            dict[TFCoordinatesKey] = p.coordinates;
            break;
        }
        default:
            NSAssert(NO, @"not yet implemented");
    }

    return [NSJSONSerialization dataWithJSONObject:dict options:nil error:error];
}

+ (TFPrimitive *)decode:(NSData *)data error:(NSError **)error {
    TFPrimitive *primitive;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:error];

    switch([self typeForString:dict[TFTypeKey]]) {
        case TFPrimitiveTypePoint: {
            NSArray *coords = dict[TFCoordinatesKey];
            primitive = [TFPoint pointWithX:[coords[0] doubleValue] y:[coords[1] doubleValue]];
            break;
        }
        default:
            NSAssert(NO, @"not yet implemented");
    }

    return primitive;
}

@end