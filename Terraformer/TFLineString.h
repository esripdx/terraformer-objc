//
//  TFLineString.h
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPrimitive.h"

@interface TFLineString : TFPrimitive

@property (copy, nonatomic) NSArray *points;

+ (instancetype)lineStringWithPoints:(NSArray *)points;
- (instancetype)initWithPoints:(NSArray *)points;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

- (BOOL)isLinearRing;
@end
