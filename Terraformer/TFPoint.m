//
//  TFPoint.m
//  Terraformer
//
//  Created by Courtf on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPoint.h"

@implementation TFPoint

#pragma mark TFPoint

+ (instancetype)pointWithX:(double)x y:(double)y
{
    return [[self alloc] initWithX:x y:y];
}

- (instancetype)initWithX:(double)x y:(double)y
{
    return [self initWithCoordinates:@[@(x), @(y)]];
}

+ (instancetype)pointWithX:(double)x y:(double)y z:(double)z {
    return [[self alloc] initWithX:x y:y z:z];
}

- (instancetype)initWithX:(double)x y:(double)y z:(double)z {
    return [self initWithCoordinates:@[@(x), @(y), @(z)]];
}

+ (instancetype)pointWithX:(double)x y:(double)y z:(double)z m:(double)m {
    return [[self alloc] initWithX:x y:y z:z m:m];
}

- (instancetype)initWithX:(double)x y:(double)y z:(double)z m:(double)m {
    return [self initWithCoordinates:@[@(x), @(y), @(z), @(m)]];
}

+ (instancetype)pointWithLatitude:(double)lat longitude:(double)lng {
    return [[self alloc] initWithLatitude:lat longitude:lng];
}

- (instancetype)initWithLatitude:(double)lat longitude:(double)lng {
    return [self initWithX:lng y:lat];
}

+ (instancetype)pointWithCoordinates:(NSArray *)coordinates {
    return [[self alloc] initWithCoordinates:coordinates];
}

- (instancetype)initWithCoordinates:(NSArray *)coordinates {
    self = [super initWithType:TFPrimitiveTypePoint];
    if (self) {
        _coordinates = [coordinates copy];
    }

    return self;
}

- (NSNumber *)x {
    if ([self.coordinates count] == 0) {
        return nil;
    }
    return self.coordinates[0];
}

- (NSNumber *)y {
    if ([self.coordinates count] < 2) {
        return nil;
    }
    return self.coordinates[1];
}

- (NSNumber *)latitude {
    return self.y;
}

- (NSNumber *)longitude {
    return self.x;
}

- (NSNumber *)z {
    if ([self.coordinates count] < 3) {
        return nil;
    }
    return self.coordinates[2];
}

- (NSNumber *)m {
    if ([self.coordinates count] < 4) {
        return nil;
    }
    return self.coordinates[3];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.coordinates[idx];
}

- (NSUInteger)count {
    return [self.coordinates count];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (object == nil || ![object isKindOfClass:[self class]]) {
        return NO;
    }

    TFPoint *otherPoint = object;

    return ([self.x doubleValue] == [otherPoint.x doubleValue] &&
            [self.y doubleValue] == [otherPoint.y doubleValue] &&
            [self.z doubleValue] == [otherPoint.z doubleValue] &&
            [self.m doubleValue] == [otherPoint.m doubleValue]);
}

- (NSUInteger)hash;
{
    NSUInteger prime = 31;
    NSUInteger result = 1;

    if ([self.coordinates count] > 0) {
        result += prime * result + [self.coordinates[0] hash];
        if ([self.coordinates count] > 1) {
            result += prime * result + [self.coordinates[1] hash];
            if ([self.coordinates count] > 2) {
                result += prime * result + [self.coordinates[2] hash];
                if ([self.coordinates count] > 3) {
                    result += prime * result + [self.coordinates[3] hash];
                }
            }
        }
    }

    return result;
}

- (NSString *)debugDescription;
{
    return [NSString stringWithFormat:@"<%@: %p, x=%f y=%f>", NSStringFromClass( [self class] ), self, [self.x doubleValue], [self.y doubleValue]];
}

@end
