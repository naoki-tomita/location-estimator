//
//  PhotoLoader.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/24.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation;
import CoreImage;

let formatter = DateFormatter();

func initFormatter() {
  formatter.locale = Locale(identifier: "en_US_POSIX");
  formatter.timeZone = TimeZone(secondsFromGMT: 0);
  formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"; // HH means 24 hour format.
}

class Photo {
  var dateTimeOriginalFrom1970: TimeInterval {
    get {
      let properties = image.properties;
      let exif = properties[kCGImagePropertyExifDictionary as String] as! [String: Any];
      let dateTimeOriginal: String = exif[kCGImagePropertyExifDateTimeOriginal as String] as! String;
      return formatter.date(from: dateTimeOriginal)!.timeIntervalSince1970;
    }
  };
  var gps: [String: Any];
  var latitude: Double {
    get {
      return gps[kCGImagePropertyGPSLatitude as String] as! Double? ?? 0.0;
    }
    set(x) {
      if x < 0 {
        gps[kCGImagePropertyGPSLatitudeRef as String] = "S";
        gps[kCGImagePropertyGPSLatitude as String] = -x;
      } else {
        gps[kCGImagePropertyGPSLatitudeRef as String] = "N";
        gps[kCGImagePropertyGPSLatitude as String] = x;
      }
    }
  }
  var longitude: Double {
    get {
      return gps[kCGImagePropertyGPSLongitude as String] as! Double? ?? 0.0;
    }
    set(x) {
      if x < 0 {
        gps[kCGImagePropertyGPSLongitudeRef as String] = "W";
        gps[kCGImagePropertyGPSLongitude as String] = -x;
      } else {
        gps[kCGImagePropertyGPSLongitudeRef as String] = "E";
        gps[kCGImagePropertyGPSLongitude as String] = x;
      }
    }
  }
  let image: CIImage;
  let path: String;

  init(path: String) {
    self.path = path;
    let url = URL(fileURLWithPath: path);
    image = CIImage(contentsOf: url)!;
    gps = image.properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] ?? [:];
  }

  func save() {
    if let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: path + "_") as CFURL, kUTTypeJPEG, 1, nil) {
      let ctx = CIContext();
      var properties = image.properties;
      properties[kCGImagePropertyGPSDictionary as String] = gps;
      CGImageDestinationAddImage(dest, ctx.createCGImage(image, from: image.extent)!, properties as CFDictionary);
      CGImageDestinationFinalize(dest);
    } else {
      print("Failed to save file.");
    }
  }
}
