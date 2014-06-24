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
    NSInteger index, count = [self numberOfHoles];
    NSMutableArray *holePolygons = [[NSMutableArray alloc] initWithCapacity:count];
    
    for ( index = 1; index <= count; index++ ) {
        
        TFLineString *lineString = self.lineStrings[index];
        [holePolygons addObject:[lineString mapKitPolygon]];
    }
    
    TFLineString *linestring = [self.lineStrings firstObject];
    count = [linestring.points count];
    CLLocationCoordinate2D coordinates[count];
    
    for ( index = 0; index < count; index++ ) {
        
        coordinates[index] = [linestring.points[index] coreLocationCoordinateValue];
    }
    
    return [MKPolygon polygonWithCoordinates:coordinates count:count interiorPolygons:holePolygons];
}

@end
