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

@end

@implementation TFLineStringTests

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

- (void)testInitsWithCoordinates
{

    TFCoordinate *coord1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *coord2 = [TFCoordinate coordinateWithX:6 y:11];
    NSArray *coords = @[coord1, coord2];

    TFLineString *ls = [[TFLineString alloc] initWithCoordinates:coords];

    XCTAssertEqual(ls.coordinates, coords);
    XCTAssertEqual(ls.coordinates[0], coord1);
    XCTAssertEqual(ls.coordinates[1], coord2);
    XCTAssertEqual([ls.coordinates[0] x], [coord1 x]);
    XCTAssertEqual([ls.coordinates[1] x], [coord2 x]);

}

- (void)testInitsWithXYs
{

    NSArray *coord1 = @[@5, @10];
    NSArray *coord2 = @[@6, @11];
    NSArray *coords = @[coord1, coord2];

    TFCoordinate *tfcoord1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *tfcoord2 = [TFCoordinate coordinateWithX:6 y:11];
    NSArray *tfcoords = @[tfcoord1, tfcoord2];

    TFLineString *ls = [[TFLineString alloc] initWithXYs:coords];

    XCTAssertTrue([ls.coordinates isEqual:tfcoords]);
    XCTAssertTrue([ls.coordinates[0] isEqual:tfcoord1]);
    XCTAssertTrue([ls.coordinates[1] isEqual:tfcoord2]);
    XCTAssertEqual([ls.coordinates[0] x], [tfcoord1 x]);
    XCTAssertEqual([ls.coordinates[1] x], [tfcoord2 x]);
    
}

- (void)testEquality
{
    TFCoordinate *c1 = [TFCoordinate coordinateWithX:5 y:10];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:5 y:10];
    NSArray *coords = @[c1, c2];

    TFLineString *ls1 = [[TFLineString alloc] initWithCoordinates:coords];
    TFLineString *ls2 = [[TFLineString alloc] initWithCoordinates:coords];

    XCTAssertTrue([ls1 isEqual:ls2]);
}

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
