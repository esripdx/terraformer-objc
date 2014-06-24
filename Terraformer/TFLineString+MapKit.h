//
//  TFLineString+MapKit.h
//  Mapaformer
//
//  Created by mbcharbonneau on 6/23/14.
//  Copyright (c) 2014 Esri PDX. All rights reserved.
//

#import "TFLineString.h"
@import MapKit;

@interface TFLineString (MapKit)

- (MKPolyline *)mapKitPolyline;
- (MKPolygon *)mapKitPolygon;

@end
