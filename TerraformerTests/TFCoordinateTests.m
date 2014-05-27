//
//  TFCoordinateTests.m
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFCoordinate.h"

@interface TFCoordinateTests : XCTestCase

@end

@implementation TFCoordinateTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoordinate
{
    TFCoordinate *c = [TFCoordinate coordinateWithX:5 y:10];
    XCTAssertEqual(5, c.x);
    XCTAssertEqual(10, c.y);
}

- (void)testHash {
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:5.5 y:10.2];
    XCTAssertNotEqual([c1 hash], [c2 hash]);
}

- (void)testEquality
{
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:5 y:10];
    XCTAssertEqualObjects(c1, c2);
}

- (void)testInequality
{
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:1 y:2];
    XCTAssertFalse([c1 isEqual:c2]);
}

- (void)testCoordinateCopy;
{
    TFCoordinate *original = [TFCoordinate coordinateWithX:5.0 y:10.1];
    TFCoordinate *copy = [original copy];
    TFCoordinate *other = [TFCoordinate coordinateWithX:1.0 y:11.1];
    
    XCTAssertTrue( [original isEqual:copy] );
    XCTAssertEqual( original.x, copy.x );
    XCTAssertEqual( original.y, copy.y );
    XCTAssertFalse( [original isEqual:other] );
}

- (void)testConvertToGeographic {
    TFCoordinate *mercator = [TFCoordinate coordinateWithX:11354588.06 y:222684.20];
    TFCoordinate *geographic = [mercator toGeographic];

    XCTAssertEqualWithAccuracy(geographic.x, 101.99999999179026, 0.000000001);
    XCTAssertEqualWithAccuracy(geographic.y, 1.9999999236399357, 0.000000001);
}

- (void)testConvertToMercator {
    TFCoordinate *geographic = [TFCoordinate coordinateWithX:101.99999999179026 y:1.9999999236399357];
    TFCoordinate *mercator = [geographic toMercator];

    XCTAssertEqualWithAccuracy(mercator.x, 11354588.06, 0.000000001);
    XCTAssertEqualWithAccuracy(mercator.y, 222684.20, 0.000000001);
}

@end
