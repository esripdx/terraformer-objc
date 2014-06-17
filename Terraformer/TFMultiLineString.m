//
//  TFMultiLineString.m
//  Terraformer
//
//  Created by Jen on 5/27/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFMultiLineString.h"
#import "TFLineString.h"

@implementation TFMultiLineString

#pragma mark TFMultiLineString

+ (instancetype)multiLineStringWithLineStrings:(NSArray *)lineStrings {
    return [[self alloc] initWithLineStrings:lineStrings];
}

- (instancetype)initWithLineStrings:(NSArray *)lineStrings {
    self = [super initWithType:TFPrimitiveTypeMultiLineString];
    if (self) {
        _lineStrings = [lineStrings copy];
    }

    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.lineStrings[idx];
}

- (NSUInteger)count {
    return [self.lineStrings count];
}
@end
