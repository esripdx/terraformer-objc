//
//  TFPolygon.h
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPrimitive.h"

@interface TFPolygon : TFPrimitive

@property (copy, nonatomic) NSArray *lineStrings;

+ (instancetype)polygonWithLineStrings:(NSArray *)lineStrings;
- (instancetype)initWithLineStrings:(NSArray *)lineStrings;

- (BOOL)isEqualToPolygon:(TFPolygon *)other;
- (BOOL)hasHoles;
- (NSUInteger)numberOfHoles;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;
@end
