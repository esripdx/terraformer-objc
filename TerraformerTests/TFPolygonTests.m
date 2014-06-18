//
//  TFPolygonTests.m
//  Terraformer
//
//  Created by mbcharbonneau on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFPolygon.h"
#import "TFPoint.h"
#import "TFLineString.h"
#import "TFTestData.h"

@interface TFPolygonTests : XCTestCase

@property (strong, nonatomic) TFPolygon *polygon;
@property (strong, nonatomic) TFPolygon *otherPolygon;
@property (strong, nonatomic) TFPolygon *polygonWithHole;
@property (strong, nonatomic) TFLineString *exteriorLineString;
@property (strong, nonatomic) TFLineString *interiorLineString;

@end

@implementation TFPolygonTests

- (void)setUp;
{
    [super setUp];
    
    TFPoint *a = [TFPoint pointWithX:1.5 y:2.0];
    TFPoint *b = [TFPoint pointWithX:2.0 y:6.0];
    TFPoint *c = [TFPoint pointWithX:6.5 y:6.5];
    TFPoint *d = [TFPoint pointWithX:8.0 y:1.0];
    
    TFPoint *a2 = [TFPoint pointWithX:3.0 y:5.0];
    TFPoint *b2 = [TFPoint pointWithX:5.0 y:5.5];
    TFPoint *c2 = [TFPoint pointWithX:4.0 y:3.0];

    self.exteriorLineString = [TFLineString lineStringWithPoints:@[a, b, c, d, a]];
    self.interiorLineString = [TFLineString lineStringWithPoints:@[a2, b2, c2, a2]];
    
    self.polygon = [TFPolygon polygonWithLineStrings:@[self.exteriorLineString]];
    self.otherPolygon = [TFPolygon polygonWithLineStrings:@[self.exteriorLineString]];
    self.polygonWithHole = [TFPolygon polygonWithLineStrings:@[self.exteriorLineString, self.interiorLineString]];
}

- (void)tearDown;
{
    [super tearDown];

    self.polygonWithHole = nil;
    self.polygon = nil;
    self.otherPolygon = nil;
}

- (void)testEquality {
    XCTAssertEqualObjects(self.polygon, self.otherPolygon);
    XCTAssertNotEqualObjects(self.polygon, self.polygonWithHole);
}

- (void)testHash {
    XCTAssertEqual([self.polygon hash], [self.otherPolygon hash]);
    XCTAssertNotEqual([self.polygon hash], [self.polygonWithHole hash]);
}

- (void)testHasHoles {
    XCTAssert([self.polygonWithHole hasHoles]);
    XCTAssert(![self.polygon hasHoles]);
}

- (void)testNumberOfHoles {
    XCTAssertEqual([self.polygonWithHole numberOfHoles], 1);
    XCTAssertEqual([self.polygon numberOfHoles], 0);
}

- (void)testPolygonSubscripting {
    XCTAssertEqualObjects(self.exteriorLineString, self.polygon[0]);
    XCTAssertEqualObjects(self.interiorLineString, self.polygonWithHole[1]);
}

- (void)testDataFiles {
    TFPolygon *polygon = (TFPolygon *)[TFTestData polygon];
    XCTAssertEqualObjects(polygon[0][0][0], @(100));
    XCTAssert(![polygon hasHoles]);

    TFPolygon *circle = (TFPolygon *)[TFTestData circle];
    XCTAssert(![circle hasHoles]);

    TFPolygon *polygonWithHoles = (TFPolygon *)[TFTestData polygon_with_holes];
    XCTAssert([polygonWithHoles hasHoles]);
}
@end
