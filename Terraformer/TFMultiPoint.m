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
    if (self = [super init]) {
        if (points == nil) {
            points = @[];
        }

        NSMutableArray *coordinates = [NSMutableArray new];
        for (TFPoint *p in points) {
            [coordinates addObject:p.coordinate];
        }
        self.coordinates = coordinates;
    }
    return self;
}

- (void)addPointWithX:(double)x y:(double)y {
    NSMutableArray *c = [self.coordinates mutableCopy];
    [c addObject:[TFCoordinate coordinateWithX:x y:y]];
    self.coordinates = [c copy];
}

- (void)removePointAtIndex:(NSUInteger)idx {
    NSMutableArray *c = [self.coordinates mutableCopy];
    [c removeObjectAtIndex:idx];
    self.coordinates = [c copy];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.coordinates[idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    NSMutableArray *c = [self.coordinates mutableCopy];
    c[idx] = obj;
    self.coordinates = [c copy];
}

- (NSUInteger)count {
    return self.coordinates.count;
}


- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    TFMultiPoint *o = other;
    return [self.coordinates isEqualToArray:o.coordinates];
}

- (NSUInteger)hash {
    return [self.coordinates hash];
}


@end