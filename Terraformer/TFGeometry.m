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

+ (NSString *)geoJSONStringForType:(TFGeometryType)type;
{
    NSString *name;
    
    switch ( type ) {
        case TFGeometryTypePoint:
            name = @"Point";
            break;
        case TFGeometryTypeMultiPoint:
            name = @"MultiPoint";
            break;
        case TFGeometryTypeLineString:
            name = @"LineString";
            break;
        case TFGeometryTypeMultiLineString:
            name = @"MultiLineString";
            break;
        case TFGeometryTypePolygon:
            name = @"Polygon";
            break;
        case TFGeometryTypeMultiPolygon:
            name = @"MultiPolygon";
            break;
        case TFGeometryTypeGeometryCollection:
            name = @"GeometryCollection";
            break;
        default:
            NSAssert( NO, @"unhandled type" );
            break;
    }
    
    return name;
}

+ (TFGeometryType)geometryTypeForString:(NSString *)string;
{
    TFGeometryType type;
    
    if ( [string isEqualToString:@"Point"] ) {
        type = TFGeometryTypePoint;
    } else if ( [string isEqualToString:@"MultiPoint"] ) {
        type = TFGeometryTypeMultiPoint;
    } else if ( [string isEqualToString:@"LineString"] ) {
        type = TFGeometryTypeLineString;
    } else if ( [string isEqualToString:@"MultiLineString"] ) {
        type = TFGeometryTypeMultiLineString;
    } else if ( [string isEqualToString:@"Polygon"] ) {
        type = TFGeometryTypePolygon;
    } else if ( [string isEqualToString:@"MultiPolygon"] ) {
        type = TFGeometryTypeMultiPolygon;
    } else if ( [string isEqualToString:@"GeometryCollection"] ) {
        type = TFGeometryTypeGeometryCollection;
    } else {
        NSAssert( NO, @"unhandled type" );
    }
    
    return type;
}

+ (instancetype)geometryWithType:(TFGeometryType)type coordinates:(NSArray *)coordinates;
{
    TFGeometry *geometry = nil;
    
    switch ( type ) {
        case TFGeometryTypePoint:
            geometry = [[TFPoint alloc] initSubclassWithCoordinates:coordinates];
            break;
        case TFGeometryTypeLineString:
            geometry = [[TFLineString alloc] initSubclassWithCoordinates:coordinates];
            break;
        case TFGeometryTypePolygon:
            geometry = [[TFPolygon alloc] initSubclassWithCoordinates:coordinates];
            break;
        case TFGeometryTypeGeometryCollection:
        case TFGeometryTypeMultiPoint:
        case TFGeometryTypeMultiPolygon:
        case TFGeometryTypeMultiLineString:
        default:
            NSAssert( NO, @"not yet implemented" );
            break;
    }

    return geometry;
}

#pragma mark - TFPrimitive

- (TFGeometryType)type {
    NSAssert( NO, @"abstract method" );
    return 0;
}

- (NSDictionary *)encodeJSON {
    return @{TFTypeKey: [[self class] geoJSONStringForType:self.type],
             TFCoordinatesKey: self.coordinates};
}

+ (id <TFPrimitive>)decodeJSON:(NSDictionary *)json {
    TFGeometryType type = [self geometryTypeForString:json[TFTypeKey]];
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
