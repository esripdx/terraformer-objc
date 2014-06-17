//
//  TFMultiPolygon.m
//  Terraformer
//
//  Created by mbcharbonneau on 5/22/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFMultiPolygon.h"

@implementation TFMultiPolygon

+ (instancetype)multiPolygonWithPolygons:(NSArray *)polygons {
    return [[self alloc] initWithPolygons:polygons];
}

- (instancetype)initWithPolygons:(NSArray *)polygons;
{
    self = [super initWithType:TFPrimitiveTypeMultiPolygon];
    if (self) {
        _polygons = [polygons copy];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.polygons[idx];
}

- (NSUInteger)count {
    return [self.polygons count];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    TFMultiPolygon *o = other;
    return [self.polygons isEqualToArray:o.polygons];
}

- (NSUInteger)hash {
    return [self.polygons hash];
}
@end
