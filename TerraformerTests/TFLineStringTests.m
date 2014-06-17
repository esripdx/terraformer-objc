//
//  TFLineStringTests.m
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFLineString.h"
#import "TFPoint.h"

@interface TFLineStringTests : XCTestCase

@property (strong, nonatomic) TFLineString *linestring;
@property (strong, nonatomic) TFPoint *point1;
@property (strong, nonatomic) TFPoint *point2;
@property (strong, nonatomic) NSArray *points;

@end

@implementation TFLineStringTests

- (void)setUp
{
    [super setUp];

    self.point1 = [TFPoint pointWithX:5 y:10];
    self.point2 = [TFPoint pointWithX:6 y:11];
    self.points = @[self.point1, self.point2];
    self.linestring = [TFLineString lineStringWithPoints:self.points];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitsWithCoordinates
{

    XCTAssertEqual(self.linestring.points, self.points);
    XCTAssertEqual(self.linestring.points[0], self.point1);
    XCTAssertEqual(self.linestring.points[1], self.point2);
    XCTAssertEqual([self.linestring.points[0] x], [self.point1 x]);
    XCTAssertEqual([self.linestring.points[1] x], [self.point2 x]);

}


- (void)testCoordinateAtIndex;
{
    XCTAssertTrue([self.linestring[1] isEqual:self.linestring.points[1]]);
}

/* TODO!
- (void)testEquality
{
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:5 y:10];
    NSArray *coords = @[c1, c2];

    TFLineString *ls1 = [[TFLineString alloc] initWithCoordinates:coords];
    TFLineString *ls2 = [[TFLineString alloc] initWithCoordinates:coords];

    XCTAssertTrue([ls1 isEqual:ls2]);
}
*/

- (void)testInequality
{
    TFPoint *p1 = [TFPoint pointWithX:5 y:10];
    TFPoint *p2 = [TFPoint pointWithX:5 y:10];
    NSArray *points1 = @[p1, p2];

    TFPoint *p3 = [TFPoint pointWithX:1 y:2];
    NSArray *points2 = @[p1, p3];

    TFLineString *ls1 = [TFLineString lineStringWithPoints:points1];
    TFLineString *ls2 = [TFLineString lineStringWithPoints:points2];

    XCTAssertFalse([ls1 isEqual:ls2]);
}

@end
