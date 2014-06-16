//
//  TFPrimitive
//  Terraformer
//
//  Created by ryana on 6/16/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFTerraformer.h"

/***
* Base class for all primitive types (geometries, features, and collections).
*/
@interface TFPrimitive : NSObject <NSObject>

@property (assign, nonatomic, readonly) TFPrimitiveType type;

- (instancetype)initWithType:(TFPrimitiveType)type;
@end