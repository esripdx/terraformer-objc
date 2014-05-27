//
//  TFMultiPolygon.m
//  Terraformer
//
//  Created by mbcharbonneau on 5/22/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFMultiPolygon.h"
#import "TFGeometry+Protected.h"
#import "TFPolygon.h"

@implementation TFMultiPolygon

#pragma mark TFMultiPolygon

- (instancetype)initWithPolygonCoordinateArrays:(NSArray *)polygons;
{
    // See TFPolygon.m for a description of the polygon data structure.
    
    return [super initSubclassWithCoordinates:polygons];
}

- (instancetype)initWithPolygons:(NSArray *)polygons;
{
    NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:[polygons count]];
    
    for ( TFPolygon *polygon in polygons ) {
        [coordinates addObject:polygon.coordinates];
    }
    
    return [self initWithPolygonCoordinateArrays:polygons];
}

- (NSUInteger)numberOfPolygons;
{
    return [self.coordinates count];
}

- (TFPolygon *)polygonAtIndex:(NSUInteger)index;
{
    NSArray *coordinates = self.coordinates[index];
    NSArray *vertices = coordinates[0];
    NSArray *holes = [coordinates count] == 1 ? @[] : [coordinates subarrayWithRange:NSMakeRange( 1, [coordinates count] - 1 )];
    
    return [[TFPolygon alloc] initWithVertices:vertices holes:holes];
}

- (void)insertPolygon:(TFPolygon *)polygon atIndex:(NSUInteger)index;
{
    NSMutableArray *mutablePolygons = [self.coordinates mutableCopy];
    [mutablePolygons insertObject:polygon.coordinates atIndex:index];
    self.coordinates = [mutablePolygons copy];
}

- (void)removePolygonAtIndex:(NSUInteger)index;
{
    NSMutableArray *mutablePolygons = [self.coordinates mutableCopy];
    [mutablePolygons removeObjectAtIndex:index];
    self.coordinates = [mutablePolygons copy];
}

#pragma mark TFPrimitive

- (TFPrimitiveType)type;
{
    return TFPrimitiveTypeMultiPolygon;
}

@end
