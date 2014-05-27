//
//  TFMultiLineString.m
//  Terraformer
//
//  Created by Jen on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFMultiLineString.h"
#import "TFCoordinate.h"
#import "TFGeometry+Protected.h"

@implementation TFMultiLineString

#pragma mark TFMultiLineString

+ (instancetype)lineStringsWithCoordinateArrays:(NSArray *)lines
{
    return [[self alloc] initWithCoordinateArrays:lines];
}

- (instancetype)initWithCoordinateArrays:(NSArray *)lines;
{
    if ([lines count] > 0 && [lines[0] isKindOfClass:[NSArray class]]) {
        // each linestring much be an array of coordinates
        for (NSArray *array in lines) {
            if (![array isKindOfClass:[NSArray class]]) {
                return nil;
            }
        }

        if ([lines[0] count] > 0) {
            // some coords are in thar
            if ([TFCoordinate isTFCoordinate:lines[0][0]]) {
                return [super initSubclassWithCoordinates:lines];
            }
        }
    }

    return nil;
}

#pragma mark TFPrimitive

- (TFPrimitiveType)type;
{
    return TFPrimitiveTypeMultiLineString;
}

@end
