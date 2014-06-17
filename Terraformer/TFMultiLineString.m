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

- (BOOL)isEqual:(id)object {
    if ( object == self ) {
        return YES;
    }

    if ( object == nil || ![object isKindOfClass:[self class]] ) {
        return NO;
    }

    TFMultiLineString *other = object;
    return [self.lineStrings isEqualToArray:other.lineStrings];
}

- (NSUInteger)hash {
    return [self.lineStrings hash];
}
@end
