//
//  TFTestData
//  Terraformer
//
//  Created by ryana on 5/23/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFTestData.h"
#import "TFLineString.h"
#import "TFGeoJSON.h"
#import "TFMultiLineString.h"
#import "TFPrimitive.h"

@implementation TFTestData {

}

+ (NSData *)loadFile:(NSString *)name {
    return [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"geojson"]];
}
/*
+ (TFPolygon *)circle {
    return (TFPolygon *)[TFPolygon decodeJSON:[self loadFile:@"circle"]];
}

+ (TFGeometryCollection *)geometry_collection {
    return (TFGeometryCollection *)[TFGeometryCollection decodeJSON:[self loadFile:@"geometry_collection"]];
}
*/

+ (TFPrimitive *)line_string {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON class];
    return [tf parse:[self loadFile:@"line_string"] error:NULL];
}

+ (TFPrimitive *)point {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON class];
    return [tf parse:[self loadFile:@"point"] error:NULL];
}

/*
+ (TFPolygon *)polygon {
    return (TFPolygon *)[TFPolygon decodeJSON:[self loadFile:@"polygon"]];
}

+ (TFPolygon *)polygon_with_holes {
    return (TFPolygon *)[TFPolygon decodeJSON:[self loadFile:@"polygon_with_holes"]];
}

+ (TFFeature *)waldocanyon {
    return (TFFeature *)[TFFeature decodeJSON:[self loadFile:@"waldocanyon"]];
}
*/

+ (TFPrimitive *)multi_line_string {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON class];
    return [tf parse:[self loadFile:@"multi_line_string"] error:NULL];
}

+ (TFPrimitive *)multi_point {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON class];
    return [tf parse:[self loadFile:@"multi_point"] error:NULL];
}

/*
+ (TFGeometry *)multi_polygon {
    return (TFGeometry *)[TFGeometry decodeJSON:[self loadFile:@"multi_polygon"]];
}

+ (TFGeometry *)sf_county {
    return (TFGeometry *)[TFGeometry decodeJSON:[self loadFile:@"sf_county"]];
}
*/

@end