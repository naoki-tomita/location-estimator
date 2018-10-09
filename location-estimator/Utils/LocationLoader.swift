//
//  LocationLoader.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation

func loadLocations(path: String) -> [Location] {
  let jsonString = try! String(contentsOfFile: path);
  let data = jsonString.data(using: .utf8);
  return try! JSONDecoder().decode([Location].self, from: data!);
}
