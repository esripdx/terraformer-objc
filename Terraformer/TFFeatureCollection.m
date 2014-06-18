//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFFeatureCollection.h"
#import "TFFeature.h"


@implementation TFFeatureCollection {
}

+ (instancetype)featureCollectionWithFeatures:(NSArray *)features {
    return [[self alloc] initWithFeatures:features];
}

- (instancetype)initWithFeatures:(NSArray *)features {
    self = [super initWithType:TFPrimitiveTypeFeatureCollection];
    if (self) {
        _features = [features copy];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.features[idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    NSParameterAssert([obj isKindOfClass:[TFFeature class]]);

    NSMutableArray *f = [self.features mutableCopy];
    f[idx] = obj;
    self.features = f;
}

- (NSUInteger)count {
    return [self.features count];
}

- (void)addFeature:(TFFeature *)feature {
    self.features = [self.features arrayByAddingObject:feature];
}

- (void)removeFeature:(TFFeature *)feature {
    NSMutableArray *f = [self.features mutableCopy];
    [f removeObject:feature];
    self.features = f;
}

- (void)insertFeature:(TFFeature *)feature atIndex:(NSUInteger)idx {
    NSMutableArray *f = [self.features mutableCopy];
    [f insertObject:feature atIndex:idx];
    self.features = f;
}

@end