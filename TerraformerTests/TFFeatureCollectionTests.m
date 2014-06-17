//
// Created by Josh Yaganeh on 5/22/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFFeatureCollection.h"
#import "TFFeature.h"
#import "TFPoint.h"
#import "TFTestData.h"
#import "TFPolygon.h"

@interface TFFeatureCollectionTests : XCTestCase

@property (nonatomic, strong) TFPoint *point;
@property (nonatomic, strong) TFFeature *feature;
@property (nonatomic, strong) TFFeature *anotherFeature;
@property (nonatomic, strong) TFFeatureCollection *collection;

@end

@implementation TFFeatureCollectionTests

- (void)setUp {
    self.point = [TFPoint pointWithX:-1 y:0];
    self.feature = [[TFFeature alloc] initWithGeometry:self.point];
    self.anotherFeature = [TFFeature featureWithGeometry:[TFPoint pointWithX:0 y:1]];
    self.collection = [[TFFeatureCollection alloc] initWithFeatures:@[self.feature]];
}

- (void)testAddFeature {
    // sanity
    XCTAssertTrue(self.collection.features.count == 1);

    // add a feature and check count again
    [self.collection addFeature:self.anotherFeature];
    XCTAssertTrue(self.collection.features.count == 2);
}

- (void)testRemoveFeature {
    // sanity
    XCTAssertTrue(self.collection.features.count == 1);

    // remove a feature and check count
    [self.collection removeFeature:self.feature];
    XCTAssertTrue(self.collection.features.count == 0);
}

- (void)testDataFiles {
    TFFeatureCollection *fc = (TFFeatureCollection *)[TFTestData feature_collection];
    XCTAssert(fc.type == TFPrimitiveTypeFeatureCollection);
    XCTAssert([fc count] == 2);

    TFFeature *f = fc[0];
    XCTAssertNotNil(f);
    XCTAssert(f.geometry.type == TFPrimitiveTypePolygon);
    TFPolygon *p = (TFPolygon *)f.geometry;
    XCTAssertEqualObjects(p[0][0][0], @(-180));

    f = fc[1];
    p = (TFPolygon *)f.geometry;
    XCTAssertEqualObjects(p[0][0][0], @(-130));
}
@end