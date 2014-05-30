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
#import "TFLineString.h"

@interface TFPolygon()

- (BOOL)containsPoint:(TFPoint *)point;
- (BOOL)containsLine:(TFLineString *)line;
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
    NSMutableArray *holes = [[self.coordinates subarrayWithRange:NSMakeRange( 1, [self.coordinates count] - 1 )] mutableCopy];
    [holes insertObject:hole.coordinates[0] atIndex:index];
    [holes insertObject:self.coordinates[0] atIndex:0];
    self.coordinates = [holes copy];
}

- (void)removeHoleAtIndex:(NSUInteger)index;
{
    NSMutableArray *holes = [[self.coordinates subarrayWithRange:NSMakeRange( 1, [self.coordinates count] - 1 )] mutableCopy];
    [holes removeObjectAtIndex:index];
    [holes insertObject:self.coordinates[0] atIndex:0];
    self.coordinates = [holes copy];
}

#pragma mark TFPolygon Private

- (BOOL)containsPoint:(TFPoint *)point;
{
    if ( [point.coordinates count] == 0 || [self.coordinates[0] count] == 0 )
        return NO;
    
    BOOL contains = NO;
    NSArray *outerRing = self.coordinates[0];
    NSInteger i, j, nvert = [outerRing count];
    
    for ( i = 0, j = nvert - 1; i < nvert; j = i++ ) {
        
        TFCoordinate *a = outerRing[i];
        TFCoordinate *b = outerRing[j];
        
        // Ray casting algorithm to determine if the point is inside the
        // polygon. For each edge with the coordinates a and b, check to see if
        // point.y is within a.y and b.y. If so, check to see if the point is
        // to the left of the edge. If this is also true, a line drawn from the
        // point to the right will intersect the edge-- if the line intersects
        // the polygon an odd number of times, it is inside.
        
        // If an edge is horizontal it will not pass the checkY test. This is
        // important, since otherwise you run the risk of dividing by zero in
        // the horizontal check.
        
        BOOL checkY = ( ( a.y >= point.y ) != ( b.y >= point.y ) );
        BOOL checkX = ( point.x <= ( b.x - a.x ) * ( point.y - a.y ) / ( b.y - a.y ) + a.x );
        
        if ( checkY && checkX ) {
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

- (BOOL)containsLine:(TFLineString *)line;
{
    NSInteger count = [line.coordinates count];
    BOOL contains = ( count == 0 ) ? NO : [self containsPoint:[TFPoint pointWithCoordinate:line.coordinates[0]]];

    if ( !contains ) {
        return NO;
    }
    
    if ( count == 1 ) {
        return contains;
    }
    
    // For each coordinate pair that makes up a line in the line string, test
    // it to see if it intersects a line within the polygon. If so, the line is
    // outside of the polygon.
    
    NSArray *outerRing = self.coordinates[0];
    NSInteger i, j, nvert = [outerRing count];
    
    for ( i = 0, j = nvert - 1; i < nvert; j = i++ ) {
        
        TFCoordinate *a = outerRing[i];
        TFCoordinate *b = outerRing[j];
        
        // Check holes as well.
        
        for ( i = 0; i < [self numberOfHoles]; i++ ) {
            TFPolygon *polygon = [self holeAtIndex:i];
            
            if ( [polygon containsL])
        }

    }
    
    return YES;
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
        case TFPrimitiveTypeLineString:
            contains = [self containsLine:(TFLineString *)geometry];
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
