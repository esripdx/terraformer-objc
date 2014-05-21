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

- (BOOL)isClosed;

- (TFCoordinate *)vertexAtIndex:(NSUInteger)index;
- (void)insertVertex:(TFCoordinate *)coordinate atIndex:(NSUInteger)index;
- (void)removeVertexAtIndex:(NSUInteger)index;
- (void)close;

@end
