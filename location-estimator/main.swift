//
//  main.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation;

let args = try! parseArgs();
let locations = loadLocations(path: args.locationsPath);

let found = findNearestLocation(
  fromLocations: locations,
  atIntervalSince1970: args.time.timeIntervalSince1970
);
