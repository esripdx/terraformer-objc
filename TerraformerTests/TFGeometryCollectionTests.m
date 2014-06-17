//
//  TFGeometryCollectionTests.m
//  Terraformer
//
//  Created by Ryan Arana on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFGeometryCollection.h"
#import "TFPoint.h"
#import "TFTestData.h"

@interface TFGeometryCollectionTests : XCTestCase

@property (strong, nonatomic) TFPoint *p0;
@property (strong, nonatomic) TFPoint *p1;
@property (strong, nonatomic) TFPoint *p2;
@property (strong, nonatomic) TFPoint *p3;
@property (strong, nonatomic) TFGeometryCollection *gc;
@end

@implementation TFGeometryCollectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.p0 = [TFPoint pointWithX:0 y:0];
    self.p1 = [TFPoint pointWithX:1 y:1];
    self.p2 = [TFPoint pointWithX:2 y:2];
    self.p3 = [TFPoint pointWithX:3 y:3];
    self.gc = [[TFGeometryCollection alloc] initWithGeometries:@[self.p0, self.p1, self.p2, self.p3]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddGeometry {
    TFPoint *p2 = [TFPoint pointWithX:-1 y:0];
    // sanity check
    XCTAssertEqual(4, [self.gc.geometries count]);
    [self.gc addGeometry:p2];
    XCTAssertEqual(5, [self.gc.geometries count]);
    XCTAssertTrue([self.gc.geometries containsObject:p2]);
}

- (void)testRemoveGeometry {
    // sanity check
    XCTAssertEqual(4, [self.gc.geometries count]);

    XCTAssertTrue([self.gc.geometries containsObject:self.p3]);
    [self.gc removeGeometry:self.p3];
    XCTAssertEqual(3, [self.gc.geometries count]);
    XCTAssertFalse([self.gc.geometries containsObject:self.p3]);
}

- (void)testDataFiles {
    TFGeometryCollection *gc = (TFGeometryCollection *)[TFTestData geometry_collection];
    XCTAssert(gc.type == TFPrimitiveTypeGeometryCollection);
    XCTAssert([gc count] == 2);

    TFGeometry *g1 = gc[0];
    TFGeometry *g2 = gc[1];
    XCTAssert(g1.type == TFPrimitiveTypePoint);
    XCTAssert(g2.type == TFPrimitiveTypeLineString);
}

@end
