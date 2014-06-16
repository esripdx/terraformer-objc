//
//  TFGeometry.h
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPrimitive.h"

@interface TFGeometry : TFPrimitive

@property (copy, nonatomic) NSArray *coordinates;

- (instancetype)initWithType:(TFPrimitiveType)type coordinates:(NSArray *)coordinates;
@end
