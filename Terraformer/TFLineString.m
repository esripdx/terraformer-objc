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

+ (instancetype)lineStringWithCoordinates:(NSArray *)coordinates {
    return [[self alloc] initWithCoordinates:coordinates];
}

+ (instancetype)lineStringWithXYs:(NSArray *)xys {
    return [[self alloc] initWithXYs:xys];
}

// Populate coordinates with array of TFCoordinates
- (instancetype)initWithCoordinates:(NSArray *)coordinates
{
    if (self = [super init]) {
        if ([coordinates count] > 0 && [coordinates[0] isKindOfClass:[TFCoordinate class]]) {
            self.coordinates = coordinates;
        }
    }

    return self;
}

// Populate coordinates with array of [x, y] pairs
- (instancetype)initWithXYs:(NSArray *)xys
{
    NSMutableArray *mutableCoordinates = [NSMutableArray arrayWithCapacity:[xys count]];
    if (self = [super init]) {
        if ([xys count] > 0 && [xys[0] isKindOfClass:[NSArray class]]) {
            for (NSArray *xy in xys) {
                TFCoordinate *coordinate = [TFCoordinate coordinateWithX:[xy[0] doubleValue] y:[xy[1] doubleValue]];
                [mutableCoordinates addObject:coordinate];
            }

            self.coordinates = [[NSArray alloc] initWithArray:mutableCoordinates];
        }
    }

    return self;
}

- (TFPrimitiveType)type {
    return TFPrimitiveTypeLineString;
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

    // gotta be a LineString y'all
    if (json[TFTypeKey] && [json[TFTypeKey] isEqual:kGeoJsonType]) {

        // must contain coordinates array
        if (json[TFCoordinatesKey] && [json[TFCoordinatesKey] isKindOfClass:[NSArray class]]) {

            // JSON coordinates contain arrays
            if ([json[TFCoordinatesKey] count] > 0 && [json[TFCoordinatesKey][0] isKindOfClass:[NSArray class]]) {
                return [[self alloc] initWithXYs:json[TFCoordinatesKey]];

            // JSON coordinates contain TFCoordinates--will this ever be the case?
            } else if ([json[TFCoordinatesKey] count] > 0 && [json[TFCoordinatesKey][0] isKindOfClass:[TFCoordinate class]]) {
                return [[self alloc] initWithCoordinates:json[TFCoordinatesKey]];
            }
        }
    }

    return nil;
}

- (BOOL)isEqual:(id)other
{
    if ([other isKindOfClass:[TFLineString class]]) {
        TFLineString *otherLineString = (TFLineString *)other;
        if ([self.coordinates isEqual:otherLineString.coordinates]) {
            return YES;
        }
    }

    return NO;
}

/*

 A LinearRing is closed LineString with 4 or more positions. 
 The first and last positions are equivalent (they represent equivalent points). 
 Though a LinearRing is not explicitly represented as a GeoJSON geometry type, 
 it is referred to in the Polygon geometry type definition.

 */
- (BOOL)isLinearRing
{
    if ([self.coordinates count] > 3) {
        TFCoordinate *first = (TFCoordinate *)self.coordinates[0];
        TFCoordinate *last = (TFCoordinate *)self.coordinates[[self.coordinates count]-1];
        if ([first isEqual:last]) {
            return YES;
        }
    }
    return NO;
}

@end
