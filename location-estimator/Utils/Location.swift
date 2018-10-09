//
//  Location.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation

struct Location: Codable {
  let latitude: Double;
  let longitude: Double;
  let createdAt: TimeInterval;
}
