//
//  TFGeometry.m
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@implementation TFGeometry

- (instancetype)initWithType:(TFPrimitiveType)type coordinates:(NSArray *)coordinates {
    self = [super initWithType:type];
    if (self) {
        _coordinates = [coordinates copy];
    }
    return self;
}

#pragma mark - TFPrimitive

- (TFPrimitiveType)type {
    return TFPrimitiveTypeUnknown;
}

@end
