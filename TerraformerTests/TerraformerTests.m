//
//  TerraformerTests.m
//  TerraformerTests
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFCoordinate.h"
#import "TFGeometric.h"

@interface TerraformerTests : XCTestCase

@end

@implementation TerraformerTests

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

- (void)testEdgeIntersectsEdge {
    NSArray *a = @[ [TFCoordinate coordinateWithX:0 y:0], [TFCoordinate coordinateWithX:2 y:2] ];
    NSArray *b = @[ [TFCoordinate coordinateWithX:0 y:2], [TFCoordinate coordinateWithX:2 y:0] ];
    XCTAssert([TFGeometric edge:a intersectsEdge:b]);
    
    NSArray *c = @[ [TFCoordinate coordinateWithX:0 y:2], [TFCoordinate coordinateWithX:2 y:2] ];
    NSArray *d = @[ [TFCoordinate coordinateWithX:0 y:0], [TFCoordinate coordinateWithX:2 y:0] ];
    XCTAssertFalse([TFGeometric edge:c intersectsEdge:d]);
}

- (void)testArraysIntersectArrays {
    NSArray *a = @[ @[ [TFCoordinate coordinateWithX:0 y:0], [TFCoordinate coordinateWithX:2 y:2] ] ];
    NSArray *b = @[ [TFCoordinate coordinateWithX:0 y:2], [TFCoordinate coordinateWithX:2 y:0] ];
    XCTAssert([TFGeometric arrays:a intersectArrays:b]);
    
    NSArray *c = @[ [TFCoordinate coordinateWithX:0 y:2], [TFCoordinate coordinateWithX:2 y:2] ];
    NSArray *d = @[ @[ [TFCoordinate coordinateWithX:0 y:0], [TFCoordinate coordinateWithX:2 y:0] ] ];
    XCTAssertFalse([TFGeometric arrays:c intersectArrays:d]);
}

- (void)testLineContainsPoint {
    NSArray *l = @[ [TFCoordinate coordinateWithX:0 y:0], [TFCoordinate coordinateWithX:4 y:4] ];
    TFCoordinate *c = [TFCoordinate coordinateWithX:2 y:2];
    XCTAssert([TFGeometric line:l containsCoordinate:c]);
    TFPoint *p = [TFPoint pointWithCoordinate:c];
    XCTAssert([TFGeometric line:l containsPoint:p]);
    
    NSArray *m = @[ [TFCoordinate coordinateWithX:0 y:0], [TFCoordinate coordinateWithX:4 y:4] ];
    TFCoordinate *d = [TFCoordinate coordinateWithX:0 y:2];
    XCTAssertFalse([TFGeometric line:m containsCoordinate:d]);
    TFPoint *q = [TFPoint pointWithCoordinate:d];
    XCTAssertFalse([TFGeometric line:m containsPoint:q]);
    
    TFCoordinate *s = [TFCoordinate coordinateWithX:0 y:0];
    TFCoordinate *e = [TFCoordinate coordinateWithX:4 y:4];
    XCTAssert([TFGeometric line:l containsCoordinate:s]);
    XCTAssert([TFGeometric line:l containsCoordinate:e]);
}

@end
