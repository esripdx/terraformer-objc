//
//  TFMultiLineString.h
//  Terraformer
//
//  Created by Jen on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFMultiLineString : TFGeometry

@property (copy, nonatomic) NSArray *lineStrings;

+ (instancetype)multiLineStringWithLineStrings:(NSArray *)lineStrings;
- (instancetype)initWithLineStrings:(NSArray *)lineStrings;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

@end
