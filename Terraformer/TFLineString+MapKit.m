//
//  TFLineString+MapKit.m
//  Mapaformer
//
//  Created by mbcharbonneau on 6/23/14.
//  Copyright (c) 2014 Esri PDX. All rights reserved.
//

#import "TFLineString+MapKit.h"
#import "TFPoint+MapKit.h"

@implementation TFLineString (MapKit)

- (MKPolyline *)mapKitPolyline;
{
    NSInteger idx, count = [self.points count];
    CLLocationCoordinate2D coordinates[count];
    
    for ( idx = 0; idx < count; idx++ ) {
        coordinates[idx] = [self.points[idx] coreLocationCoordinateValue];
    }
    
    return [MKPolyline polylineWithCoordinates:coordinates count:count];
}

- (MKPolygon *)mapKitPolygon;
{
    if ( !self.isLinearRing )
        return nil;
    
    NSInteger idx, count = [self.points count];
    CLLocationCoordinate2D coordinates[count];
    
    for ( idx = 0; idx < count; idx++ ) {
        coordinates[idx] = [self.points[idx] coreLocationCoordinateValue];
    }
    
    return [MKPolygon polygonWithCoordinates:coordinates count:count];
}

@end
