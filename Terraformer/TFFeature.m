//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFFeature.h"
#import "TFGeometry.h"

@implementation TFFeature

- (instancetype)initWithGeometry:(NSObject<TFPrimitive> *)geometry {
    return [self initWithId:nil geometry:geometry properties:[NSDictionary new]];
}

- (instancetype)initWithGeometry:(NSObject<TFPrimitive> *)geometry properties:(NSDictionary *)properties {
    return [self initWithId:nil geometry:geometry properties:properties];
}

- (instancetype)initWithId:(NSString *)id geometry:(NSObject<TFPrimitive> *)geometry properties:(NSDictionary *)properties {
    if (self = [super init]) {
        _type = @"feature";
        _id = id;
        _geometry = geometry;
        _properties = properties;
    }
    return self;
}

@end