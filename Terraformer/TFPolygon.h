//
//  TFPolygon.h
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@class TFCoordinate;

@interface TFPolygon : TFGeometry

- (instancetype)initWithVertices:(NSArray *)coordinates;
- (instancetype)initWithVertices:(NSArray *)coordinates holes:(NSArray *)polygons;

- (BOOL)isEqualToPolygon:(TFPolygon *)other;
- (BOOL)isClosed;

- (void)close;

- (NSUInteger)numberOfVertices;
- (TFCoordinate *)vertexAtIndex:(NSUInteger)index;
- (void)insertVertex:(TFCoordinate *)coordinate atIndex:(NSUInteger)index;
- (void)removeVertexAtIndex:(NSUInteger)index;

- (NSUInteger)numberOfHoles;
- (TFPolygon *)holeAtIndex:(NSUInteger)index;
- (void)insertHole:(TFPolygon *)hole atIndex:(NSUInteger)index;
- (void)removeHoleAtIndex:(NSUInteger)index;

@end
