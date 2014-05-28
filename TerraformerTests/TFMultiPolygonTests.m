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
#import "TFCoordinate.h"

@interface TFMultiPolygonTests : XCTestCase

@property (strong, nonatomic) TFMultiPolygon *multiPolygonA;
@property (strong, nonatomic) TFMultiPolygon *multiPolygonB;
@property (strong, nonatomic) TFPolygon *polygonA;
@property (strong, nonatomic) TFPolygon *polygonB;
@property (strong, nonatomic) TFPolygon *polygonC;

@end

@implementation TFMultiPolygonTests

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
    
    NSArray *hole = @[a2, b2, c2];

    self.polygonA = [[TFPolygon alloc] initWithVertices:@[a, b, c, d, a] holes:@[hole]];
    
    a = [TFCoordinate coordinateWithX:1.0 y:1.0];
    b = [TFCoordinate coordinateWithX:2.0 y:3.0];
    c = [TFCoordinate coordinateWithX:3.0 y:1.0];

    self.polygonB = [[TFPolygon alloc] initWithVertices:@[a, b, c, a]];
    
    a = [TFCoordinate coordinateWithX:2.0 y:2.0];
    b = [TFCoordinate coordinateWithX:2.0 y:4.0];
    c = [TFCoordinate coordinateWithX:4.0 y:3.0];

    self.polygonC = [[TFPolygon alloc] initWithVertices:@[a, b, c, a]];
    
    NSArray *coordinates = @[self.polygonA.coordinates, self.polygonB.coordinates, self.polygonC.coordinates];
    
    self.multiPolygonA = [[TFMultiPolygon alloc] initWithPolygons:@[self.polygonA, self.polygonB, self.polygonC]];
    self.multiPolygonB = [[TFMultiPolygon alloc] initWithPolygonCoordinateArrays:coordinates];
}

- (void)tearDown;
{
    [super tearDown];
    
    self.multiPolygonA = nil;
    self.multiPolygonB = nil;
    
    self.polygonA = nil;
    self.polygonB = nil;
    self.polygonC = nil;
}

- (void)testInitialization;
{
    // Test -initWithPolygons: and -initWithPolygonCoordinateArrays: produce
    // the same data, both as polygons and coordinate arrays.
    
    XCTAssertTrue( [self.multiPolygonA.coordinates isEqualToArray:self.multiPolygonB.coordinates] );
    
    NSInteger index;
    
    for ( index = 0; index < [self.multiPolygonA numberOfPolygons]; index++ ) {
        TFPolygon *a = [self.multiPolygonA polygonAtIndex:index];
        TFPolygon *b = [self.multiPolygonB polygonAtIndex:index];
        
        XCTAssertTrue( [a isEqualToPolygon:b] );
    }
}

- (void)testInsertPolygon;
{
    XCTAssertFalse( [[self.multiPolygonA polygonAtIndex:0] isEqualToPolygon:self.polygonC] );
    [self.multiPolygonA insertPolygon:self.polygonC atIndex:0];
    XCTAssertTrue( [[self.multiPolygonA polygonAtIndex:0] isEqualToPolygon:self.polygonC] );
}

- (void)testRemovePolygon;
{
    XCTAssertTrue( [[self.multiPolygonA polygonAtIndex:0] isEqualToPolygon:self.polygonA] );
    [self.multiPolygonA removePolygonAtIndex:0];
    XCTAssertFalse( [[self.multiPolygonA polygonAtIndex:0] isEqualToPolygon:self.polygonA] );
}

@end
