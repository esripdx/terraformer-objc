//
//  TFGeometry
//  Terraformer
//
//  Created by ryana on 6/17/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFGeometry.h"
#import "TFPoint.h"
#import "TFLineString.h"
#import "TFPolygon.h"
#import "TFMultiPoint.h"
#import "TFMultiLineString.h"
#import "TFMultiPolygon.h"
#import "TFGeometryCollection.h"


@implementation TFGeometry {

}

- (NSArray *)coordinateArray {
    switch (self.type) {
        case TFPrimitiveTypePoint:
            return ((TFPoint *) self).coordinates;
        case TFPrimitiveTypeLineString:
            return [TFGeometry coordinateArrayFromGeometryArray:((TFLineString *) self).points];
        case TFPrimitiveTypePolygon:
            return [TFGeometry coordinateArrayFromGeometryArray:((TFPolygon *) self).lineStrings];
        case TFPrimitiveTypeMultiPoint:
            return [TFGeometry coordinateArrayFromGeometryArray:((TFMultiPoint *) self).points];
        case TFPrimitiveTypeMultiLineString:
            return [TFGeometry coordinateArrayFromGeometryArray:((TFMultiLineString *) self).lineStrings];
        case TFPrimitiveTypeMultiPolygon:
            return [TFGeometry coordinateArrayFromGeometryArray:((TFMultiPolygon *) self).polygons];
        default:
            NSAssert(NO, @"Invalid TFPrimitiveType for TFGeometry (%@)", self);
            return nil;
    }
}

+ (NSArray *)coordinateArrayFromGeometryArray:(NSArray *)array {
    NSMutableArray *coords = [NSMutableArray new];
    for (TFGeometry *geometry in array) {
        [coords addObjectsFromArray:[geometry coordinateArray]];
    }
    return [coords copy];
}

@end