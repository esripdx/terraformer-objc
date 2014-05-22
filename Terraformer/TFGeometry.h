//
//  TFGeometry.h
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPrimitive.h"
#import "TFConstants.h"

@interface TFGeometry : NSObject <TFPrimitive>

+ (NSString *)geoJSONStringForType:(TFPrimitiveType)type;
+ (TFPrimitiveType)geometryTypeForString:(NSString *)string;
+ (instancetype)geometryWithType:(TFPrimitiveType)type coordinates:(NSArray *)coordinates;

@property (nonatomic, strong) NSArray *coordinates;


@end
