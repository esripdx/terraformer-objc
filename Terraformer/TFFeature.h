//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPrimitive.h"

@class TFGeometry;


@interface TFFeature : NSObject

@property (readonly) NSString *type;
@property (readonly) NSString *identifier;
@property (readonly) id <TFPrimitive> geometry;
@property (readonly) NSDictionary *properties;

@end