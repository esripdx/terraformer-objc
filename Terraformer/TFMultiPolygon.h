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

@property (copy, nonatomic) NSArray *polygons;

+ (instancetype)multiPolygonWithPolygons:(NSArray *)polygons;
- (instancetype)initWithPolygons:(NSArray *)polygons;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;
@end
