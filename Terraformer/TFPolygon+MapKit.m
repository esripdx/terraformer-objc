//
//  TFPolygon+MapKit.m
//  Terraformer
//
//  Created by mbcharbonneau on 6/24/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFPolygon+MapKit.h"
#import "TFLineString+MapKit.h"
#import "TFPoint+MapKit.h"

@implementation TFPolygon (MapKit)

- (MKPolygon *)mapKitPolygon;
{
    NSInteger idx, count = [self numberOfHoles];
    NSMutableArray *holePolygons = [[NSMutableArray alloc] initWithCapacity:count];
    
    for ( idx = 1; idx <= count; idx++ ) {
        
        TFLineString *lineString = self.lineStrings[idx];
        [holePolygons addObject:[lineString mapKitPolygon]];
    }
    
    TFLineString *linestring = [self.lineStrings firstObject];
    count = [linestring.points count];
    CLLocationCoordinate2D coordinates[count];
    
    for ( idx = 0; idx < count; idx++ ) {
        
        coordinates[idx] = [linestring.points[idx] coreLocationCoordinateValue];
    }
    
    return [MKPolygon polygonWithCoordinates:coordinates count:count interiorPolygons:holePolygons];
}

@end
