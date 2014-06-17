//
//  TFMultiPolygonTests.m
//  Terraformer
//
//  Created by mbcharbonneau on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFPolygon.h"
#import "TFMultiPolygon.h"
#import "TFPoint.h"
#import "TFLineString.h"
#import "TFTestData.h"

@interface TFMultiPolygonTests : XCTestCase

@property (strong, nonatomic) TFMultiPolygon *multiPolygonA;
@property (strong, nonatomic) TFPolygon *polygonA;
@property (strong, nonatomic) TFPolygon *polygonB;
@property (strong, nonatomic) TFPolygon *polygonC;

@end

@implementation TFMultiPolygonTests

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

    TFLineString *exterior = [TFLineString lineStringWithPoints:@[a2, b2, c2]];
    TFLineString *interior = [TFLineString lineStringWithPoints:@[a, b, c, d, a]];

    self.polygonA = [TFPolygon polygonWithLineStrings:@[interior, exterior]];
    
    a = [TFPoint pointWithX:1.0 y:1.0];
    b = [TFPoint pointWithX:2.0 y:3.0];
    c = [TFPoint pointWithX:3.0 y:1.0];

    self.polygonB = [TFPolygon polygonWithLineStrings:@[[TFLineString lineStringWithPoints:@[a, b, c, a]]]];
    
    a = [TFPoint pointWithX:2.0 y:2.0];
    b = [TFPoint pointWithX:2.0 y:4.0];
    c = [TFPoint pointWithX:4.0 y:3.0];

    self.polygonC = [TFPolygon polygonWithLineStrings:@[[TFLineString lineStringWithPoints:@[a, b, c, a]]]];

    self.multiPolygonA = [[TFMultiPolygon alloc] initWithPolygons:@[self.polygonA, self.polygonB, self.polygonC]];
}

- (void)tearDown;
{
    [super tearDown];
    
    self.multiPolygonA = nil;

    self.polygonA = nil;
    self.polygonB = nil;
    self.polygonC = nil;
}

- (void)testCreate {
    XCTAssertEqualObjects(self.multiPolygonA[0], self.polygonA);
}

- (void)testHash {
    TFMultiPolygon *mp = [TFMultiPolygon multiPolygonWithPolygons:@[self.polygonA, self.polygonB, self.polygonC]];
    XCTAssertEqual([self.multiPolygonA hash], [mp hash]);

    mp.polygons = @[self.polygonA];
    XCTAssertNotEqual([self.multiPolygonA hash], [mp hash]);
}

- (void)testDataFiles {
    TFMultiPolygon *multiPolygon = (TFMultiPolygon *)[TFTestData multi_polygon];
    XCTAssertEqualObjects(multiPolygon[0][0][0][0], @(102));

    TFMultiPolygon *sfCounty = (TFMultiPolygon *)[TFTestData sf_county];
    XCTAssertEqualObjects(sfCounty[0][0][0][0], @(-123.00111));
}

@end
