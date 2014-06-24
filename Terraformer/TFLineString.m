//
//  TFLineString.m
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFLineString.h"
#import "TFPoint.h"

@implementation TFLineString

+ (instancetype)lineStringWithCoords:(NSArray *)coords {
    return [[self alloc] initWithCoords:coords];
}

- (instancetype)initWithCoords:(NSArray *)coords {
    NSMutableArray *points = [NSMutableArray new];
    for (NSArray *coord in coords) {
        [points addObject:[TFPoint pointWithCoordinates:coord]];
    }
    return [self initWithPoints:points];
}

- (instancetype)initWithPoints:(NSArray *)points {
    self = [super initWithType:TFPrimitiveTypeLineString];
    if (self) {
        _points = [points copy];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.points[idx];
}

- (NSUInteger)count {
    return [self.points count];
}


+ (instancetype)lineStringWithPoints:(NSArray *)points {
    return [[self alloc] initWithPoints:points];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    TFLineString *o = other;
    return [self.points isEqualToArray:o.points];
}

- (NSUInteger)hash {
    return [self.points hash];
}

/*

 A LinearRing is closed LineString with 4 or more positions. 
 The first and last positions are equivalent (they represent equivalent points). 
 Though a LinearRing is not explicitly represented as a GeoJSON geometry type, 
 it is referred to in the Polygon geometry type definition.

 */
- (BOOL)isLinearRing
{
    if ([self.points count] > 3) {
        TFPoint *first = (TFPoint *)self.points[0];
        TFPoint *last = (TFPoint *)self.points[[self.points count]-1];
        return [first isEqual:last];
    }
    return NO;
}

- (void)closeRing {
    if (![self isLinearRing]) {
        self.points = [self.points arrayByAddingObject:self.points[0]];
    }
}

@end
