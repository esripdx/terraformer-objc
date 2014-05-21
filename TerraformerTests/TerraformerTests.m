//
//  TerraformerTests.m
//  TerraformerTests
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFCoordinate.h"
#import "TFGeometry.h"

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

- (void)testCoordinate {
    TFCoordinate *c = [TFCoordinate coordinateWithX:5 y:10];
    XCTAssertEqual(5, c.x);
    XCTAssertEqual(10, c.y);
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

- (void)testGeometryBbox {
    // TODO: Add more types here, and use their specific subclasses.

    TFGeometry *point = [[TFGeometry alloc] initWithType:@"point" coordinates:@[[TFCoordinate coordinateWithX:5 y:10]]];
    NSArray *bbox = [point bbox];
    NSArray *expected = @[@(5), @(10), @(5), @(10)];
    XCTAssertEqualObjects(expected, bbox);

    TFGeometry *polygon = [[TFGeometry alloc] initWithType:@"polygon" coordinates:@[
            [TFCoordinate coordinateWithX:-5 y:-10],
            [TFCoordinate coordinateWithX:-2 y:-40],
            [TFCoordinate coordinateWithX:0 y:35],
            [TFCoordinate coordinateWithX:5 y:10],
            [TFCoordinate coordinateWithX:25 y:5]
    ]];
    bbox = [polygon bbox];
    expected = @[@(-5), @(-40), @(25), @(35)];
    XCTAssertEqualObjects(expected, bbox);
}

@end
