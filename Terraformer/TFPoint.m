//
//  TFPoint.m
//  Terraformer
//
//  Created by Courtf on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPoint.h"
#import "TFGeometry+Protected.h"

@implementation TFPoint

#pragma mark TFPoint

+ (instancetype)pointWithX:(double)x y:(double)y
{
    return [[self alloc] initWithX:x y:y];
}

- (instancetype)initWithX:(double)x y:(double)y
{
    return [self initWithCoordinate:[TFCoordinate coordinateWithX:x y:y]];
}

+ (instancetype)pointWithCoordinate:(TFCoordinate *)coordinate
{
    return [[self alloc] initWithCoordinate:coordinate];
}

- (instancetype)initWithCoordinate:(TFCoordinate *)coordinate
{
    return (TFPoint *) [super initSubclassWithCoordinates:@[coordinate]];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (object == nil || ![object isKindOfClass:[self class]]) {
        return NO;
    }

    return (self.x == [object x] && self.y == [object y]);
}

- (NSUInteger)hash {
    return [self.coordinates[0] hash];
}

- (double)x {
    return ((TFCoordinate *)self.coordinates[0]).x;
}

- (double)y {
    return ((TFCoordinate *)self.coordinates[0]).y;
}


#pragma mark TFPrimitive

- (TFPrimitiveType)type {
    return TFPrimitiveTypePoint;
}

- (NSArray *)bbox {
    TFCoordinate *tfc = (TFCoordinate *)self.coordinates[0];
    return @[@(tfc.x),
             @(tfc.y),
             @(tfc.x),
             @(tfc.y)];
}

- (NSArray *)envelope {
    TFCoordinate *tfc = (TFCoordinate *)self.coordinates[0];
    return @[@(tfc.x),
             @(tfc.y),
             @(0),
             @(0)];
}

@end
