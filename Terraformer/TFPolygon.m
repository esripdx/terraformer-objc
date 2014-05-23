//
//  TFPolygon.m
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPolygon.h"
#import "TFGeometry+Protected.h"
#import "TFCoordinate.h"
#import "TFMultiPolygon.h"

@interface TFPolygon()

- (BOOL)polygonWithin:(TFPolygon *)polygon;
- (BOOL)multiPolygonWithin:(TFMultiPolygon *)multiPolygon;

@end

@implementation TFPolygon

#pragma mark TFPolygon

- (instancetype)initWithVertices:(NSArray *)coordinates;
{
    return [self initWithVertices:coordinates holes:nil];
}

- (instancetype)initWithVertices:(NSArray *)coordinates holes:(NSArray *)polygons;
{
    // The polygon object is represented by an array of arrays. The first array
    // represents the polygon's coordinates, each subsequent array represents
    // a hole within the polygon.
    
    if ( coordinates == nil ) {
        coordinates = @[];
    }
    
    NSMutableArray *storage = [[NSMutableArray alloc] initWithObjects:coordinates, nil];
    
    for ( NSArray *array in polygons ) {
        NSParameterAssert( [array isKindOfClass:[NSArray class]] );
        [storage addObject:array];
    }
    
    return [super initSubclassWithCoordinates:storage];
}

- (BOOL)hasHoles;
{
    return ( [self.coordinates count] > 1 );
}

- (BOOL)isClosed;
{
    if ( [self.coordinates count] < 1 || [self.coordinates[0] count] < 2 ) {
        return NO;
    }
    
    NSArray *vertices = [self.coordinates firstObject];
    
    return [[vertices firstObject] isEqual:[vertices lastObject]];
}

- (TFCoordinate *)vertexAtIndex:(NSUInteger)index;
{
    NSArray *vertices = [self.coordinates firstObject];
    return [vertices objectAtIndex:index];
}

- (void)insertVertex:(TFCoordinate *)coordinate atIndex:(NSUInteger)index;
{
    NSParameterAssert( coordinate != nil );
    
    NSMutableArray *storage = [self.coordinates mutableCopy];
    NSMutableArray *vertices = [storage[0] mutableCopy];
    
    [vertices insertObject:coordinate atIndex:index];
    [storage replaceObjectAtIndex:0 withObject:[vertices copy]];
    
    self.coordinates = [storage copy];
}

- (void)removeVertexAtIndex:(NSUInteger)index;
{
    NSMutableArray *storage = [self.coordinates mutableCopy];
    NSMutableArray *vertices = [storage[0] mutableCopy];
    
    [vertices removeObjectAtIndex:index];
    [storage replaceObjectAtIndex:0 withObject:[vertices copy]];
    
    self.coordinates = [storage copy];
}

- (void)close;
{
    NSArray *vertices = [self.coordinates firstObject];
    
    if ( self.isClosed || [vertices count] < 2 ) {
        return;
    }
    
    TFCoordinate *origin = [vertices firstObject];
    [self insertVertex:origin atIndex:[vertices count]];
}

- (NSUInteger)numberOfVertices;
{
    return [[self.coordinates firstObject] count];
}

- (NSUInteger)numberOfHoles;
{
    return [self.coordinates count] - 1;
}

- (TFPolygon *)holeAtIndex:(NSUInteger)index;
{
    NSArray *coordinates = self.coordinates[index + 1];
    TFPolygon *polygon = [[TFPolygon alloc] initWithVertices:coordinates];
    
    return polygon;
}

- (void)insertHole:(TFPolygon *)hole atIndex:(NSUInteger)index;
{
#warning stub method
}

- (void)removeHoleAtIndex:(NSUInteger)index;
{
#warning stub method
}

#pragma mark TFPolygon Private

- (BOOL)polygonWithin:(TFPolygon *)polygon;
{
#warning stub
    return NO;
}

- (BOOL)multiPolygonWithin:(TFMultiPolygon *)multiPolygon;
{
#warning stub
    return NO;
}

#pragma mark TFPrimitive

- (TFPrimitiveType)type;
{
    return TFPrimitiveTypePolygon;
}

- (NSDictionary *)encodeJSON;
{
    return @{ TFTypeKey : [[self class] geoJSONStringForType:self.type],
              TFCoordinatesKey: self.coordinates };
}

+ (id <TFPrimitive>)decodeJSON:(NSDictionary *)json;
{
#warning stub method
    return nil;
}

- (BOOL)contains:(TFGeometry *)geometry;
{
#warning stub method
    return NO;
}

- (BOOL)within:(TFGeometry *)geometry;
{
    BOOL within;
    
    switch ( geometry.type ) {
        case TFPrimitiveTypePolygon:
            within = [self polygonWithin:(TFPolygon *)geometry];
            break;
        case TFPrimitiveTypeMultiPolygon:
            within = [self multiPolygonWithin:(TFMultiPolygon *)geometry];
            break;
        default:
            NSAssert( NO, @"unhandled type" );
            break;
    }
    
    return within;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object;
{
#warning stub
    return NO;
}

- (NSUInteger)hash;
{
#warning stub
    return 1;
}

@end
