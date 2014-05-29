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
#import "TFPoint.h"

@interface TFPolygonTests : XCTestCase

@property (strong, nonatomic) TFPolygon *emptyPolygon;
@property (strong, nonatomic) TFPolygon *unclosedPolygon;
@property (strong, nonatomic) TFPolygon *closedPolygon;
@property (strong, nonatomic) TFPolygon *polygonWithHole;
@property (strong, nonatomic) TFPolygon *hole;

@end

@implementation TFPolygonTests

- (void)setUp;
{
    [super setUp];
    
    TFCoordinate *a = [TFCoordinate coordinateWithX:1.5 y:2.0];
    TFCoordinate *b = [TFCoordinate coordinateWithX:2.0 y:6.0];
    TFCoordinate *c = [TFCoordinate coordinateWithX:6.5 y:6.5];
    TFCoordinate *d = [TFCoordinate coordinateWithX:8.0 y:1.0];
    
    TFCoordinate *a2 = [TFCoordinate coordinateWithX:3.0 y:5.0];
    TFCoordinate *b2 = [TFCoordinate coordinateWithX:5.0 y:5.5];
    TFCoordinate *c2 = [TFCoordinate coordinateWithX:4.0 y:3.0];

    self.hole = [[TFPolygon alloc] initWithVertices:@[a2, b2, c2]];
    self.emptyPolygon = [[TFPolygon alloc] initWithVertices:nil];
    self.unclosedPolygon = [[TFPolygon alloc] initWithVertices:@[a, b, c, d]];
    self.closedPolygon = [[TFPolygon alloc] initWithVertices:@[a, b, c, d, a]];
    self.polygonWithHole = [[TFPolygon alloc] initWithVertices:@[a, b, c, d, a] holes:self.hole.coordinates];
}

- (void)tearDown;
{
    [super tearDown];
    
    self.emptyPolygon = nil;
    self.unclosedPolygon = nil;
    self.closedPolygon = nil;
    self.polygonWithHole = nil;
}

- (void)testRemoveVertex;
{
    TFCoordinate *removed = [self.closedPolygon vertexAtIndex:1];
    
    [self.closedPolygon removeVertexAtIndex:1];
    
    NSUInteger idx, count;
    
    for ( idx = 0, count = [self.closedPolygon numberOfVertices]; idx < count; idx++ ) {
        TFCoordinate *coordinate = [self.closedPolygon vertexAtIndex:idx];
        XCTAssertNotEqualObjects( removed, coordinate );
    }
}

- (void)testAddVertex;
{
    TFCoordinate *newVertex = [TFCoordinate coordinateWithX:2.0 y:0.2];
    
    [self.closedPolygon insertVertex:newVertex atIndex:2];
    
    BOOL found = NO;
    NSUInteger idx, count;
    
    for ( idx = 0, count = [self.closedPolygon numberOfVertices]; idx < count; idx++ ) {
        TFCoordinate *coordinate = [self.closedPolygon vertexAtIndex:idx];
        found = found || [coordinate isEqual:newVertex];
    }

    XCTAssertTrue( found );
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

- (void)testContainsPoint;
{
    TFPoint *inside = [TFPoint pointWithX:6.0 y:3.0];
    TFPoint *outside = [TFPoint pointWithX:1.0 y:1.0];
    TFPoint *inHole = [TFPoint pointWithX:4.0 y:4.5];

    XCTAssertTrue( [self.polygonWithHole contains:inside] );
    XCTAssertFalse( [self.polygonWithHole contains:outside] );
    XCTAssertFalse( [self.polygonWithHole contains:inHole] );
}

- (void)testAddHole;
{
    TFPoint *inHole = [TFPoint pointWithX:4.0 y:4.5];

    XCTAssertTrue( [self.closedPolygon contains:inHole] );
    [self.closedPolygon insertHole:self.hole atIndex:0];
    XCTAssertFalse( [self.closedPolygon contains:inHole] );
}

- (void)testRemoveHole;
{
    TFPoint *inHole = [TFPoint pointWithX:4.0 y:4.5];
    XCTAssertFalse( [self.polygonWithHole contains:inHole] );
    [self.polygonWithHole removeHoleAtIndex:0];
    XCTAssertTrue( [self.polygonWithHole contains:inHole] );
}

@end
