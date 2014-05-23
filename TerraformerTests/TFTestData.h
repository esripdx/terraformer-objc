//
//  TFTestData
//  Terraformer
//
//  Created by ryana on 5/23/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFPolygon;
@class TFGeometryCollection;
@class TFLineString;
@class TFGeometry;
@class TFPoint;
@class TFFeature;


@interface TFTestData : NSObject

+ (NSDictionary *)loadFile:(NSString *)name;

+ (TFPolygon *)circle;
+ (TFGeometryCollection *)geometry_collection;
+ (TFLineString *)line_string;
+ (TFPoint *)point;
+ (TFPolygon *)polygon;
+ (TFPolygon *)polygon_with_holes;
+ (TFFeature *)waldocanyon;

// TODO: Return TFMulti*** classes when they're a thing
+ (TFGeometry *)multi_line_string;
+ (TFGeometry *)multi_point;
+ (TFGeometry *)multi_polygon;
+ (TFGeometry *)sf_county;
@end