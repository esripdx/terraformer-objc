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

- (void)testEquality
{
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:5 y:10];
    XCTAssertTrue([c1 isEqual:c2]);
}

- (void)testInequality
{
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:1 y:2];
    XCTAssertFalse([c1 isEqual:c2]);
}

@end
