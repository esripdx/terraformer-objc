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
    XCTAssertEqual(2, [gc.geometries count]);
    XCTAssertTrue([gc.geometries containsObject:p2]);
}

- (void)testRemoveGeometry {
    TFPoint *p0 = [TFPoint pointWithX:0 y:0];
    TFPoint *p1 = [TFPoint pointWithX:1 y:1];
    TFPoint *p2 = [TFPoint pointWithX:2 y:2];
    TFPoint *p3 = [TFPoint pointWithX:3 y:3];
    TFGeometryCollection *gc = [[TFGeometryCollection alloc] initWithGeometries:@[ p0, p1, p2, p3 ]];

    // sanity check
    XCTAssertEqual(4, [gc.geometries count]);

    XCTAssertTrue([gc.geometries containsObject:p3]);
    [gc removeGeometry:p3];
    XCTAssertEqual(3, [gc.geometries count]);
    XCTAssertFalse([gc.geometries containsObject:p3]);

    XCTAssertTrue([gc.geometries containsObject:p2]);
    [gc removeGeometryAtIndex:2];
    XCTAssertEqual(2, [gc.geometries count]);
    XCTAssertFalse([gc.geometries containsObject:p2]);

    gc = [[TFGeometryCollection alloc] initWithGeometries:@[ p0, p1, p2, p3 ]];
    XCTAssertEqual(4, [gc.geometries count]);
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
    [gc removeGeometriesAtIndexes:indexes];
    XCTAssertEqual(2, [gc.geometries count]);
    XCTAssertFalse([gc.geometries containsObject:p1]);
    XCTAssertFalse([gc.geometries containsObject:p2]);
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
