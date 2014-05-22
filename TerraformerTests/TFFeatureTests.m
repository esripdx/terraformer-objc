//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFGeometry.h"
#import "TFCoordinate.h"
#import "TFFeature.h"
#import "TFPoint.h"

@interface TFFeatureTests : XCTestCase
@end

@implementation TFFeatureTests

- (void)testFeature {
    TFGeometry *point = [TFPoint pointWithX:5 y:10];
    NSDictionary *properties = @{@"key": @"val"};
    NSString *identifier = @"identifier";

    TFFeature *feature1 = [TFFeature featureWithGeometry:point];
    XCTAssertEqual(TFPrimitiveTypeFeature, feature1.type);
    XCTAssertEqualObjects(point, feature1.geometry);

    TFFeature *feature2 = [TFFeature featureWithGeometry:point properties:properties];
    XCTAssertEqual(TFPrimitiveTypeFeature, feature2.type);
    XCTAssertEqualObjects(point, feature2.geometry);
    XCTAssertEqualObjects(properties, feature2.properties);

    TFFeature *feature3 = [TFFeature featureWithIdentifier:identifier geometry:point properties:properties];
    XCTAssertEqual(TFPrimitiveTypeFeature, feature3.type);
    XCTAssertEqualObjects(point, feature3.geometry);
    XCTAssertEqualObjects(properties, feature3.properties);
    XCTAssertEqualObjects(identifier, feature3.identifier);
}
@end