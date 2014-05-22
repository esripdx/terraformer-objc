//
//  TFGeometry+Protected.h
//  Terraformer
//
//  Created by Courtf on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFGeometry (Protected)

/** Convert a TFGeometryType to / from the equivalent geoJSON type string.
 */
+ (NSString *)geoJSONStringForType:(TFGeometryType)type;
+ (TFGeometryType)geometryTypeForString:(NSString *)string;

/** Returns a bounding box for the provided coordinate array for GeoJSON types:
 'MultiPoint', 'LineString', 'MultiLineString', 'Polygon', and 'MultiPolygon'.
 */
+ (NSArray *)boundsForArray:(NSArray *)array;

/** Returns an envelope for the provided coordinate array for GeoJSON types:
 'MultiPoint', 'LineString', 'MultiLineString', 'Polygon', and 'MultiPolygon'.
 */
+ (NSArray *)envelopeForArray:(NSArray *)array;

/** Designated initializer for TFGeometry subclasses.
 */
- (instancetype)initSubclassOfType:(TFGeometryType)type coordinates:(NSArray *)coordinates;

@end
