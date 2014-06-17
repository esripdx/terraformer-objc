//
//  TFGeometryCollection
//  Terraformer
//
//  Created by ryana on 5/21/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFGeometry.h"
#import "TFGeometryCollection.h"

@implementation TFGeometryCollection {

}

+ (instancetype)geometryCollectionWithGeometries:(NSArray *)geometries {
    return [[self alloc] initWithGeometries:geometries];
}

- (instancetype)initWithGeometries:(NSArray *)geometries {
    self = [super initWithType:TFPrimitiveTypeGeometryCollection];
    if (self) {
        _geometries = [geometries copy];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.geometries[idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    NSParameterAssert([obj isKindOfClass:[TFGeometry class]]);

    NSMutableArray *g = [self.geometries mutableCopy];
    [g insertObject:obj atIndex:idx];
    self.geometries = g;
}

- (NSUInteger)count {
    return [self.geometries count];
}

- (void)addGeometry:(TFGeometry *)geometry {
    self.geometries = [self.geometries arrayByAddingObject:geometry];
}

- (void)removeGeometry:(TFGeometry *)geometry {
    NSMutableArray *geoms = [self.geometries mutableCopy];
    [geoms removeObject:geometry];
    self.geometries = geoms;
}

- (void)insertGeometry:(TFGeometry *)geometry atIndex:(NSUInteger)idx {
    NSMutableArray *g = [self.geometries mutableCopy];
    [g insertObject:geometry atIndex:idx];
    self.geometries = g;
}

@end