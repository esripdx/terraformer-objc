//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPrimitive.h"
#import "TFConstants.h"

@class TFGeometry;

@interface TFFeature : NSObject

@property (readonly) TFPrimitiveType type;
@property (readonly) NSString *identifier;
@property (readonly) id <TFPrimitive> geometry;
@property (nonatomic, copy) NSDictionary *properties;

- (instancetype)initWithGeometry:(id <TFPrimitive>)geometry;

- (instancetype)initWithGeometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties;

- (instancetype)initWithID:(NSString *)identifier geometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties;

+ (TFFeature *)featureWithGeometry:(id <TFPrimitive>)geometry;

+ (TFFeature *)featureWithGeometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties;

+ (TFFeature *)featureWithID:(NSString *)identifier geometry:(id <TFPrimitive>)geometry properties:(NSDictionary *)properties;
@end