//
//  Arguments.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation

struct Arguments {
  let locationsPath: String;
  let time: Date;
}

private func toDate(from: TimeInterval) -> Date {
  return Date(timeIntervalSince1970: from);
}

func parseArgs() throws -> Arguments {
  var counter = 1;
  var args: (locationPath: String?, time: Date?) = (locationPath: nil, time: nil);
  while counter < CommandLine.argc {
    print(CommandLine.arguments[counter])
    switch CommandLine.arguments[counter] {
    case "--src":
      fallthrough;
    case "-s":
      counter += 1;
      args.locationPath = CommandLine.arguments[counter];
    case "--time":
      fallthrough;
    case "-t":
      counter += 1;
      args.time = toDate(from: Double(CommandLine.arguments[counter])!);
    default:
      throw NSError(domain: "Unknown command arguments.", code: -1, userInfo: nil);
    }
    counter += 1;
  }

  guard let locationPath = args.locationPath, let time = args.time else {
    throw NSError(domain: "Argument not found", code: -1, userInfo: nil);
  }

  return Arguments(locationsPath: locationPath, time: time);
}
