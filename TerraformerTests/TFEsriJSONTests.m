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

#define DEFAULT_SR @"spatialReference": @{ @"wkid": @4326 }

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
@end
