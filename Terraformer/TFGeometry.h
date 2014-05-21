//
//  TFGeometry.h
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPrimitive.h"

@interface TFGeometry : NSObject <TFPrimitive>

- (instancetype)initWithType:(NSString *)type coordinates:(NSArray *)coordinates;

@property (readonly) NSString *type;
@property (nonatomic, strong) NSArray *coordinates;

@end
