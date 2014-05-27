//
//  TFLineStringTests.m
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFLineString.h"
#import "TFCoordinate.h"

@interface TFLineStringTests : XCTestCase

@property (strong, nonatomic) TFLineString *linestring;
@property (strong, nonatomic) TFCoordinate *coord1;
@property (strong, nonatomic) TFCoordinate *coord2;
@property (strong, nonatomic) NSArray *coords;

@end

@implementation TFLineStringTests

- (void)setUp
{
    [super setUp];

    self.coord1 = [TFCoordinate coordinateWithX:5 y:10];
    self.coord2 = [TFCoordinate coordinateWithX:6 y:11];
    self.coords = @[self.coord1, self.coord2];
    self.linestring = [[TFLineString alloc] initWithCoordinates:self.coords];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitsWithCoordinates
{

    XCTAssertEqual(self.linestring.coordinates, self.coords);
    XCTAssertEqual(self.linestring.coordinates[0], self.coord1);
    XCTAssertEqual(self.linestring.coordinates[1], self.coord2);
    XCTAssertEqual([self.linestring.coordinates[0] x], [self.coord1 x]);
    XCTAssertEqual([self.linestring.coordinates[1] x], [self.coord2 x]);

}

- (void)testInitsWithXYs
{

    NSArray *coord1 = @[@5, @10];
    NSArray *coord2 = @[@6, @11];
    NSArray *coords = @[coord1, coord2];
    TFLineString *ls = [[TFLineString alloc] initWithXYs:coords];

    XCTAssertTrue([ls.coordinates isEqual:self.coords]);
    XCTAssertTrue([ls.coordinates[0] isEqual:self.coord1]);
    XCTAssertTrue([ls.coordinates[1] isEqual:self.coord2]);
    XCTAssertEqual([ls.coordinates[0] x], [self.coord1 x]);
    XCTAssertEqual([ls.coordinates[1] x], [self.coord2 x]);
    
}

- (void)testCoordinateAtIndex;
{
    TFCoordinate *coordinateAtIndex = [self.linestring coordinateAtIndex:1];
    XCTAssertTrue([coordinateAtIndex isEqual:self.linestring.coordinates[1]]);
}


- (void)testRemoveCoordinate;
{
    TFCoordinate *removed = [self.linestring coordinateAtIndex:1];

    [self.linestring removeCoordinateAtIndex:1];

    for ( TFCoordinate *coord in self.linestring.coordinates ) {
        XCTAssertNotEqualObjects( removed, coord );
    }
}

- (void)testAddCoordinate;
{
    TFCoordinate *newVertex = [TFCoordinate coordinateWithX:2.0 y:0.2];

    [self.linestring insertCoordinate:newVertex atIndex:2];

    BOOL found = NO;

    for ( TFCoordinate *coord in self.linestring.coordinates ) {
        found = (coord == newVertex) ? YES : NO;
    }

    XCTAssertTrue( found );
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
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:5 y:10];
    NSArray *coords1 = @[c1, c2];

    TFCoordinate *c3 = [TFCoordinate coordinateWithX:1 y:2];
    NSArray *coords2 = @[c1, c3];

    TFLineString *ls1 = [[TFLineString alloc] initWithCoordinates:coords1];
    TFLineString *ls2 = [[TFLineString alloc] initWithCoordinates:coords2];

    XCTAssertFalse([ls1 isEqual:ls2]);
}

@end
