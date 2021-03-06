//
//  Arguments.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/09.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation

private func toDate(from: TimeInterval) -> Date {
  return Date(timeIntervalSince1970: from);
}

func parseArgs() throws -> (locationsPath: String, photoPath: String, zone: TimeZone) {
  let parser = ArgumentParser(args: [
    ArgumentType(key: "src", shortKey: "s"),
    ArgumentType(key: "photo", shortKey: "p"),
    ArgumentType(key: "zone", shortKey: "z"),
  ]);
  let parsed = parser.parse();

  // parse csv path.
  guard let locationsPath: String = parsed["src"] else {
    throw NSError(domain: "Argument 'src' not found.", code: -1, userInfo: nil);
  };

  // parse specified time.
  guard let photoPath: String = parsed["photo"]  else {
    throw NSError(domain: "Argument 'photo' not found.", code: -1, userInfo: nil);
  };

  // parse timezone.
  let hourFromGMT: Int? = Int(parsed["zone"] ?? "");
  var zone = TimeZone.current;
  if let hour = hourFromGMT {
    zone = TimeZone(secondsFromGMT: hour * 3600)!;
  }

  return (locationsPath: locationsPath, photoPath: photoPath, zone: zone);
}

struct ArgumentType {
  let key: String;
  let shortKey: String?;
}

class ArgumentParser {
  let args: [ArgumentType];
  init(args: [ArgumentType]) {
    self.args = args;
  }

  func parse() -> [String: String] {
    var counter = 1;
    var dict: [String: String] = [:];
    while counter < CommandLine.argc {
      for arg in args {
        if (
          CommandLine.arguments[counter] == "--\(arg.key)" ||
          (arg.shortKey != nil && CommandLine.arguments[counter] == "-\(arg.shortKey!)")
        ) {
          counter += 1;
          dict[arg.key] = CommandLine.arguments[counter];
        }
      }
      counter += 1;
    }
    return dict;
  }
}
