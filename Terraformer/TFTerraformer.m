//
//  TFTerraformer
//  Terraformer
//
//  Created by ryana on 6/16/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFTerraformer.h"
#import "TFPrimitive.h"

@implementation TFTerraformer {

}

- (instancetype)initWithEncoder:(id <TFEncoder>)encoder decoder:(id <TFDecoder>)decoder {
    self = [super init];
    if (self) {
        _encoder = encoder;
        _decoder = decoder;
    }

    return self;
}

- (NSData *)convert:(NSData *)input error:(NSError **)error {
    TFPrimitive *primitive = [self.decoder decode:input error:error];
    if (primitive == nil) {
        return nil;
    }
    return [self.encoder encodePrimitive:primitive error:error];
}

- (TFPrimitive *)decode:(NSData *)input error:(NSError **)error {
    return [self.decoder decode:input error:error];
}

@end