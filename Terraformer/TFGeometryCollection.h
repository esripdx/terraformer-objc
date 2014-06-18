//
//  TFGeometryCollection
//  Terraformer
//
//  Created by ryana on 5/21/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFGeometry.h"

@interface TFGeometryCollection : TFGeometry

@property (nonatomic, copy) NSArray *geometries;

+ (instancetype)geometryCollectionWithGeometries:(NSArray *)geometries;
- (instancetype)initWithGeometries:(NSArray *)geometries;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

- (void)addGeometry:(TFGeometry *)geometry;
- (void)removeGeometry:(TFGeometry *)geometry;
- (void)insertGeometry:(TFGeometry *)geometry atIndex:(NSUInteger)idx;

@end