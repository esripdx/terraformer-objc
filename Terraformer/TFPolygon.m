//
//  TFPolygon.m
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPolygon.h"

@implementation TFPolygon

#pragma mark TFPolygon

+ (instancetype)polygonWithLineStrings:(NSArray *)lineStrings {
    return [[self alloc] initWithLineStrings:lineStrings];
}

- (instancetype)initWithLineStrings:(NSArray *)lineStrings {
    self = [super initWithType:TFPrimitiveTypePolygon];
    if (self) {
        _lineStrings = [lineStrings copy];
    }

    return self;
}

- (BOOL)hasHoles {
    return ( [self.lineStrings count] > 1 );
}

- (NSUInteger)numberOfHoles; {
    return [self.lineStrings count] - 1;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.lineStrings[idx];
}

- (NSUInteger)count {
    return [self.lineStrings count];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if ( object == self ) {
        return YES;
    }
    
    if ( object == nil || ![object isKindOfClass:[self class]] ) {
        return NO;
    }
    
    return [self isEqualToPolygon:object];
}

- (BOOL)isEqualToPolygon:(TFPolygon *)other {
    return [self.lineStrings isEqualToArray:other.lineStrings];
}

- (NSUInteger)hash {
    return [self.lineStrings hash];
}

@end
