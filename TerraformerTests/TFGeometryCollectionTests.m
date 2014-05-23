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

@property (strong, nonatomic) TFPoint *p0;
@property (strong, nonatomic) TFPoint *p1;
@property (strong, nonatomic) TFPoint *p2;
@property (strong, nonatomic) TFPoint *p3;
@property (strong, nonatomic) TFGeometryCollection *gc;
@property (strong, nonatomic) TFGeometryCollection *bboxGC;
@property (copy, nonatomic) NSArray *expectedBBox;
@property (copy, nonatomic) NSArray *expectedEnvelope;
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
    self.bboxGC = [[TFGeometryCollection alloc] initWithGeometries:@[
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
    self.expectedBBox = @[@(-5), @(-40), @(34), @(35)];
    self.expectedEnvelope = @[@(-5), @(-40), @(39), @(75)];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBBox {
    XCTAssertEqualObjects(self.expectedBBox, [self.bboxGC bbox]);
}

- (void)testEnvelope {
    XCTAssertEqualObjects(self.expectedEnvelope, [self.bboxGC envelope]);
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
