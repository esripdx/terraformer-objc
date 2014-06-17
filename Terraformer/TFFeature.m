//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFFeature.h"

@implementation TFFeature

+ (TFFeature *)featureWithGeometry:(TFGeometry *)geometry {
    return [[self alloc] initWithGeometry:geometry];
}

+ (TFFeature *)featureWithGeometry:(TFGeometry *)geometry properties:(NSDictionary *)properties {
    return [[self alloc] initWithGeometry:geometry properties:properties];
}

+ (TFFeature *)featureWithGeometry:(TFGeometry *)geometry properties:(NSDictionary *)properties identifier:(NSString *)identifier {
    return [[self alloc] initWithGeometry:geometry properties:properties identifier:identifier];
}

- (instancetype)initWithGeometry:(TFGeometry *)geometry {
    return [self initWithGeometry:geometry properties:nil];
}

- (instancetype)initWithGeometry:(TFGeometry *)geometry properties:(NSDictionary *)properties {
    return [self initWithGeometry:geometry properties:properties identifier:nil];
}

- (instancetype)initWithGeometry:(TFGeometry *)geometry properties:(NSDictionary *)properties identifier:(NSString *)identifier {
    self = [super initWithType:TFPrimitiveTypeFeature];
    if (self) {
        _geometry = geometry;
        _properties = [properties copy];
        _identifier = [identifier copy];
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    TFFeature *o = other;
    if (![o.properties isEqualToDictionary:self.properties]) {
        return NO;
    }
    if (![o.identifier isEqualToString:self.identifier]) {
        return NO;
    }
    return [self.geometry isEqual:o.geometry];
}

- (NSUInteger)hash {
    return [self.geometry hash] + [self.identifier hash] + [self.properties hash];
}

@end