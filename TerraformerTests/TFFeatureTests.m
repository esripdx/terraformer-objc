//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFFeature.h"
#import "TFPoint.h"
#import "TFTestData.h"

@interface TFFeatureTests : XCTestCase
@property TFFeature *feature1;
@property TFFeature *feature2;
@property TFFeature *feature3;
@property TFPoint *point;
@property NSDictionary *properties;
@property NSString *identifier;
@end

@implementation TFFeatureTests

- (void)setUp {
    self.point = [TFPoint pointWithX:5 y:10];
    self.properties = @{@"key": @"val"};
    self.identifier = @"identifier";

    self.feature1 = [TFFeature featureWithGeometry:self.point];
    self.feature2 = [TFFeature featureWithGeometry:self.point properties:self.properties];
    self.feature3 = [TFFeature featureWithGeometry:self.point properties:self.properties identifier:self.identifier];
}

- (void)testEquality {
    XCTAssertEqual(TFPrimitiveTypeFeature, self.feature1.type);
    XCTAssertEqualObjects(self.point, self.feature1.geometry);

    XCTAssertEqual(TFPrimitiveTypeFeature, self.feature2.type);
    XCTAssertEqualObjects(self.point, self.feature2.geometry);
    XCTAssertEqualObjects(self.properties, self.feature2.properties);

    XCTAssertEqual(TFPrimitiveTypeFeature, self.feature3.type);
    XCTAssertEqualObjects(self.point, self.feature3.geometry);
    XCTAssertEqualObjects(self.properties, self.feature3.properties);
    XCTAssertEqualObjects(self.identifier, self.feature3.identifier);

    TFFeature *f = [TFFeature featureWithGeometry:self.point properties:self.properties identifier:self.identifier];
    XCTAssertEqualObjects(self.feature3, f);
}

- (void)testInequality {
    XCTAssertNotEqualObjects(self.feature1, self.feature2);

    TFFeature *f = [TFFeature featureWithGeometry:self.point properties:self.properties identifier:@"not the same identifier"];
    XCTAssertNotEqualObjects(self.feature3, f);
}

- (void)testDataFiles {
    TFFeature *feature = (TFFeature *)[TFTestData waldocanyon];
    XCTAssertEqual(feature.type, TFPrimitiveTypeFeature);
    XCTAssertEqualObjects(feature.properties[@"Name"], @"CO-PSF-GY3N Waldo Canyon 6-30-2012 2000");
    XCTAssertEqual(feature.geometry.type, TFPrimitiveTypeMultiPolygon);
}
@end