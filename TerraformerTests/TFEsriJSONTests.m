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

@interface TFEsriJSONTests : XCTestCase

@property (strong, nonatomic) TFTerraformer *terraformer;
@property (strong, nonatomic) NSData *data;

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

- (void)hydrateData:(NSString *)name {
    self.data = [TFTestData loadFile:name extension:@"esrijson"];
}

- (void)testPointEncoding {
    [self hydrateData:@"point"];

    NSError *e;
    TFPoint *point = [TFPoint pointWithX:100 y:0];
    NSData *output = [self.terraformer.encoder encodePrimitive:point error:&e];
    XCTAssertNil(e);

    NSDictionary *outputDict = [NSJSONSerialization JSONObjectWithData:output options:0 error:&e];
    XCTAssertNil(e);

    NSDictionary *expected = @{
            @"x": @(100),
            @"y": @(0),
            @"spatialReference": @{
                    @"wkid": @(4326)
            }
    };
    XCTAssertEqualObjects(outputDict, expected);
}

- (void)testPointDecoding {
    [self hydrateData:@"point"];

    NSError *e;
    TFPoint *output = (TFPoint *)[self.terraformer.decoder decode:self.data error:&e];
    TFPoint *expected = [TFPoint pointWithX:100 y:0];

    XCTAssertNil(e);
    XCTAssertEqualObjects(output, expected);
}

@end
