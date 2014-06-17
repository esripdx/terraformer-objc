//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPrimitive.h"

@class TFFeature;

@interface TFFeatureCollection : TFPrimitive

@property (copy, nonatomic) NSArray *features;

+ (instancetype)featureCollectionWithFeatures:(NSArray *)features;
- (instancetype)initWithFeatures:(NSArray *)features;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

- (void)addFeature:(TFFeature *)feature;
- (void)removeFeature:(TFFeature *)feature;
- (void)insertFeature:(TFFeature *)feature atIndex:(NSUInteger)idx;
@end