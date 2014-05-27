//
//  TFMultiPolygon.m
//  Terraformer
//
//  Created by mbcharbonneau on 5/22/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFMultiPolygon.h"
#import "TFGeometry+Protected.h"

@implementation TFMultiPolygon

#pragma mark TFMultiPolygon

- (instancetype)initWithPolygonCoordinateArrays:(NSArray *)polygons;
{
    // See TFPolygon.m for a description of the polygon data structure.
    
    return (TFMultiPolygon *) [super initSubclassWithCoordinates:polygons];

}

#pragma mark TFPrimitive

- (TFPrimitiveType)type;
{
    return TFPrimitiveTypeMultiPolygon;
}

@end
