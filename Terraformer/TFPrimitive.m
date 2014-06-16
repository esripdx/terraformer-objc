//
//  TFPrimitive
//  Terraformer
//
//  Created by ryana on 6/16/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFPrimitive.h"


@implementation TFPrimitive {

}
- (instancetype)initWithType:(TFPrimitiveType)type {
    self = [super init];
    if (self) {
        _type = type;
    }

    return self;
}

@end