//
//  TFLineString.m
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFLineString.h"
#import "TFCoordinate.h"

@implementation TFLineString

NSString const static *kGeoJsonType = @"LineString";

- (instancetype)initWithCoordinates:(NSArray *)coordinates
{
    if (self = [super init]) {
        if ([coordinates count] > 0 && [coordinates[0] isKindOfClass:[TFCoordinate class]]) {
            self.coordinates = coordinates;
        }
    }

    return self;
}

- (instancetype)initWithXYs:(NSArray *)xys
{
    NSMutableArray *mutableCoordinates = [NSMutableArray arrayWithCapacity:[xys count]];
    if (self = [super init]) {
        if ([xys count] > 0 && [xys[0] isKindOfClass:[NSArray class]]) {
            for (NSArray *xy in xys) {
                TFCoordinate *coordinate = [TFCoordinate coordinateWithX:[xy[0] doubleValue] y:[xy[1] doubleValue]];
                [mutableCoordinates addObject:coordinate];
            }

            self.coordinates = [NSArray arrayWithArray:mutableCoordinates];
        }
    }

    return self;
}

- (NSDictionary *)encodeJSON {
    return @{
             TFTypeKey: kGeoJsonType,
             TFCoordinatesKey: self.coordinates
             };
}

/*
 { "type": "LineString",
 "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
 }
*/
+ (instancetype)decodeJSON:(NSDictionary *)json {

    if (json[TFTypeKey] && [json[TFTypeKey] isEqual:kGeoJsonType]) {
        if (json[TFCoordinatesKey] && [json[TFCoordinatesKey] isKindOfClass:[NSArray class]]) {
            if ([json[TFCoordinatesKey] count] > 0 && [json[TFCoordinatesKey][0] isKindOfClass:[TFCoordinate class]]) {
                return [[self alloc] initWithCoordinates:json[TFCoordinatesKey]];
            } else if ([json[TFCoordinatesKey] count] > 0 && [json[TFCoordinatesKey][0] isKindOfClass:[NSArray class]]) {
                return [[self alloc] initWithXYs:json[TFCoordinatesKey]];
            }
        }
    }

    return nil;
}

// TODO implement this jam
- (BOOL)isLinearRing
{
    return false;
}

@end
