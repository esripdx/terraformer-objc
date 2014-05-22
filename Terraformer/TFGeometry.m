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

+ (instancetype)geometryWithType:(TFGeometryType)type coordinates:(NSArray *)coordinates;
{
    TFGeometry *geometry = nil;
    
    switch ( type ) {
        case TFGeometryTypePoint:
            geometry = [[TFPoint alloc] initSubclassOfType:type coordinates:coordinates];
            break;
        case TFGeometryTypeMultiPoint:
            break;
        case TFGeometryTypeLineString:
            break;
        case TFGeometryTypeMultiLineString:
            break;
        case TFGeometryTypePolygon:
            geometry = [[TFPolygon alloc] initSubclassOfType:type coordinates:coordinates];
            break;
        case TFGeometryTypeMultiPolygon:
            break;
        default:
            NSAssert( NO, @"not yet implemented" );
            break;
    }

    return geometry;
}

#pragma mark - TFPrimitive

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
