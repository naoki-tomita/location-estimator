//
//  LocationEstimator.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation

func findNearestLocation(
  fromLocations locations: [Location],
  atIntervalSince1970 interval: TimeInterval
) -> Location {
  var found: Location = locations[0];
  var curAbs: Int = Int(Date().timeIntervalSince1970);
  print(interval);

  for location in locations {
    let tmpAbs = abs(Int(location.createdAt) - Int(interval));
    if tmpAbs < curAbs {
      curAbs = tmpAbs;
      found = location;
    }
  }
  print(found, abs(Int(found.createdAt) - Int(interval)));
  return found;
}
