//
//  TFGeometryCollectionTests.m
//  Terraformer
//
//  Created by Ryan Arana on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFGeometryCollection.h"
#import "TFGeometry.h"
#import "TFCoordinate.h"
#import "TFPoint.h"
#import "TFPolygon.h"
#import "TFLineString.h"

@interface TFGeometryCollectionTests : XCTestCase

@end

@implementation TFGeometryCollectionTests

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
    TFGeometryCollection *gc = [[TFGeometryCollection alloc] initWithGeometries:@[
            [TFGeometry geometryWithType:TFPrimitiveTypePolygon coordinates:@[
                    [TFCoordinate coordinateWithX:-5 y:-10],
                    [TFCoordinate coordinateWithX:-2 y:-40],
                    [TFCoordinate coordinateWithX:0 y:35],
                    [TFCoordinate coordinateWithX:5 y:10],
                    [TFCoordinate coordinateWithX:25 y:5]
            ]],
            [TFGeometry geometryWithType:TFPrimitiveTypePoint coordinates:@[
                    [TFCoordinate coordinateWithX:34 y:0]
            ]]
    ]];
    NSArray *expected = @[@(-5), @(-40), @(34), @(35)];
    XCTAssertEqualObjects(expected, [gc bbox]);
}

- (void)testEnvelope {
    TFGeometryCollection *gc = [[TFGeometryCollection alloc] initWithGeometries:@[
            [TFGeometry geometryWithType:TFPrimitiveTypePolygon coordinates:@[
                    [TFCoordinate coordinateWithX:-5 y:-10],
                    [TFCoordinate coordinateWithX:-2 y:-40],
                    [TFCoordinate coordinateWithX:0 y:35],
                    [TFCoordinate coordinateWithX:5 y:10],
                    [TFCoordinate coordinateWithX:25 y:5]
            ]],
            [TFGeometry geometryWithType:TFPrimitiveTypePoint coordinates:@[
                    [TFCoordinate coordinateWithX:34 y:0]
            ]]
    ]];
    NSArray *expected = @[@(-5), @(-40), @(39), @(75)];
    XCTAssertEqualObjects(expected, [gc envelope]);
}

- (void)testAddGeometry {
    TFGeometryCollection *gc = [[TFGeometryCollection alloc] initWithGeometries:@[
            [TFPoint pointWithX:5 y:10]
    ]];
    TFPoint *p2 = [TFPoint pointWithX:-1 y:0];
    [gc addGeometry:p2];
    XCTAssertTrue([gc.geometries count] == 2);
    XCTAssertTrue([gc.geometries containsObject:p2]);
}

- (void)testGeometriesWhichContainGeometry {
    /* TODO: Make this test pass
    TFPoint *p = [TFPoint pointWithX:0 y:0];
    TFLineString *ls = [TFLineString lineStringWithXYs:@[@[@(10), @(10)], @[@(0), @(0)]]];
    TFLineString *lsWithoutPoint = [TFLineString lineStringWithXYs:@[@[@(10), @(10)], @[@(20), @(20)]]];
    TFGeometryCollection *gc = [[TFGeometryCollection alloc] initWithGeometries:@[ls, lsWithoutPoint]];

    NSArray *geometries = [gc geometriesWhichContain:p];
    XCTAssertEqual(1, [geometries count]);
    XCTAssertTrue([geometries containsObject:ls]);
    XCTAssertFalse([geometries containsObject:lsWithoutPoint]);

    p = [TFPoint pointWithX:100 y:100];
    geometries = [gc geometriesWhichContain:p];
    XCTAssertEqual(0, [geometries count]);
    XCTAssertFalse([geometries containsObject:ls]);
    XCTAssertFalse([geometries containsObject:lsWithoutPoint]);
    */
}

- (void)testGeometriesWhichIntersectGeometry {
    // TODO
}

- (void)testGeometriesWithinGeometry {
    // TODO
}
@end
