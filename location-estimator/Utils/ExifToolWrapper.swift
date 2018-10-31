//
//  ExifToolWrapper.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/31.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation

struct ExifToolOptions {

}

func runExifTool(latitude lat: Double, longitude long: Double, filePath: String) {
  var latitude: Double = lat;
  var latitudeRef: String = "N"
  var longitude: Double = long;
  var longitudeRef: String = "E";
  if lat < 0 {
    latitude = -lat;
    latitudeRef = "S";
  }
  if long < 0 {
    longitude = -long;
    longitudeRef = "W"
  }
  let task = Process.launchedProcess(
    launchPath: "/bin/sh",
    arguments: ["-c", "\"exiftool -GPSLatitude=\(latitude) -GPSLatitudeRef=\(latitudeRef) -GPSLongitude=\(longitude) -GPSLongitudeRef=\(longitudeRef) \(filePath)\""]);
  task.waitUntilExit();
}
