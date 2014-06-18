//
//  TFMultiLineString.m
//  Terraformer
//
//  Created by Jen on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFLineString.h"
#import "TFMultiLineString.h"
#import "TFPoint.h"
#import "TFTestData.h"

@interface TFMultiLineStringTests : XCTestCase

@property (strong, nonatomic) TFMultiLineString *multilinestring;
@property (strong, nonatomic) TFPoint *point1;
@property (strong, nonatomic) TFPoint *point2;
@property (strong, nonatomic) TFPoint *point3;
@property (strong, nonatomic) TFPoint *point4;
@property (strong, nonatomic) NSArray *line1;
@property (strong, nonatomic) NSArray *line2;
@property (strong, nonatomic) NSArray *lines;

@end

@implementation TFMultiLineStringTests

- (void)setUp
{
    [super setUp];

    self.point1 = [TFPoint pointWithX:5 y:10];
    self.point2 = [TFPoint pointWithX:6 y:11];
    self.point3 = [TFPoint pointWithX:7 y:12];
    self.point4 = [TFPoint pointWithX:8 y:13];
    self.line1 = @[self.point1, self.point2];
    self.line2 = @[self.point3, self.point4];

    self.lines = @[self.line1, self.line2];
    self.multilinestring = [TFMultiLineString multiLineStringWithLineStrings:self.lines];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitsWithCoordinates
{

    XCTAssertEqual(self.multilinestring.lineStrings, self.lines);
    XCTAssertEqual(self.multilinestring[0], self.line1);
    XCTAssertEqual(self.multilinestring[1], self.line2);
    XCTAssertEqual([self.multilinestring[0][0] x], [self.point1 x]);
    XCTAssertEqual([self.multilinestring[0][1] x], [self.point2 x]);
    XCTAssertEqual([self.multilinestring[1][0] x], [self.point3 x]);
    XCTAssertEqual([self.multilinestring[1][1] x], [self.point4 x]);

}

- (void)testDataFiles {
    TFMultiLineString *mls = (TFMultiLineString *)[TFTestData multi_line_string];

    XCTAssert(mls.type == TFPrimitiveTypeMultiLineString);
    XCTAssert([mls count] == 2);
    XCTAssertEqualObjects(mls[0][0][0], @(100));
}

@end
