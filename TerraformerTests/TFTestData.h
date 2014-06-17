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

//+ (TFPolygon *)circle;
//+ (TFGeometryCollection *)geometry_collection;
+ (TFPrimitive *)line_string;
+ (TFPrimitive *)point;
//+ (TFPolygon *)polygon;
//+ (TFPolygon *)polygon_with_holes;
//+ (TFFeature *)waldocanyon;

// TODO: Return TFMulti*** classes when they're a thing
+ (TFPrimitive *)multi_line_string;
+ (TFPrimitive *)multi_point;
+ (TFPrimitive *)multi_polygon;
+ (TFPrimitive *)sf_county;
@end