//
//  TFPoint+MapKit.m
//  Mapaformer
//
//  Created by mbcharbonneau on 6/23/14.
//  Copyright (c) 2014 Esri PDX. All rights reserved.
//

#import "TFPoint+MapKit.h"

@implementation TFPoint (MapKit)

- (CLLocationCoordinate2D)coreLocationCoordinateValue;
{
    return CLLocationCoordinate2DMake( self.latitude, self.longitude );
}

@end
