//
//  TFCGeometryTests.m
//  Terraformer
//
//  Created by Ryan Arana on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFGeometry.h"
#import "TFCoordinate.h"

@interface TFCGeometryTests : XCTestCase

@end

@implementation TFCGeometryTests

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

- (void)testBBox {
    // TODO: Add more types here, and use their specific subclasses.

    TFGeometry *point = [[TFGeometry alloc] initWithType:@"Point" coordinates:@[[TFCoordinate coordinateWithX:5 y:10]]];
    NSArray *bbox = [point bbox];
    NSArray *expected = @[@(5), @(10), @(5), @(10)];
    XCTAssertEqualObjects(expected, bbox);

    TFGeometry *polygon = [[TFGeometry alloc] initWithType:@"Polygon" coordinates:@[
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

- (void)testEnvelope {
    // TODO: Add more types here, and use their specific subclasses.

    TFGeometry *point = [[TFGeometry alloc] initWithType:@"point" coordinates:@[[TFCoordinate coordinateWithX:5 y:10]]];
    NSArray *bbox = [point envelope];
    NSArray *expected = @[@(5), @(10), @(0), @(0)];
    XCTAssertEqualObjects(expected, bbox);

    TFGeometry *polygon = [[TFGeometry alloc] initWithType:@"polygon" coordinates:@[
            [TFCoordinate coordinateWithX:-5 y:-10],
            [TFCoordinate coordinateWithX:-2 y:-40],
            [TFCoordinate coordinateWithX:0 y:35],
            [TFCoordinate coordinateWithX:5 y:10],
            [TFCoordinate coordinateWithX:25 y:5]
    ]];
    bbox = [polygon envelope];
    expected = @[@(-5), @(-40), @(30), @(75)];
    XCTAssertEqualObjects(expected, bbox);
}

@end
