//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFFeatureCollection.h"
#import "TFFeature.h"


@implementation TFFeatureCollection {
}

- (instancetype)initWithFeatures:(NSArray *)features {
    if (self = [super init]) {
        _features = features;
        _type = @"FeatureCollection";
    }
    return self;
}

+ (instancetype)decodeJSON:(NSDictionary *)json {
    return [[self alloc] initWithFeatures:json[TFFeaturesKey]];
}

- (void)addFeature:(TFFeature *)feature {
    self.features = [self.features arrayByAddingObject:feature];
}

- (void)removeFeature:(TFFeature *)feature {
    NSMutableArray *f = [self.features mutableCopy];
    [f removeObject:feature];
    self.features = f;
}

- (void)removeFeatureAtIndex:(NSUInteger)index {
    NSMutableArray *f = [self.features mutableCopy];
    [f removeObjectAtIndex:index];
    self.features = f;
}

- (NSDictionary *)encodeJSON {
    return @{TFTypeKey: self.type,
             TFFeaturesKey: self.features};
}


@end