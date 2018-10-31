//
//  main.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation;

let args = try! parseArgs();
print(args);
initFormatter();

let locations = loadLocations(path: args.locationsPath);
let items = try! FileManager.default.contentsOfDirectory(atPath: args.photoPath);
for item in items {
  guard item.hasSuffix(".jpg") || item.hasSuffix(".JPG") else {
    continue;
  }
  let filePath = args.photoPath.appendingPathComponent(item);
  let photo = Photo(path: filePath);
  print(item)
  let found = findNearestLocation(
    fromLocations: locations,
    atIntervalSince1970: photo.dateTimeOriginalFrom1970 - TimeInterval(args.zone.secondsFromGMT())
  );

  runExifTool(
    latitude: found.latitude,
    longitude: found.longitude,
    filePath: filePath
  );
}
