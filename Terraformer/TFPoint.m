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

+ (instancetype)pointWithCoordinate:(TFCoordinate *)coord
{
    return [[self alloc] initWithCoordinate:coord];
}

- (instancetype)initWithCoordinate:(TFCoordinate *)coord
{
    NSArray *coords = [NSArray arrayWithObject:coord];
    return [super initSubclassWithCoordinates:coords];
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
