//
//  TFGeometry.m
//  Terraformer
//
//  Created by Ryan Arana on 5/20/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"
#import "TFGeometry+Protected.h"

@implementation TFGeometry

- (instancetype)initWithType:(NSString *)type coordinates:(NSArray *)coordinates {
    if (self = [super init]) {
        _type = type;
        _coordinates = coordinates;
    }
    return self;
}

#pragma mark - TFPrimitive

- (NSDictionary *)encodeJSON {
    return @{TFTypeKey: self.type,
             TFCoordinatesKey: self.coordinates};
}

+ (id <TFPrimitive>)decodeJSON:(NSDictionary *)json {
    return [[TFGeometry alloc] initWithType:json[TFTypeKey] coordinates:json[TFCoordinatesKey]];
}

- (NSArray *)bbox {
    return [[self class] boundsForArray:self.coordinates];
}

- (NSArray *)envelope {
    NSArray *envelope;
    
    // todo
    
    return envelope;
}

- (TFPolygon *)convexHull {
    TFPolygon *hull;
    
    // todo
    
    return hull;
}

- (BOOL)contains:(TFGeometry *)geometry {
    
    // todo
    
    return NO;
}

- (BOOL)within:(TFGeometry *)geometry {
    
    // todo
    
    return NO;
}

- (BOOL)intersects:(TFGeometry *)geometry {
    
    // todo
    
    return NO;
}

@end
