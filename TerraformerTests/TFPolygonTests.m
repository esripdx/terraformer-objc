//
//  TFPolygonTests.m
//  Terraformer
//
//  Created by mbcharbonneau on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFPolygon.h"
#import "TFCoordinate.h"

@interface TFPolygonTests : XCTestCase

@property (strong, nonatomic) TFPolygon *emptyPolygon;
@property (strong, nonatomic) TFPolygon *unclosedPolygon;
@property (strong, nonatomic) TFPolygon *closedPolygon;

@end

@implementation TFPolygonTests

- (void)setUp;
{
    [super setUp];
    
    TFCoordinate *a = [TFCoordinate coordinateWithX:1.5 y:8.0];
    TFCoordinate *b = [TFCoordinate coordinateWithX:2.5 y:4.0];
    TFCoordinate *c = [TFCoordinate coordinateWithX:1.5 y:7.0];
    
    self.emptyPolygon = [[TFPolygon alloc] initWithVertices:nil];
    self.unclosedPolygon = [[TFPolygon alloc] initWithVertices:@[a, b, c]];
    self.closedPolygon = [[TFPolygon alloc] initWithVertices:@[a, b, c, a]];
}

- (void)tearDown;
{
    [super tearDown];
    
    self.emptyPolygon = nil;
    self.unclosedPolygon = nil;
    self.closedPolygon = nil;
}

- (void)testRemoveVertex;
{
    
}

- (void)testAddVertex;
{
    
}

- (void)testClosePolygon;
{
    XCTAssertFalse( [self.emptyPolygon isClosed] );
    XCTAssertFalse( [self.unclosedPolygon isClosed] );
    XCTAssertTrue( [self.closedPolygon isClosed] );
    
    [self.emptyPolygon close];
    [self.unclosedPolygon close];
    [self.closedPolygon close];
    
    XCTAssertFalse( [self.emptyPolygon isClosed] );
    XCTAssertTrue( [self.unclosedPolygon isClosed] );
    XCTAssertTrue( [self.closedPolygon isClosed] );
}

@end
