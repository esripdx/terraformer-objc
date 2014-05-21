//
//  TFPoint.h
//  Terraformer
//
//  Created by Courtf on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"
#import "TFCoordinate.h"

@interface TFPoint : TFGeometry

+ (instancetype)pointWithX:(double)x y:(double)y;
- (instancetype)initWithX:(double)x y:(double)y;
+ (instancetype)pointWithCoordinate:(TFCoordinate *)coord;
- (instancetype)initWithCoordinate:(TFCoordinate *)coord;

@end
