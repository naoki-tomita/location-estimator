//
//  main.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation;

let args = parseArgs();
initFormatter(timeZone: args.zone);

let locations = loadLocations(path: args.locationsPath);
let photo = Photo(path: args.photoPath);

let found = findNearestLocation(
  fromLocations: locations,
  atIntervalSince1970: photo.dateTimeOriginalFrom1970
);

photo.latitude = found.latitude;
photo.longitude = found.longitude;

photo.save();
