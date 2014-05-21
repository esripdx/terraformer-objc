//
//  TFGeometry+Protected.m
//  Terraformer
//
//  Created by Courtf on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry+Protected.h"

@implementation TFGeometry (Protected)

+ (NSArray *)boundsForArray:(NSArray *)array;
{
    if (array == nil || [array count] == 0) {
        return nil;
    }

    NSMutableArray *box = [NSMutableArray new];
    // fill with NSNulls as initial comparison values
    for (int i = 0; i < 4; i++) {
        [box addObject:[NSNull null]];
    }

    [self boundsForArray:array box:box];
    return box;
}

+ (void)boundsForArray:(NSArray *)array box:(NSMutableArray *)box;
{
    for (int i = 0; i < [array count]; i++) {
        if ([array[i] isKindOfClass:[NSArray class]]) {

            // we are iterating over an array of arrays: recurse!
            [self boundsForArray:(NSArray *)array[i] box:box];

        } else if ([array[i] isKindOfClass:[NSNumber class]]) {

            // we only want to compare with X, Y from the coordinate array
            if (i > 1) {
                break;
            }
            
            double val = [[array objectAtIndex:i] doubleValue];
            
            // if the lower X/Y is empty, or the current X/Y is less, keep it
            if ([box[i] isEqual:[NSNull null]] || (val < [[box objectAtIndex:i] doubleValue])) {
                box[i] = array[i];
            }
            
            // if the upper X/Y is empty, or the current X/Y is greater, keep it
            if ([box[i + 2] isEqual:[NSNull null]] || (val > [[box objectAtIndex:(i + 2)] doubleValue])) {
                box[i + 2] = array[i];
            }
        }
    }
}

@end
