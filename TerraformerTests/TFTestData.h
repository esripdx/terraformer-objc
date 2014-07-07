//
//  TFTestData
//  Terraformer
//
//  Created by ryana on 5/23/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFPrimitive;


@interface TFTestData : NSObject

+ (NSData *)loadFile:(NSString *)name;
+ (NSData *)loadFile:(NSString *)name extension:(NSString *)extension;

+ (TFPrimitive *)circle;
+ (TFPrimitive *)geometry_collection;
+ (TFPrimitive *)line_string;
+ (TFPrimitive *)point;
+ (TFPrimitive *)polygon;
+ (TFPrimitive *)polygon_with_holes;
+ (TFPrimitive *)waldocanyon;
+ (TFPrimitive *)feature_collection;

+ (TFPrimitive *)multi_line_string;
+ (TFPrimitive *)multi_point;
+ (TFPrimitive *)multi_polygon;
+ (TFPrimitive *)sf_county;
@end