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

#define DEFAULT_SR @"spatialReference": @{ @"wkid": @(4326) }

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

- (void)testPointEncoding {
    NSDictionary *expected = @{
            @"x": @(100),
            @"y": @(0),
            DEFAULT_SR
    };

    [self performEncodingTestForFileName:@"point"
                                   input:[TFPoint pointWithX:100 y:0]
                            withExpected:expected];
}

- (void)testPointDecoding {
    TFPoint *expected = [TFPoint pointWithX:100 y:0];

    [self performDecodingTestForFileName:@"point" withExpected:expected];
}

- (NSArray *)lineStringCoords {
    return @[
            @[@(100), @(0)],
            @[@(101), @(1)],
            @[@(100), @(1)],
            @[@(99), @(0)]
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

@end
