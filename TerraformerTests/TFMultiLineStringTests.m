//
//  TFMultiLineString.m
//  Terraformer
//
//  Created by Jen on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFLineString.h"
#import "TFCoordinate.h"
#import "TFMultiLineString.h"

@interface TFMultiLineStringTests : XCTestCase

@property (strong, nonatomic) TFMultiLineString *multilinestring;
@property (strong, nonatomic) TFCoordinate *coord1;
@property (strong, nonatomic) TFCoordinate *coord2;
@property (strong, nonatomic) TFCoordinate *coord3;
@property (strong, nonatomic) TFCoordinate *coord4;
@property (strong, nonatomic) NSArray *line1;
@property (strong, nonatomic) NSArray *line2;
@property (strong, nonatomic) NSArray *lines;

@end

@implementation TFMultiLineStringTests

- (void)setUp
{
    [super setUp];

    self.coord1 = [TFCoordinate coordinateWithX:5 y:10];
    self.coord2 = [TFCoordinate coordinateWithX:6 y:11];
    self.coord3 = [TFCoordinate coordinateWithX:7 y:12];
    self.coord4 = [TFCoordinate coordinateWithX:8 y:13];
    self.line1 = @[self.coord1, self.coord2];
    self.line2 = @[self.coord3, self.coord4];

    self.lines = @[self.line1, self.line2];
    self.multilinestring = [[TFMultiLineString alloc] initWithCoordinateArrays:self.lines];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitsWithCoordinates
{

    XCTAssertEqual(self.multilinestring.coordinates, self.lines);
    XCTAssertEqual(self.multilinestring.coordinates[0], self.line1);
    XCTAssertEqual(self.multilinestring.coordinates[1], self.line2);
    XCTAssertEqual([self.multilinestring.coordinates[0][0] x], [self.coord1 x]);
    XCTAssertEqual([self.multilinestring.coordinates[0][1] x], [self.coord2 x]);
    XCTAssertEqual([self.multilinestring.coordinates[1][0] x], [self.coord3 x]);
    XCTAssertEqual([self.multilinestring.coordinates[1][1] x], [self.coord4 x]);

}

@end
