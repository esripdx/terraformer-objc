//
//  TFGeometry+Protected.h
//  Terraformer
//
//  Created by Courtf on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFGeometry (Protected)

/** Returns a bounding box for the provided coordinate array for GeoJSON types:
 'MultiPoint', 'LineString', 'MultiLineString', 'Polygon', and 'MultiPolygon'.
 */
+ (NSArray *)boundsForArray:(NSArray *)array;

@end
