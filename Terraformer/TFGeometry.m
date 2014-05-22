//
//  TFGeometry.m
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"
#import "TFGeometry+Protected.h"
#import "TFLineString.h"
#import "TFPoint.h"
#import "TFPolygon.h"

@implementation TFGeometry

+ (NSString *)geoJSONStringForType:(TFPrimitiveType)type;
{
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
        default:
            NSAssert( NO, @"unhandled type" );
            break;
    }
    
    return name;
}

+ (TFPrimitiveType)geometryTypeForString:(NSString *)string;
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
    } else {
        NSAssert( NO, @"unhandled type" );
    }
    
    return type;
}

+ (instancetype)geometryWithType:(TFPrimitiveType)type coordinates:(NSArray *)coordinates;
{
    TFGeometry *geometry = nil;
    
    switch ( type ) {
        case TFPrimitiveTypePoint:
            geometry = [[TFPoint alloc] initSubclassWithCoordinates:coordinates];
            break;
        case TFPrimitiveTypeLineString:
            geometry = [[TFLineString alloc] initSubclassWithCoordinates:coordinates];
            break;
        case TFPrimitiveTypePolygon:
            geometry = [[TFPolygon alloc] initSubclassWithCoordinates:coordinates];
            break;
        case TFPrimitiveTypeGeometryCollection:
        case TFPrimitiveTypeMultiPoint:
        case TFPrimitiveTypeMultiPolygon:
        case TFPrimitiveTypeMultiLineString:
        default:
            NSAssert( NO, @"not yet implemented" );
            break;
    }

    return geometry;
}

#pragma mark - TFPrimitive

- (TFPrimitiveType)type {
    NSAssert( NO, @"abstract method" );
    return 0;
}

- (NSDictionary *)encodeJSON {
    return @{TFTypeKey: [[self class] geoJSONStringForType:self.type],
             TFCoordinatesKey: self.coordinates};
}

+ (id <TFPrimitive>)decodeJSON:(NSDictionary *)json {
    TFPrimitiveType type = [self geometryTypeForString:json[TFTypeKey]];
    return [self geometryWithType:type coordinates:json[TFCoordinatesKey]];
}

- (NSArray *)bbox {
    return [[self class] boundsForArray:self.coordinates];
}

- (NSArray *)envelope {
    return [[self class] envelopeForArray:self.coordinates];
}

- (TFPolygon *)convexHull {
    TFPolygon *hull;
    
    // todo
    
    return hull;
}

- (BOOL)contains:(TFGeometry *)geometry {
    
    // todo
    
    return NO;
}

- (BOOL)within:(TFGeometry *)geometry {
    
    // todo
    
    return NO;
}

- (BOOL)intersects:(TFGeometry *)geometry {
    
    // todo
    
    return NO;
}

@end
