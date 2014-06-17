//
// Created by Josh Yaganeh on 5/23/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFMultiPoint.h"
#import "TFPoint.h"


@implementation TFMultiPoint

+ (instancetype)multiPointWithPoints:(NSArray *)points {
    return [[self alloc] initWithPoints:points];
}

- (instancetype)initWithPoints:(NSArray *)points {
    self = [super initWithType:TFPrimitiveTypeMultiPoint];
    if (self) {
        _points = [points copy];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.points[idx];
}

- (NSUInteger)count {
    return self.points.count;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    TFMultiPoint *o = other;
    return [self.points isEqualToArray:o.points];
}

- (NSUInteger)hash {
    return [self.points hash];
}

@end