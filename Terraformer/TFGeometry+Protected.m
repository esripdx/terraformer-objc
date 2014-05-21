//
//  TFGeometry+Protected.m
//  Terraformer
//
//  Created by Courtf on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry+Protected.h"

@implementation TFGeometry (Protected)

+ (NSArray *)boundsForArray:(NSArray *)array
{
    if (array == nil || [array count] == 0) {
        return nil;
    }

    // fill with initial comparable values for xmin, ymin, xmax, ymax
    NSMutableArray *box = [NSMutableArray arrayWithArray:@[@(DBL_MAX), @(DBL_MAX), @(DBL_MIN), @(DBL_MIN)]];

    [self boundsForArray:array box:box];
    return box;
}

+ (void)boundsForArray:(NSArray *)array box:(NSMutableArray *)box
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
            
            double val = [array[i] doubleValue];
            
            // keep lesser X/Y at indexes 0 and 1
            box[i] = @(MIN(val, [box[i] doubleValue]));
            // keep greater X/Y at indexes 2 and 3
            box[i+2] = @(MAX(val, [box[i+2] doubleValue]));
        }
    }
}

@end
