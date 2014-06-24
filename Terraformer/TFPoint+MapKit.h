//
//  TFPoint+MapKit.h
//  Mapaformer
//
//  Created by mbcharbonneau on 6/23/14.
//  Copyright (c) 2014 Esri PDX. All rights reserved.
//

#import "TFPoint.h"
@import MapKit;

@interface TFPoint (MapKit)

- (CLLocationCoordinate2D)coreLocationCoordinateValue;

@end
