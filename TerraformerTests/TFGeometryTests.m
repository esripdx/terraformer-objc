//
//  TFGeometryTests.m
//  Terraformer
//
//  Created by Ryan Arana on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFGeometry.h"
#import "TFCoordinate.h"
#import "TFPoint.h"
#import "TFPolygon.h"

@interface TFGeometryTests : XCTestCase

@end

@implementation TFGeometryTests

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
    // TODO: Add more types here.

    TFGeometry *point = [TFGeometry geometryWithType:TFPrimitiveTypePoint coordinates:@[[TFCoordinate coordinateWithX:5 y:10]]];
    NSArray *bbox = [point bbox];
    NSArray *expected = @[@(5), @(10), @(5), @(10)];
    XCTAssertEqualObjects(expected, bbox);

    TFGeometry *polygon = [TFGeometry geometryWithType:TFPrimitiveTypePolygon coordinates:@[
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
    // TODO: Add more types here.

    TFGeometry *point = [TFGeometry geometryWithType:TFPrimitiveTypePoint coordinates:@[[TFCoordinate coordinateWithX:5 y:10]]];
    NSArray *bbox = [point envelope];
    NSArray *expected = @[@(5), @(10), @(0), @(0)];
    XCTAssertEqualObjects(expected, bbox);

    TFGeometry *polygon = [TFGeometry geometryWithType:TFPrimitiveTypePolygon coordinates:@[
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

- (void)testToMercator {
    TFGeometry *polygon = [TFGeometry geometryWithType:TFPrimitiveTypePolygon coordinates:@[
                    [TFCoordinate coordinateWithX:0 y:0],
                    [TFCoordinate coordinateWithX:1 y:0],
                    [TFCoordinate coordinateWithX:1 y:1],
                    [TFCoordinate coordinateWithX:0 y:1],
                    [TFCoordinate coordinateWithX:0 y:0]
            ]];

    TFGeometry *merc = [polygon toMercator];

    NSArray *expected = @[
                    [TFCoordinate coordinateWithX:0 y:0],
                    [TFCoordinate coordinateWithX:111319.490793 y:0],
                    [TFCoordinate coordinateWithX:111319.490793 y:111325.142866],
                    [TFCoordinate coordinateWithX:0 y:111325.142866],
                    [TFCoordinate coordinateWithX:0 y:0]
            ];

    for (NSUInteger i = 0; i < expected.count; i++) {
        TFCoordinate *obs = merc.coordinates[i];
        TFCoordinate *exp = expected[i];
        XCTAssertEqualWithAccuracy(obs.x, exp.x, 0.000001);
        XCTAssertEqualWithAccuracy(obs.y, exp.y, 0.000001);
    }
}

@end
