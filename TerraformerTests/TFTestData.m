//
//  TFTestData
//  Terraformer
//
//  Created by ryana on 5/23/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFTestData.h"
#import "TFPolygon.h"
#import "TFGeometryCollection.h"
#import "TFLineString.h"
#import "TFGeometry.h"
#import "TFPoint.h"
#import "TFFeature.h"


@implementation TFTestData {

}

+ (NSDictionary *)loadFile:(NSString *)name {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"geojson"]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NULL error:NULL];
    return json;
}

+ (TFPolygon *)circle {
    return (TFPolygon *)[TFPolygon decodeJSON:[self loadFile:@"circle"]];
}

+ (TFGeometryCollection *)geometry_collection {
    return (TFGeometryCollection *)[TFGeometryCollection decodeJSON:[self loadFile:@"geometry_collection"]];
}

+ (TFLineString *)line_string {
    return (TFLineString *)[TFLineString decodeJSON:[self loadFile:@"line_string"]];
}

+ (TFPoint *)point {
    return (TFPoint *)[TFPoint decodeJSON:[self loadFile:@"point"]];
}

+ (TFPolygon *)polygon {
    return (TFPolygon *)[TFPolygon decodeJSON:[self loadFile:@"polygon"]];
}

+ (TFPolygon *)polygon_with_holes {
    return (TFPolygon *)[TFPolygon decodeJSON:[self loadFile:@"polygon_with_holes"]];
}

+ (TFFeature *)waldocanyon {
    return (TFFeature *)[TFFeature decodeJSON:[self loadFile:@"waldocanyon"]];
}

+ (TFGeometry *)multi_line_string {
    return (TFGeometry *)[TFGeometry decodeJSON:[self loadFile:@"multi_line_string"]];
}

+ (TFGeometry *)multi_point {
    return (TFGeometry *)[TFGeometry decodeJSON:[self loadFile:@"multi_point"]];
}

+ (TFGeometry *)multi_polygon {
    return (TFGeometry *)[TFGeometry decodeJSON:[self loadFile:@"multi_polygon"]];
}

+ (TFGeometry *)sf_county {
    return (TFGeometry *)[TFGeometry decodeJSON:[self loadFile:@"sf_county"]];
}

@end