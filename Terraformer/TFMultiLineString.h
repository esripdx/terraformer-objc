//
//  TFMultiLineString.h
//  Terraformer
//
//  Created by Jen on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@class TFCoordinate;

@interface TFMultiLineString : TFGeometry

+ (instancetype)lineStringsWithCoordinateArrays:(NSArray *)lines;
- (instancetype)initWithCoordinateArrays:(NSArray *)lines;

@end
