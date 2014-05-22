//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFFeature;

@interface TFFeatureCollection : NSObject

- (instancetype)initWithFeatures:(NSArray *)features;
+ (instancetype) decodeJSON:(NSDictionary *)json;

- (void) addFeature:(TFFeature *)feature;
- (void) removeFeature:(TFFeature *)feature;
- (void) removeFeatureAtIndex:(NSUInteger)index;
- (NSDictionary *) encodeJSON;

@property (nonatomic, copy) NSArray *features;
@property (readonly) NSString *type;

@end