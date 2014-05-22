//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFFeature.h"
#import "TFGeometry.h"

@implementation TFFeature

+ (TFFeature *)featureWithGeometry:(id <TFPrimitive>)geometry {
    return [[TFFeature alloc] initWithGeometry:geometry];
}

+ (TFFeature *)featureWithGeometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties {
    return [[TFFeature alloc] initWithGeometry:geometry properties:properties];
}

+ (TFFeature *)featureWithID:(NSString *)identifier geometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties {
    return [[TFFeature alloc] initWithID:identifier geometry:geometry properties:properties];
}

- (instancetype)initWithGeometry:(id <TFPrimitive>)geometry {
    return [self initWithIdentifier:nil geometry:geometry properties:[NSDictionary new]];
}

- (instancetype)initWithGeometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties {
    return [self initWithIdentifier:nil geometry:geometry properties:properties];
}

- (instancetype)initWithIdentifier:(NSString *)identifier geometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties {
    if (self = [super init]) {
        _identifier = identifier;
        _geometry = geometry;
        _properties = properties;
    }
    return self;
}

- (TFPrimitiveType)type;
{
    return TFPrimitiveTypeFeature;
}

@end