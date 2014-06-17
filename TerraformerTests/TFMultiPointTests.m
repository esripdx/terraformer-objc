//
//  TFMultiPointTests.m
//  Terraformer
//
//  Created by Josh Yaganeh on 5/23/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFPoint.h"
#import "TFMultiPoint.h"

@interface TFMultiPointTests : XCTestCase
@property TFPoint *point;
@property TFPoint *anotherPoint;
@property TFMultiPoint *mp1;
@property TFMultiPoint *mp2;
@property TFMultiPoint *anotherMultipoint;
@end

@implementation TFMultiPointTests

- (void)setUp {
    [super setUp];

    self.point = [[TFPoint alloc] initWithX:1 y:1];
    self.anotherPoint = [[TFPoint alloc] initWithX:2 y:2];

    self.mp1 = [TFMultiPoint multiPointWithPoints:@[self.point]];
    self.mp2 = [[TFMultiPoint alloc] initWithPoints:@[self.point]];
    self.anotherMultipoint = [TFMultiPoint multiPointWithPoints:@[self.point, self.anotherPoint]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateMultiPoint {
    XCTAssertEqualObjects(self.point, self.mp1[0]);
    XCTAssertEqualObjects(self.mp1, self.mp2);
}

- (void)testHash {
    XCTAssertEqual(self.mp1.hash, self.mp2.hash);
    XCTAssertNotEqual(self.mp1, self.anotherMultipoint);
}

@end
