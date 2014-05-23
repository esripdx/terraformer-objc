//
//  TFMultiPolygon.h
//  Terraformer
//
//  Created by mbcharbonneau on 5/22/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFMultiPolygon : TFGeometry

- (instancetype)initWithPolygonCoordinateArrays:(NSArray *)polygons;

@end
