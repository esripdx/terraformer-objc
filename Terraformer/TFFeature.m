//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFFeature.h"
#import "TFGeometry.h"
#import "TFPolygon.h"

@implementation TFFeature

+ (TFFeature *)featureWithGeometry:(id <TFPrimitive>)geometry {
    return [[TFFeature alloc] initWithGeometry:geometry];
}

+ (TFFeature *)featureWithGeometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties {
    return [[TFFeature alloc] initWithGeometry:geometry properties:properties];
}

+ (TFFeature *)featureWithIdentifier:(NSString *)identifier geometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties {
    return [[TFFeature alloc] initWithIdentifier:identifier geometry:geometry properties:properties];
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

#pragma mark - TFPrimitive

- (NSDictionary *)encodeJSON {
    return nil;
}

+ (id <TFPrimitive>)decodeJSON:(NSDictionary *)json {
    return nil;
}

- (NSArray *)bbox {
    return nil;
}

- (NSArray *)envelope {
    return nil;
}

- (TFPolygon *)convexHull {
    return nil;
}

- (BOOL)contains:(TFGeometry *)geometry {
    return NO;
}

- (BOOL)within:(TFGeometry *)geometry {
    return NO;
}

- (BOOL)intersects:(TFGeometry *)geometry {
    return NO;
}

- (TFPrimitiveType)type;
{
    return TFPrimitiveTypeFeature;
}

- (id <TFPrimitive>)toMercator {
    return nil;
}

- (id <TFPrimitive>)toGeographic {
    return nil;
}

@end