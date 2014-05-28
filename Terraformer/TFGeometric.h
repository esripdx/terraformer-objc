//
//  TFGeometric.h
//  Terraformer
//
//  Created by kenichi nakamura on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPoint.h"

@interface TFGeometric : NSObject

/**
 determine if the two lines given by the coordinate arrays intersect each other.
 
 @param a two-element array of TFCoordinate objects
 @param b two-element array of TFCoordinate objects
 
 @return true if lines interesct, false otherwise.
 */
+ (BOOL)edge:(NSArray *)a intersectsEdge:(NSArray *)b;

/**
 determine if multi-dimensional arrays of lines intersect each other.
 
 @param a multi-dimensional array that eventually contains TFCoordinate objects
 @param b multi-dimensional array that eventually contains TFCoordinate objects
 
 @return true if any line in any part of a intersects with any line in any part of b.
 */
+ (BOOL)arrays:(NSArray *)a intersectArrays:(NSArray *)b;


/**
 determine if a point is on a line.
 
 @param line two-element array of TFCoordinate objects
 @param point TFPoint object
 
 @return true if point is on line, false otherwise.
 */
+ (BOOL)line:(NSArray *)line containsPoint:(TFPoint *)point;

/**
 determine if a coordinate is on a line.
 
 @param line two-element array of TFCoordinate objects
 @param coordinate TFCoordinate object
 
 @return true if point is on line, false otherwise.
 */
+ (BOOL)line:(NSArray *)line containsCoordinate:(TFCoordinate *)coordinate;

@end
