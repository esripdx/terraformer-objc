//
//  TFGeometryCollection
//  Terraformer
//
//  Created by ryana on 5/21/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFGeometry;

@interface TFGeometryCollection : TFGeometry

@property (nonatomic, copy) NSArray *geometries;

- (instancetype)initWithGeometries:(NSArray *)geometries;

- (void)addGeometry:(TFGeometry *)geometry;

- (void)removeGeometry:(TFGeometry *)geometry;

@end