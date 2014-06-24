//
//  TFPolygon+MapKit.h
//  Terraformer
//
//  Created by mbcharbonneau on 6/24/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPolygon.h"
@import MapKit;

@interface TFPolygon (MapKit)

- (MKPolygon *)mapKitPolygon;

@end
