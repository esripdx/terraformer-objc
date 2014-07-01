//
//  TFEsriJSONTests.m
//  Terraformer
//
//  Created by Ryan Arana on 6/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFTestData.h"
#import "TFTerraformer.h"
#import "TFEsriJSON.h"
#import "TFPoint.h"
#import "TFLineString.h"
#import "TFMultiLineString.h"
#import "TFMultiPoint.h"
#import "TFPolygon.h"

#define DEFAULT_SR @"spatialReference": @{ @"wkid": @4326 }
@interface TFLineString (esrijson)
- (BOOL)isClockwise;
- (BOOL)containsPoint:(TFPoint *)point;
- (BOOL)contains:(TFLineString *)ring;
- (BOOL)isIntersectingLineString:(TFLineString *)lineString;
- (TFLineString *)reversed;
@end

@interface TFPolygon (esrijson)
- (BOOL)containsLineString:(TFLineString *)lineString;
@end

@interface TFEsriJSONTests : XCTestCase

@property (strong, nonatomic) TFTerraformer *terraformer;
@property (copy, nonatomic) NSData *fileData;
@property (copy, nonatomic) NSData *outputData;
@property (copy, nonatomic) NSDictionary *outputDictionary;
@property (strong, nonatomic) TFPrimitive *outputPrimitive;

@end

@implementation TFEsriJSONTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    TFEsriJSON *coder = [TFEsriJSON new];
    self.terraformer = [[TFTerraformer alloc] initWithEncoder:coder decoder:coder];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - helpers

- (void)hydrateFileData:(NSString *)name {
    self.fileData = [TFTestData loadFile:name extension:@"esrijson"];
}


