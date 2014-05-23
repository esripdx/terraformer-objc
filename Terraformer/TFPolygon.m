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
#import "TFPoint.h"

@interface TFPolygon()

- (BOOL)containsPoint:(TFPoint *)point;
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

- (BOOL)isEqualToPolygon:(TFPolygon *)other;
{
    // This method isn't exactly correct... we need to compare after reducing
    // both polygons to their simplest form, or use some other strategy.
    
    return [self.coordinates isEqualToArray:other.coordinates];
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

- (BOOL)containsPoint:(TFPoint *)point;
{
    if ( [point.coordinates count] == 0 || [self.coordinates[0] count] == 0 )
        return NO;
    
    // Check to see if the point is within the polygon's coordinates. A point
    // on the boundry is considered outside.
    
    BOOL contains = NO;
    NSArray *outerRing = self.coordinates[0];
    NSInteger i, j, nvert = [outerRing count];
    
    for ( i = 0, j = nvert - 1; i < nvert; j = i++ ) {
        
        TFCoordinate *a = outerRing[i];
        TFCoordinate *b = outerRing[j];
        
        if ( ( ( a.y >= point.y ) != ( b.y >= point.y ) ) && ( point.x <= ( b.x - a.x ) * ( point.y - a.y ) / ( b.y - a.y ) + a.x ) ) {
            contains = !contains;
        }
    }
    
    if ( !contains ) {
        return NO;
    }
    
    // If the point is within the outer ring, check each hole in the polygon.
    
    for ( i = 0; i < [self numberOfHoles]; i++ ) {
        
        TFPolygon *polygon = [self holeAtIndex:i];
        
        if ( [polygon containsPoint:point] ) {
            contains = NO;
            break;
        }
    }
    
    return contains;
}

- (BOOL)polygonWithin:(TFPolygon *)polygon;
{
    if ( [self isEqualToPolygon:polygon] ) {
        return YES;
    }
    
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
    BOOL contains;
    
    switch ( geometry.type ) {
        case TFPrimitiveTypePoint:
            contains = [self containsPoint:(TFPoint *)geometry];
            break;
        default:
            NSAssert( NO, @"unhandled type" );
            break;
    }
    
    return contains;
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
    if ( object == self ) {
        return YES;
    }
    
    if ( object == nil || ![object isKindOfClass:[self class]] ) {
        return NO;
    }
    
    return [self isEqualToPolygon:object];
}

- (NSUInteger)hash;
{
    return [self.coordinates hash];
}

@end
