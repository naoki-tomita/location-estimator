//
//  Exif.swift
//  location-estimator
//
//  Created by 冨田 直希 on 2018/10/30.
//  Copyright © 2018年 冨田 直希. All rights reserved.
//

import Foundation

class ExifAnalyzer {
  let path: String;
  let data: Data;
  init(path: String) {
    self.path = path;
    self.data = try! Data(contentsOf: URL(fileURLWithPath: path));
  }

  func analyze() {
    // find marker.
    let found = data.findIndex(data: Data(bytes: [0xFF, 0xE1]));
    print(found);
  }
}

extension Data {
  func findIndex(data: Data) -> Int {
    var found = false;
    for i in 0..<self.count - data.count {
      found = false;
      for j in 0..<data.count {
        if self[i + j] == data[j] {
          found = true;
        } else {
          found = false;
        }
      }
      if found {
        return i ;
      }
    }
    return -1;
  }

  func uint16() -> UInt16 {
    return self.withUnsafeBytes({ (ptr: UnsafePointer<UInt16>) in return ptr.pointee });
  }

  func int16() -> Int16 {
    return self.withUnsafeBytes({ (ptr: UnsafePointer<Int16>) in return ptr.pointee });
  }

  func string() -> String {
    let arr = self.map { x in return x };
    return String(bytes: arr, encoding: .utf8)!;
  }

  func convert<T>() -> T {
    return self.withUnsafeBytes({ (ptr: UnsafePointer<T>) in return ptr.pointee }) as T;
  }

  func array() -> [UInt8] {
    return self.map { return $0 };
  }
}

struct TIFFHeader {
  let order: UInt16;
  let version: UInt16;
  let offset: UInt32;
}

struct TagHeader {
  let tagNumber: UInt16;
  let type: UInt16;
  let count: UInt32;
  let valueOffset: UInt32;
}

struct IFD {
  let tagCount: UInt16;
  let tags: [TagHeader];
  let nextOffset: UInt32;
}

class JPEG {
  var pointer: UInt32 = 0;
  let data: Data;
  var app1Length: UInt16!;
  var signature: String!;
  var tiffHeader: TIFFHeader!;
  var ifds: [IFD]!;

  init(contentsOf: URL) {
    data = try! Data(contentsOf: contentsOf);
    parse();
  }

  func parseData(count: UInt32) -> Data {
    let result = data.subdata(in: Int(pointer) ..< Int(pointer + count));
    pointer += count;
    return result;
  }

  private func parse() {
    let index = data.findIndex(data: Data(bytes: [0xFF, 0xE1]));
    pointer = UInt32(index + 2);
    app1Length = parseData(count: 2).uint16().bigEndian;
    signature = parseData(count: 6).string();
    let headerIndex = pointer;
    let tmpHeader = parseData(count: 8);
    tiffHeader = tmpHeader.withUnsafeBytes({ (ptr: UnsafePointer<TIFFHeader>) in
      return TIFFHeader(
        order: ptr.pointee.order.bigEndian,
        version: ptr.pointee.version.bigEndian,
        offset: ptr.pointee.offset.bigEndian
      );
    });

    let tmpIfd0Pointer = headerIndex + tiffHeader.offset;
    let tmpIfd0TagCount = data.subdata(in: Int(tmpIfd0Pointer) ..< Int(tmpIfd0Pointer + 2)).uint16().bigEndian;

    print(tmpIfd0TagCount);
    let tmpIfd0Tags = data
      .subdata(in: Int(tmpIfd0Pointer + 2) ..< Int(tmpIfd0Pointer + 2 + (12 * UInt32(tmpIfd0TagCount))))
      .withUnsafeBytes({ (ptr: UnsafePointer<TagHeader>) -> [TagHeader] in
        var tmp = ptr;
        var res: [TagHeader] = []
        for _ in 0..<Int(tmpIfd0TagCount) {
          res.append(
            TagHeader(
              tagNumber: tmp.pointee.tagNumber.bigEndian,
              type: tmp.pointee.type,
              count: tmp.pointee.count.bigEndian,
              valueOffset: tmp.pointee.valueOffset.bigEndian
            )
          );
          tmp = tmp.successor();
        }
        return res;
      });
    for tag in tmpIfd0Tags {
      print(
        String(format: "%04x", tag.tagNumber),
        String(format: "%04x", tag.type),
        String(format: "%08x", tag.count),
        String(format: "%08x", tag.valueOffset)
      );
    }
  }
}
