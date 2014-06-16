//
// Created by Josh Yaganeh on 5/22/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFPoint.h"

@interface TFPointTests : XCTestCase
@property TFPoint *point1;
@property TFPoint *point2;
@property TFPoint *point3;
@property TFPoint *point4;
@property TFPoint *anotherPoint;
@end

@implementation TFPointTests

- (void)setUp {
    self.point1 = [[TFPoint alloc] initWithX:1 y:1];

    NSArray *c = @[@(1), @(1)];
    self.point2 = [[TFPoint alloc] initWithCoordinates:c];
    self.point3 = [TFPoint pointWithCoordinates:c];
    self.point4 = [TFPoint pointWithX:1 y:1];

    self.anotherPoint = [TFPoint pointWithX:1.5 y:1.5];
}

- (void)testCreatePoint {
    // check the coordinates of p1
    XCTAssertEqual(self.point1.x, 1);
    XCTAssertEqual(self.point1.y, 1);

    // make sure all the other points are equal
    XCTAssertEqualObjects(self.point1, self.point2);
    XCTAssertEqualObjects(self.point2, self.point3);
    XCTAssertEqualObjects(self.point3, self.point4);
}

- (void)testHash {
    // same coordinates should have the same hash
    XCTAssertEqual([self.point1 hash], [self.point2 hash]);

    // different coordinates should not
    XCTAssertNotEqual([self.point1 hash], [self.anotherPoint hash]);
}

- (void)testIsEqual {
    // same coordinates should be equal
    XCTAssertEqualObjects(self.point1, self.point2);

    // different coordinates should not
    XCTAssertNotEqualObjects(self.point1, self.anotherPoint);
}

@end