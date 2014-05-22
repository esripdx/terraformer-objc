//
//  TFGeometry.h
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPrimitive.h"

typedef NS_ENUM( NSInteger, TFGeometryType )
{
    TFGeometryTypePoint,
    TFGeometryTypeMultiPoint,
    TFGeometryTypeLineString,
    TFGeometryTypeMultiLineString,
    TFGeometryTypePolygon,
    TFGeometryTypeMultiPolygon
};

@interface TFGeometry : NSObject <TFPrimitive>

+ (instancetype)geometryWithType:(TFGeometryType)type coordinates:(NSArray *)coordinates;

@property (nonatomic, assign) TFGeometryType type;
@property (nonatomic, strong) NSArray *coordinates;

@end
