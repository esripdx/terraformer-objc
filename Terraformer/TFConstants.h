//
//  TFConstants.h
//  Terraformer
//
//  Created by kenichi nakamura on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#ifndef Terraformer_TFConstants_h
#define Terraformer_TFConstants_h

typedef NS_ENUM( NSInteger, TFPrimitiveType )
{
    TFPrimitiveTypePoint,
    TFPrimitiveTypeMultiPoint,
    TFPrimitiveTypeLineString,
    TFPrimitiveTypeMultiLineString,
    TFPrimitiveTypePolygon,
    TFPrimitiveTypeMultiPolygon,
    TFPrimitiveTypeGeometryCollection
};

static NSString *const TFTypeKey = @"type";
static NSString *const TFCoordinatesKey = @"coordinates";
static NSString *const TFGeometryKey = @"geometry";
static NSString *const TFGeometriesKey = @"geometries";
static NSString *const TFIdKey = @"id";
static NSString *const TFPropertiesKey = @"properties";

#endif
