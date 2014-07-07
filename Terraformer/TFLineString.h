//
//  TFLineString.h
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFLineString : TFGeometry

@property (copy, nonatomic) NSArray *points;

/**
* Create a TFLineString object using the given array of arrays of coordinates.
*
* @parameter coords: An array of arrays of coordinates as NSNumbers.
*/
+ (instancetype)lineStringWithCoords:(NSArray *)coords;

/**
* Initialize this TFLineString object using the given array of arrays of coordinates.
*
* @parameter coords: An array of arrays of coordinates as NSNumbers.
*/
- (instancetype)initWithCoords:(NSArray *)coords;

/**
* Create a TFLineString object using the given array of TFPoints.
*
* @parameter points: An array of TFPoints.
*/
+ (instancetype)lineStringWithPoints:(NSArray *)points;

/**
* Initialize this TFLineString object using the given array of TFPoints.
*
* @parameter points: An array of TFPoints.
*/
- (instancetype)initWithPoints:(NSArray *)points;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

/**
* Is this LineString a linear ring?
*
* @returns YES if the first and last TFPoints in the points array are equal.
*/
- (BOOL)isLinearRing;

/**
* Close this TFLineString by adding a copy of the first element in the points array to the end of the points array. This
* method calls `isLinearRing` first and is a no-op if that method call returns YES.
*/
- (void)closeRing;
@end
