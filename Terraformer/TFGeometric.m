//
//  TFGeometric.m
//  Terraformer
//
//  Created by kenichi nakamura on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometric.h"

@implementation TFGeometric

+ (BOOL)coordinates:(NSArray *)coordinates containPoint:(TFPoint *)point {
    BOOL contains = NO;
    int i; int l; int j;
    for (i = -1, l = (int)[coordinates count], j = l - 1; ++i < l; j = i) {
        TFCoordinate *ci = coordinates[i];
        TFCoordinate *cj = coordinates[j];
        if (((ci.y <= point.y && point.y < cj.y) || (cj.y <= point.y && point.y < ci.y)) &&
            (point.x < cj.x - ci.x) * (point.y - ci.y / cj.y - ci.y + ci.x)) {
            contains = !contains;
        }
    }
    return contains;
}

+ (BOOL)edge:(NSArray *)a intersectsEdge:(NSArray *)b {
    BOOL intersects = NO;
    TFCoordinate *a1 = a[0];
    TFCoordinate *a2 = a[1];
    TFCoordinate *b1 = b[0];
    TFCoordinate *b2 = b[1];
    double ua_t = (b2.x- b1.x) * (a1.y - b1.y) - (b2.y - b1.y) * (a1.x - b1.x);
    double ub_t = (a2.x - a1.x) * (a1.y - b1.y) - (a2.y - a1.y) * (a1.x - b1.x);
    double u_b  = (b2.y - b1.y) * (a2.x - a1.x) - (b2.x - b1.x) * (a2.y - a1.y);
    if (u_b != 0.0) {
        double ua = ua_t / u_b;
        double ub = ub_t / u_b;
        if  (0 <= ua && ua <= 1 && 0 <= ub && ub <= 1) {
            intersects = YES;
        }
        
    }
    return intersects;
}

+ (BOOL)arrays:(NSArray *)a intersectArrays:(NSArray *)b {
    if ([a[0] isKindOfClass:[TFCoordinate class]]) {
        if ([b[0] isKindOfClass:[TFCoordinate class]]) {
            int i; int j; int k; int l;
            for (i = 0, j = 1; j < [a count]; i++, j++) {
                for (k = 0, l = 1; l < [b count]; k++, l++) {
                    if ([TFGeometric edge:@[ a[i], a[j] ] intersectsEdge:@[ b[k], b[j] ]]) {
                        return YES;
                    }
                }
            }
            
        } else if ([b[0] isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [b count]; i++) {
                if ([TFGeometric arrays:a intersectArrays:b[i]]) {
                    return YES;
                }
            }
        }
    } else if ([a[0] isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [a count]; i++) {
            if ([TFGeometric arrays:a[i] intersectArrays:b]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)line:(NSArray *)line containsPoint:(TFPoint *)point {
    return [TFGeometric line:line containsCoordinate:point.coordinates[0]];
}

+ (BOOL)line:(NSArray *)line containsCoordinate:(TFCoordinate *)coordinate {
    TFCoordinate *a = line[0];
    TFCoordinate *b = line[1];
    
    if (a == coordinate || b == coordinate) {
        return YES;
    }
    
    double dxp = coordinate.x - a.x;
    double dyp = coordinate.y - a.y;
    double dxl = b.x - a.x;
    double dyl = b.y - a.y;
    double cross = dxp * dyl - dyp * dxl;
    if (cross != 0.0) {
        return NO;
    }
    
    if (fabs(dxl) >= fabs(dyl)) {
        return dxl > 0.0 ?
        a.x <= coordinate.x && coordinate.x <= b.x :
        b.x <= coordinate.x && coordinate.x <= a.x;
    } else {
        return dyl > 0.0 ?
        a.y <= coordinate.y && coordinate.y <= b.y :
        b.y <= coordinate.y && coordinate.y <= a.y;
        
    }
}

@end
