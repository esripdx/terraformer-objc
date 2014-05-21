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

@interface TFGeometryCollectionTests : XCTestCase

@end

@implementation TFGeometryCollectionTests

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

- (void)testBBox {
    TFGeometryCollection *gc = [[TFGeometryCollection alloc] initWithGeometries:@[
            [[TFGeometry alloc] initWithType:@"Polygon" coordinates:@[
                    [TFCoordinate coordinateWithX:-5 y:-10],
                    [TFCoordinate coordinateWithX:-2 y:-40],
                    [TFCoordinate coordinateWithX:0 y:35],
                    [TFCoordinate coordinateWithX:5 y:10],
                    [TFCoordinate coordinateWithX:25 y:5]
            ]],
            [[TFGeometry alloc] initWithType:@"Point" coordinates:@[
                    [TFCoordinate coordinateWithX:34 y:0]
            ]]
    ]];
    NSArray *expected = @[@(-5), @(-40), @(34), @(35)];
    XCTAssertEqualObjects(expected, [gc bbox]);
}

@end
