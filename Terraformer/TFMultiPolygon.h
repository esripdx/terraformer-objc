//
//  TFMultiPolygon.h
//  Terraformer
//
//  Created by mbcharbonneau on 5/22/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@class TFPolygon;

@interface TFMultiPolygon : TFGeometry

- (instancetype)initWithPolygonCoordinateArrays:(NSArray *)polygons;
- (instancetype)initWithPolygons:(NSArray *)polygons;

// Convenience methods to polygons as TFPolygon objects. Use
// multiPolygon.coordinates to access the coordinates array directly.

- (NSUInteger)numberOfPolygons;
- (TFPolygon *)polygonAtIndex:(NSUInteger)index;
- (void)insertPolygon:(TFPolygon *)polygon atIndex:(NSUInteger)index;
- (void)removePolygonAtIndex:(NSUInteger)index;

@end
