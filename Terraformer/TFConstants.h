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
    TFPrimitiveTypeUnknown,
    TFPrimitiveTypePoint,
    TFPrimitiveTypeMultiPoint,
    TFPrimitiveTypeLineString,
    TFPrimitiveTypeMultiLineString,
    TFPrimitiveTypePolygon,
    TFPrimitiveTypeMultiPolygon,
    TFPrimitiveTypeGeometryCollection,
    TFPrimitiveTypeFeature,
    TFPrimitiveTypeFeatureCollection
};

#endif
