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

@implementation TFCoordinate {

}

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

- (BOOL)isEqual:(id)other
{
    if ([self x] == [other x] && [self y] == [other y]) {
        return true;
    } else {
        return false;
    }
}

@end