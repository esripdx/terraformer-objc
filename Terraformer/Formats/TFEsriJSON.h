//
//  TFEsriJSON
//  Terraformer
//
//  Created by ryana on 6/19/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "TFTerraformer.h"

@interface TFEsriJSON : NSObject<TFEncoder, TFDecoder>

/**
* See http://resources.arcgis.com/en/help/rest/apiref/geometry.html for format of this object, basically:
*
  {
    "wkid": <wkid>,
    "latestWkid": <wkid>, // optional
    "vcsWkid": <wkid>, // optional
    "latestVcsWkid": <wkid> // optional
  }

  or

  {
    "wkt": <wkt>
  }
*/
@property (copy, nonatomic, readonly) NSDictionary *spatialReference;

- (instancetype)initWithSpatialReference:(NSDictionary *)spatialReference;

+ (instancetype)esriJSONWithSpatialReference:(NSDictionary *)spatialReference;

@end