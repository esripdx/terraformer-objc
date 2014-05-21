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

@interface TFPolygon()

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
    
    if ( coordinates == nil )
        coordinates = @[];
    
    NSMutableArray *storage = [[NSMutableArray alloc] initWithObjects:coordinates, nil];
    
    for ( NSArray *array in polygons ) {
        NSParameterAssert( [array isKindOfClass:[NSArray class]] );
        [storage addObject:array];
    }
    
    return [super initWithType:@"Polygon" coordinates:storage];
}

- (BOOL)hasHoles;
{
    return ( [self.coordinates count] > 1 );
}

- (BOOL)isClosed;
{
    if ( [self.coordinates count] < 1 || [self.coordinates[0] count] < 2 )
        return NO;
    
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
    
    if ( self.isClosed || [vertices count] < 2 )
        return;
    
    TFCoordinate *origin = [vertices firstObject];
    [self insertVertex:origin atIndex:[vertices count]];
}

- (NSUInteger)numberOfVertices;
{
    return [[self.coordinates firstObject] count];
}

#pragma mark TFGeometry
#pragma mark TFPrimitive

- (NSDictionary *)encodeJSON;
{
#warning stub method
    return nil;
}

+ (id <TFPrimitive>)decodeJSON:(NSDictionary *)json;
{
#warning stub method
    return nil;
}

@end
