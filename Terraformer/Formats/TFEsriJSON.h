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
@property (copy, nonatomic) NSDictionary *spatialReference;

/**
* Convenience accessor/setter for the WKID key in the spatialReference dictionary.
*/
@property (copy, nonatomic) NSNumber *wkid;

/**
* Convenience accessor/setter for the WKT key in the spatialReference dictionary.
*/
@property (copy, nonatomic) NSString *wkt;

/**
* Set a key to use for `TFFeature`'s identifier property in the `attributes` object.
*/
@property (copy, nonatomic) NSString *featureIdentifierKey;

@end