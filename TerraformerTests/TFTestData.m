//
//  TFTestData
//  Terraformer
//
//  Created by ryana on 5/23/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFTestData.h"
#import "TFLineString.h"
#import "TFGeoJSON.h"
#import "TFPolygon.h"

@implementation TFTestData {

}

+ (NSData *)loadFile:(NSString *)name {
    return [self loadFile:name extension:@"geojson"];
}

+ (NSData *)loadFile:(NSString *)name extension:(NSString *)extension {
    return [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension]];
}

+ (TFPrimitive *)circle {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"circle"] error:NULL];
}

+ (TFPrimitive *)geometry_collection {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"geometry_collection"] error:NULL];
}

+ (TFPrimitive *)line_string {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"line_string"] error:NULL];
}

+ (TFPrimitive *)point {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"point"] error:NULL];
}

+ (TFPrimitive *)polygon {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"polygon"] error:NULL];
}

+ (TFPrimitive *)polygon_with_holes {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"polygon_with_holes"] error:NULL];
}

+ (TFPrimitive *)waldocanyon {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"waldocanyon"] error:NULL];
}

+ (TFPrimitive *)feature_collection {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"feature_collection"] error:NULL];
}

+ (TFPrimitive *)multi_line_string {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"multi_line_string"] error:NULL];
}

+ (TFPrimitive *)multi_point {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"multi_point"] error:NULL];
}

+ (TFPrimitive *)multi_polygon {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"multi_polygon"] error:NULL];
}

+ (TFPrimitive *)sf_county {
    TFTerraformer *tf = [TFTerraformer new];
    tf.decoder = [TFGeoJSON new];
    return [tf decode:[self loadFile:@"sf_county"] error:NULL];
}

@end