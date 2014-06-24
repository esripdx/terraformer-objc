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
    NSInteger index, count = [self.points count];
    CLLocationCoordinate2D coordinates[count];
    
    for ( index = 0; index < count; index++ ) {
        coordinates[index] = [self.points[index] coreLocationCoordinateValue];
    }
    
    return [MKPolyline polylineWithCoordinates:coordinates count:count];
}

- (MKPolygon *)mapKitPolygon;
{
    if ( !self.isLinearRing )
        return nil;
    
    NSInteger index, count = [self.points count];
    CLLocationCoordinate2D coordinates[count];
    
    for ( index = 0; index < count; index++ ) {
        coordinates[index] = [self.points[index] coreLocationCoordinateValue];
    }
    
    return [MKPolygon polygonWithCoordinates:coordinates count:count];
}

@end
