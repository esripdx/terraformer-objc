//
//  TFGeometryCollection
//  Terraformer
//
//  Created by ryana on 5/21/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFGeometryCollection.h"
#import "TFGeometry.h"
#import "TFGeometry+Protected.h"
#import "TFPolygon.h"

@implementation TFGeometryCollection {

}

- (instancetype)initWithGeometries:(NSArray *)geometries {
    if (self = [super init]) {
        _geometries = geometries;
    }
    return self;
}

- (void)addGeometry:(TFGeometry *)geometry {
    self.geometries = [self.geometries arrayByAddingObject:geometry];
}

- (NSArray *)geometriesWhichContain:(TFGeometry *)geometry {
    NSMutableArray *found = [NSMutableArray new];
    for (TFGeometry *geo in self.geometries) {
        if ([geo contains:geometry]) {
            [found addObject:geo];
        }
    }
    return [NSArray arrayWithArray:found];
}

- (NSArray *)geometriesWhichIntersect:(TFGeometry *)geometry {
    NSMutableArray *found = [NSMutableArray new];
    for (TFGeometry *geo in self.geometries) {
        if ([geo intersects:geometry]) {
            [found addObject:geo];
        }
    }
    return [NSArray arrayWithArray:found];
}

- (NSArray *)geometriesWithin:(TFGeometry *)geometry {
    NSMutableArray *found = [NSMutableArray new];
    for (TFGeometry *geo in self.geometries) {
        if ([geo within:geometry]) {
            [found addObject:geo];
        }
    }
    return [NSArray arrayWithArray:found];
}

#pragma mark TFPrimitive

- (TFPrimitiveType)type {
    return TFPrimitiveTypeGeometryCollection;
}

- (NSDictionary *)encodeJSON {
    return @{
             TFTypeKey: [[self class] geoJSONStringForType:self.type],
             TFGeometriesKey: self.geometries
    };
}

+ (id <TFPrimitive>)decodeJSON:(NSDictionary *)json {
    NSArray *geoms = json[TFGeometriesKey];
    if ([geoms isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return [[self alloc] initWithGeometries:geoms];
}

- (NSArray *)bbox {
    NSMutableArray *coords = [NSMutableArray new];
    for (TFGeometry *geom in self.geometries) {
        [coords addObjectsFromArray:geom.coordinates];
    }
    return [TFGeometry boundsForArray:coords];
}

- (NSArray *)envelope {
    NSArray *bbox = [self bbox];
    // Envelope is the xmin, ymin coord with a distance to the corresponding max coord.
    return @[
            bbox[0],
            bbox[1],
            @(ABS([bbox[0] doubleValue] - [bbox[2] doubleValue])),
            @(ABS([bbox[1] doubleValue] - [bbox[3] doubleValue]))
    ];
}

- (TFPolygon *)convexHull {
    // TODO
    return nil;
}

- (BOOL)contains:(TFGeometry *)geometry {
    // Check if the passed in geometry is actually one of the geometries in the collection and save ourselves some cycles.
    if ([self.geometries containsObject:geometry]) {
        return YES;
    }

    for (TFGeometry *geom in self.geometries) {
        if ([geom contains:geometry]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)within:(TFGeometry *)geometry {
    // Check if the passed in geometry is actually one of the geometries in the collection and save ourselves some cycles.
    if ([self.geometries containsObject:geometry]) {
        return YES;
    }

    for (TFGeometry *geom in self.geometries) {
        if ([geom within:geometry]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)intersects:(TFGeometry *)geometry {
    // Check if the passed in geometry is actually one of the geometries in the collection and save ourselves some cycles.
    if ([self.geometries containsObject:geometry]) {
        return YES;
    }

    for (TFGeometry *geom in self.geometries) {
        if ([geom intersects:geometry]) {
            return YES;
        }
    }
    return NO;
}

@end