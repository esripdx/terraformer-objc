//
//  TFLineString.h
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFLineString : TFGeometry

+ (instancetype)lineStringWithCoordinates:(NSArray*)coordinates;
+ (instancetype)lineStringWithXYs:(NSArray *)xys;
- (instancetype)initWithCoordinates:(NSArray *)coordinates;
- (instancetype)initWithXYs:(NSArray *)xys;
- (BOOL)isLinearRing;

@end
