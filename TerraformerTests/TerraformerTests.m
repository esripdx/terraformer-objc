//
//  TerraformerTests.m
//  TerraformerTests
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFCoordinate.h"

@interface TerraformerTests : XCTestCase

@end

@implementation TerraformerTests

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

- (void)testCoordinate {
    TFCoordinate *c = [TFCoordinate coordinateWithX:5 y:10];
    XCTAssertEqual(5, c.x);
    XCTAssertEqual(10, c.y);
}

@end
