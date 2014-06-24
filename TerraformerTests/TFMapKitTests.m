//
//  TFMapKitTests.m
//  Terraformer
//
//  Created by mbcharbonneau on 6/24/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFTestData.h"
#import "Terraformer.h"
#import "TFPoint+MapKit.h"
#import "TFLineString+MapKit.h"
#import "TFPolygon+MapKit.h"

@import MapKit;

@interface TFMapKitTests : XCTestCase

@property (strong, nonatomic) TFPoint *point;
@property (strong, nonatomic) TFLineString *lineString;
@property (strong, nonatomic) TFPolygon *polygon;

@end

@implementation TFMapKitTests

- (void)setUp;
{
    [super setUp];

    self.point = (TFPoint *)[TFTestData point];
    self.lineString = (TFLineString *)[TFTestData line_string];
    self.polygon = (TFPolygon *)[TFTestData polygon_with_holes];
}

- (void)tearDown;
{
    self.point = nil;
    self.lineString = nil;
    self.polygon = nil;
    
    [super tearDown];
}

- (void)testDataImport;
{
    XCTAssert( self.point != nil );
    XCTAssert( self.lineString != nil );
    XCTAssert( self.polygon != nil );
}

- (void)testPointToCoreLocation;
{
    CLLocationCoordinate2D coordinate = self.point.coreLocationCoordinateValue;
    
    XCTAssertEqualWithAccuracy( coordinate.latitude, self.point.latitude, 0.00000005 );
    XCTAssertEqualWithAccuracy( coordinate.longitude, self.point.longitude, 0.00000005 );
}

- (void)testLineStringToMapKit;
{
    MKPolyline *polyline = self.lineString.mapKitPolyline;
    CLLocationCoordinate2D coordinates[polyline.pointCount];
    [polyline getCoordinates:coordinates range:NSMakeRange( 0, polyline.pointCount )];

    NSInteger idx;
    
    for ( idx = 0; idx < [self.lineString.points count]; idx++ ) {
        
        TFPoint *point = self.lineString.points[idx];
        CLLocationCoordinate2D coordinate = coordinates[idx];
        
        XCTAssertEqualWithAccuracy( coordinate.latitude, point.latitude, 0.00000005 );
        XCTAssertEqualWithAccuracy( coordinate.longitude, point.longitude, 0.00000005 );
    }
}

- (void)testPolygonToMapKit;
{
    MKPolygon *polygon = self.polygon.mapKitPolygon;
    NSArray *mapKitHoles = polygon.interiorPolygons;
    NSInteger idx, count = self.polygon.numberOfHoles;
    
    // Check interior holes.
    
    for ( idx = 1; idx <= count; idx++ ) {
        TFLineString *lineString = self.polygon.lineStrings[idx];
        MKPolygon *polygonHole = mapKitHoles[idx - 1];
        
        NSInteger jdx, pointCount = polygonHole.pointCount;
        CLLocationCoordinate2D coordinates[polygonHole.pointCount];
        [polygonHole getCoordinates:coordinates range:NSMakeRange( 0, polygonHole.pointCount )];

        for ( jdx = 0; jdx < pointCount; jdx++ ) {
            TFPoint *point = lineString.points[idx];
            CLLocationCoordinate2D coordinate = coordinates[idx];
            
            XCTAssertEqualWithAccuracy( coordinate.latitude, point.latitude, 0.00000005 );
            XCTAssertEqualWithAccuracy( coordinate.longitude, point.longitude, 0.00000005 );

        }
    }
    
    // Check outer linestring.
    
    TFLineString *outerLinestring = [self.polygon.lineStrings firstObject];
    CLLocationCoordinate2D coordinates[polygon.pointCount];
    [polygon getCoordinates:coordinates range:NSMakeRange( 0, polygon.pointCount )];

    for ( idx = 0; idx < [outerLinestring count]; idx++ ) {
        
        TFPoint *point = outerLinestring.points[idx];
        CLLocationCoordinate2D coordinate = coordinates[idx];
        
        XCTAssertEqualWithAccuracy( coordinate.latitude, point.latitude, 0.00000005 );
        XCTAssertEqualWithAccuracy( coordinate.longitude, point.longitude, 0.00000005 );
    }
}

@end
