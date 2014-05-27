//
//  TFCoordinate
//  Terraformer
//
//  Created by ryana on 5/21/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFCoordinate.h"

@interface TFCoordinate()
@property (strong, nonatomic) NSArray *coordinates;
@end

// Helpers for coordinate conversion

double degToRad(double d) {
    return (d * M_PI) / 180.0;
}

double radToDeg(double r) {
    return (r * 180.0) / M_PI;
}

@implementation TFCoordinate

+ (instancetype)coordinateWithX:(double)x y:(double)y {
    return [[self alloc] initWithX:x y:y];
}

- (NSArray *)encodeJSON {
    return self.coordinates;
}

+ (instancetype)decodeJSON:(NSArray *)json {
    if ([json count] >= 2) {
        NSNumber *x = json[0];
        NSNumber *y = json[1];
        if ([x isKindOfClass:[NSNumber class]] &&
                [y isKindOfClass:[NSNumber class]]) {
            return [self coordinateWithX:[x doubleValue] y:[y doubleValue]];
        }
    }
    return nil;
}

- (instancetype)initWithX:(double)x y:(double)y {
    if (self = [super init]) {
        _coordinates = [NSArray arrayWithObjects:@(x), @(y), nil];
    }
    return self;
}

- (double)x {
    return [[self.coordinates objectAtIndex:0] doubleValue];
}

- (double)y {
    return [[self.coordinates objectAtIndex:1] doubleValue];
}

- (TFCoordinate *)toGeographic {
    double r = radToDeg(self.x / TFEarthRadius);
    double x = r - (floor((r + 180.0) / 360.0) * 360.0);
    double y = radToDeg((M_PI / 2.0) - (2.0 * atan(exp(-1.0 * self.y / TFEarthRadius))));
    return [TFCoordinate coordinateWithX:x y:y];
}

- (TFCoordinate *)toMercator {
    double x = degToRad(self.x) * TFEarthRadius;
    double y = (TFEarthRadius / 2.0) * log( (1.0 + sin(degToRad(self.y))) / (1.0 - sin(degToRad(self.y))) );
    return [TFCoordinate coordinateWithX:x y:y];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object;
{
    if ( object == self ) {
        return YES;
    }

    if ( object == nil || ![object isKindOfClass:[self class]] ) {
        return NO;
    }

    return ( self.x == [object x] && self.y == [object y] );
}

- (NSUInteger)hash;
{
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result += prime * result + [self.coordinates[0] hash];
    result += prime * result + [self.coordinates[1] hash];

    return result;
}

- (NSString *)debugDescription;
{
    return [NSString stringWithFormat:@"<%@: %p, x=%f y=%f>", NSStringFromClass( [self class] ), self, self.x, self.y];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    // As long as TFCoordinate is immutable, we can return self instead of a
    // new object.
    return self;
}

@end