- (void)performDecodingTestForFileName:(NSString *)name withExpected:(TFPrimitive *)expected {
    [self hydrateFileData:name];

    NSError *error;
    self.outputPrimitive = [self.terraformer.decoder decode:self.fileData error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(self.outputPrimitive, expected);
}

- (void)performEncodingTestForFileName:(NSString *)name input:(TFPrimitive *)input withExpected:(NSDictionary *)expected {
    [self hydrateFileData:name];

    NSError *error;
    self.outputData = [self.terraformer.encoder encodePrimitive:input error:&error];
    XCTAssertNil(error);

    self.outputDictionary = [NSJSONSerialization JSONObjectWithData:self.outputData options:0 error:&error];
    XCTAssertNil(error);

    XCTAssertEqualObjects(self.outputDictionary, expected);
}

# pragma mark - Point

- (void)testPointEncoding {
    NSDictionary *expected = @{
            @"x": @100.0,
            @"y": @0.0,
            DEFAULT_SR
    };

    [self performEncodingTestForFileName:@"point"
                                   input:[TFPoint pointWithX:100 y:0]
                            withExpected:expected];
}

- (void)testPointDecoding {
    [self performDecodingTestForFileName:@"point" withExpected:[TFPoint pointWithX:100 y:0]];
}

#pragma mark - LineString (Polyline)

- (NSArray *)lineStringCoords {
    return @[
            @[@100.0, @0.0],
            @[@101.0, @1.0],
            @[@100.0, @1.0],
            @[@99.0, @0.0]
    ];
}

- (void)testLineStringEncoding {
    TFLineString *input = [TFLineString lineStringWithCoords:[self lineStringCoords]];
    NSDictionary *expected = @{
            @"paths": [self lineStringCoords],
            DEFAULT_SR
    };

    [self performEncodingTestForFileName:@"line_string" input:input withExpected:expected];
}

- (void)testLineStringDecoding {
    [self performDecodingTestForFileName:@"line_string"
                            withExpected:[TFLineString lineStringWithCoords:[self lineStringCoords]]];
}

#pragma mark - MultiLineString

- (NSArray *)multiLineStringCoords {
    return @[
            @[ @[@100.0, @0.0], @[@101.0, @1.0] ],
            @[ @[@102.0, @2.0], @[@103.0, @3.0] ]
    ];
}

- (NSArray *)multiLineStrings {
    NSMutableArray *lineStrings = [NSMutableArray new];
    for (NSArray *ls in [self multiLineStringCoords]) {
        [lineStrings addObject:[TFLineString lineStringWithCoords:ls]];
    }
    return [lineStrings copy];
}

- (void)testMultiLineStringEncoding {
    TFMultiLineString *input = [TFMultiLineString multiLineStringWithLineStrings:[self multiLineStrings]];
    NSDictionary *expected = @{
            @"paths": [self multiLineStringCoords],
            DEFAULT_SR
    };

    [self performEncodingTestForFileName:@"multi_line_string" input:input withExpected:expected];
}

- (void)testMultiLineStringDecoding {
    [self performDecodingTestForFileName:@"multi_line_string"
                            withExpected:[TFMultiLineString multiLineStringWithLineStrings:[self multiLineStrings]]];
}

#pragma mark - MultiPoint

- (NSArray *)multiPointPoints {
    NSMutableArray *points = [NSMutableArray new];
    for (NSArray *coords in [self lineStringCoords]) {
        [points addObject:[TFPoint pointWithCoordinates:coords]];
    }
    return [points copy];
}

- (void)testMultiPointEncoding {
    NSDictionary *expected = @{
            @"points": [self lineStringCoords],
            DEFAULT_SR
    };

    [self performEncodingTestForFileName:@"multi_point"
                                   input:[TFMultiPoint multiPointWithPoints:[self multiPointPoints]]
                            withExpected:expected];
}

- (void)testMultiPointDecoding {
    [self performDecodingTestForFileName:@"multi_point"
                            withExpected:[TFMultiPoint multiPointWithPoints:[self multiPointPoints]]];
}

#pragma mark - Polygon

- (NSArray *)polygonExteriorRing {
    return @[ @[@100.0, @0.0], @[@100.0, @1.0], @[@101.0, @1.0], @[@101.0, @0.0], @[@100.0, @0.0] ];
}

- (NSArray *)polygonHole {
    return @[ @[@100.2, @0.2], @[@100.8, @0.2], @[@100.8, @0.8], @[@100.2, @0.8], @[@100.2, @0.2] ];
}

- (NSArray *)polygonLineStringWithRings:(NSArray *)rings {
    NSMutableArray *lineStrings = [NSMutableArray new];
    for (NSArray *ring in rings) {
        [lineStrings addObject:[TFLineString lineStringWithCoords:ring]];
    }
    return [lineStrings copy];
}

- (void)testPolygonEncoding {
    // without holes
    NSDictionary *expected = @{
            @"rings": @[[self polygonExteriorRing]],
            DEFAULT_SR
    };
    TFPolygon *input = [TFPolygon polygonWithLineStrings:[self polygonLineStringWithRings:@[[self polygonExteriorRing]]]];

    [self performEncodingTestForFileName:@"polygon" input:input withExpected:expected];

    // with holes
    expected = @{
            @"rings": @[
                    [self polygonExteriorRing],
                    [self polygonHole]
            ],
            DEFAULT_SR
    };
    input = [TFPolygon polygonWithLineStrings:[self polygonLineStringWithRings:@[
            [self polygonExteriorRing],
            [self polygonHole]
    ]]];

    [self performEncodingTestForFileName:@"polygon_with_holes" input:input withExpected:expected];
}

- (void)testPolygonDecoding {
    // without holes
    TFPolygon *expected = [TFPolygon polygonWithLineStrings:[self polygonLineStringWithRings:@[[self polygonExteriorRing]]]];
    [self performDecodingTestForFileName:@"polygon" withExpected:expected];

    // with holes
    expected = [TFPolygon polygonWithLineStrings:[self polygonLineStringWithRings:@[
            [self polygonExteriorRing],
            [self polygonHole]
    ]]];
    [self performDecodingTestForFileName:@"polygon_with_holes" withExpected:expected];
}

- (NSArray *)clockwiseCoords {
    return @[
            @[@0, @0],
            @[@0, @0.9],
            @[@0.9, @0.9],
            @[@0.9, @0],
            @[@0, @0]
    ];
}

- (NSArray *)counterClockwiseCoords {
    return @[
            @[@0, @0],
            @[@0.9, @0],
            @[@0.9, @0.9],
            @[@0, @0.9],
            @[@0, @0]
    ];
}

- (void)testReversedLineString {
    TFLineString *clockwise = [TFLineString lineStringWithCoords:[self clockwiseCoords]];
    TFLineString *expected = [TFLineString lineStringWithCoords:[self counterClockwiseCoords]];

    XCTAssertEqualObjects([clockwise reversed], expected);
}

- (void)testIsClockwise {
    TFLineString *clockwise = [TFLineString lineStringWithCoords:[self clockwiseCoords]];
    XCTAssertEqual([clockwise isClockwise], YES);

    TFLineString *counterClockwise = [TFLineString lineStringWithCoords:[self counterClockwiseCoords]];
    XCTAssertEqual([counterClockwise isClockwise], NO);
}

- (void)testContainsPoint {
    TFLineString *ring = [TFLineString lineStringWithCoords:@[
            @[@-10, @-10],
            @[@-10, @10],
            @[@10,  @10],
            @[@10,  @-10],
            @[@-10, @-10]
    ]];
    TFPoint *center = [TFPoint pointWithX:0 y:0];
    TFPoint *outside = [TFPoint pointWithX:100 y:100];

    XCTAssertTrue([ring containsPoint:center]);
    XCTAssertFalse([ring containsPoint:outside]);
}

- (void)testIsIntersectingLineString {
    TFLineString *horizontal = [TFLineString lineStringWithCoords:@[
            @[@-1, @0], @[@1, @0]
    ]];
    TFLineString *vertical = [TFLineString lineStringWithCoords:@[
            @[@0, @1], @[@0, @-1]
    ]];
    TFLineString *ls = [TFLineString lineStringWithCoords:@[
            @[@-10, @2], @[@10, @2]
    ]];

    XCTAssertTrue([horizontal isIntersectingLineString:vertical]);
    XCTAssertTrue([vertical isIntersectingLineString:horizontal]);
    XCTAssertFalse([horizontal isIntersectingLineString:ls]);
    XCTAssertFalse([vertical isIntersectingLineString:ls]);
    XCTAssertFalse([ls isIntersectingLineString:vertical]);
    XCTAssertFalse([ls isIntersectingLineString:horizontal]);
}

- (void)testContains {
    TFLineString *outer = [TFLineString lineStringWithCoords:@[
            @[@-10, @10], @[@10, @10],
            @[@10, @-10], @[@-10, @-10],
            @[@-10, @10]
    ]];
    TFLineString *inner = [TFLineString lineStringWithCoords:@[
            @[@-1, @1], @[@1, @1],
            @[@1, @-1], @[@-1, @-1],
            @[@-1, @1]
    ]];
    TFLineString *external = [TFLineString lineStringWithCoords:@[
            @[@100, @101], @[@101, @101],
            @[@101, @100], @[@100, @100],
            @[@100, @101]
    ]];

    XCTAssertTrue([outer contains:inner]);
    XCTAssertFalse([inner contains:outer]);
    XCTAssertFalse([external contains:outer]);
    XCTAssertFalse([outer contains:external]);
}

- (void)testContainsLineString {
    TFPolygon *outer = [TFPolygon polygonWithLineStrings:@[
            [TFLineString lineStringWithCoords:@[
                    @[@-10, @10], @[@10, @10],
                    @[@10, @-10], @[@-10, @-10],
                    @[@-10, @10]
            ]],
            [TFLineString lineStringWithCoords:@[
                    @[@-5, @5], @[@-5, @0],
                    @[@5, @0], @[@5, @5],
                    @[@-5, @5]
            ]]
    ]];

    TFLineString *insideHole = [TFLineString lineStringWithCoords:@[
            @[@-4, @1], @[@4, @1],
            @[@4, @2], @[@-4, @2],
            @[@-4, @1]
    ]];
    TFLineString *insidePoly = [TFLineString lineStringWithCoords:@[
            @[@8, @-1], @[@9, @-1],
            @[@9, @-2], @[@8, @-2],
            @[@8, @-1]
    ]];
    TFLineString *external = [TFLineString lineStringWithCoords:@[
            @[@100, @101], @[@101, @101],
            @[@101, @100], @[@100, @100],
            @[@100, @101]
    ]];

    XCTAssertTrue([outer containsLineString:insidePoly]);
    XCTAssertFalse([outer containsLineString:external]);
    XCTAssertFalse([outer containsLineString:insideHole]);
}
@end
