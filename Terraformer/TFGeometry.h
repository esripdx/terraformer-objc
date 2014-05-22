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

+ (NSString *)geoJSONStringForType:(TFGeometryType)type;
+ (TFGeometryType)geometryTypeForString:(NSString *)string;
+ (instancetype)geometryWithType:(TFGeometryType)type coordinates:(NSArray *)coordinates;

@property (nonatomic, strong) NSArray *coordinates;


@end
