//
//  TFCoordinate
//  Terraformer
//
//  Created by ryana on 5/21/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFCoordinate : NSObject

+ (instancetype)coordinateWithX:(double)x y:(double)y;
- (instancetype)initWithX:(double)x y:(double)y;

@property (readonly) double x;
@property (readonly) double y;

- (NSArray *)encodeJSON;
+ (instancetype)decodeJSON:(NSArray *)json;
@end