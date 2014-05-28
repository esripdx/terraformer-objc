//
//  TFGeometry+Protected.m
//  Terraformer
//
//  Created by Courtf on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry+Protected.h"
#import "TFCoordinate.h"

@implementation TFGeometry (Protected)

+ (NSArray *)boundsForArray:(NSArray *)array
{
    if (array == nil || [array count] == 0) {
        return nil;
    }

    // fill with initial comparable values for xmin, ymin, xmax, ymax
    NSMutableArray *box = [NSMutableArray arrayWithObjects:@(DBL_MAX), @(DBL_MAX), @(DBL_MIN), @(DBL_MIN), nil];

    [self boundsForArray:array box:box];
    return box;
}

+ (void)boundsForArray:(NSArray *)array box:(NSMutableArray *)box
{
    for (NSUInteger i = 0; i < [array count]; i++) {
        if ([array[i] isKindOfClass:[NSArray class]]) {

            // we are iterating over an array of arrays: recurse!
            [self boundsForArray:(NSArray *)array[i] box:box];

        } else if ([array[i] isKindOfClass:[TFCoordinate class]]) {
            TFCoordinate *coord = array[i];
            box[0] = @(MIN(coord.x, [box[0] doubleValue]));
            box[1] = @(MIN(coord.y, [box[1] doubleValue]));
            box[2] = @(MAX(coord.x, [box[2] doubleValue]));
            box[3] = @(MAX(coord.y, [box[3] doubleValue]));
        } else if ([array[i] isKindOfClass:[NSNumber class]]) {

            // we only want to compare with X, Y from the coordinate array
            if (i > 1) {
                break;
            }

            double val = [array[i] doubleValue];

            // keep lesser X/Y at indexes 0 and 1
            box[i] = @(MIN(val, [box[i] doubleValue]));
            // keep greater X/Y at indexes 2 and 3
            box[i+2] = @(MAX(val, [box[i+2] doubleValue]));
        }
    }
}

+ (NSArray *)coordinatesToGeographic:(NSArray *)coords {
    NSMutableArray *ret = [NSMutableArray new];
    for (id elem in coords) {
        if ([elem isKindOfClass:[NSArray class]]) {
            [ret addObject:[self coordinatesToGeographic:elem]];
        } else if ([elem isKindOfClass:[TFCoordinate class]]) {
            TFCoordinate *c = elem;
            [ret addObject:[c toGeographic]];
        }
    }
    return ret;
}

+ (NSArray *)coordinatesToMercator:(NSArray *)coords {
    NSMutableArray *ret = [NSMutableArray new];
    for (id elem in coords) {
        if ([elem isKindOfClass:[NSArray class]]) {
            [ret addObject:[self coordinatesToMercator:elem]];
        } else if ([elem isKindOfClass:[TFCoordinate class]]) {
            TFCoordinate *c = elem;
            [ret addObject:[c toMercator]];
        }
    }
    return ret;
}

+ (NSArray *)envelopeForArray:(NSArray *)array
{
    NSArray *bounds = [self boundsForArray:array];
    if (bounds == nil) {
        return nil;
    }
    
    return @[bounds[0],
             bounds[1],
             @(ABS([bounds[0] doubleValue] - [bounds[2] doubleValue])),
             @(ABS([bounds[1] doubleValue] - [bounds[3] doubleValue]))];
}

- (instancetype)initSubclassWithCoordinates:(NSArray *)coordinates;
{
    if ( self = [super init] ) {
        
        self.coordinates = coordinates;
    }
    
    return self;
}

@end
