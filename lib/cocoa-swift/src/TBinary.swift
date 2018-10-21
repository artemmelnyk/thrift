/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import Foundation


public struct TBinary : TSerializable {
  
  public static var thriftType : TType { return .STRING }
  
  var storage : Data
  
  public init() {
    self.storage = Data()
  }
  
    public init(contentsOfFile file: String, options: Data.ReadingOptions = []) throws {
    self.storage = try Data(contentsOf: URL(fileURLWithPath: file), options: options)
  }
  
    public init(contentsOfURL URL: URL, options: Data.ReadingOptions = []) throws {
        self.storage = try Data(contentsOf: URL, options: options)
  }
  
    public init?(base64EncodedData base64Data: Data, options: Data.Base64DecodingOptions = []) {
        guard let storage = Data(base64Encoded: base64Data, options: options) else {
      return nil
    }
    self.storage = storage
  }
  
  public init(data: Data) {
    self.storage = data
  }
  
  public var length : Int {
    return storage.count
  }
  
  public var hashValue : Int {
    return storage.hashValue
  }

  
  public func getBytes(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
    storage.copyBytes(to: buffer, count: length)
  }
  
  public func getBytes(buffer: UnsafeMutablePointer<UInt8>, range: Range<Int>) {
    storage.copyBytes(to: buffer, from: Range(range))
  }
  
  public func subBinaryWithRange(range: Range<Int>) -> TBinary {
    return TBinary(data: storage.subdata(in: Range(range)))
  }
  
    public func writeToFile(path: String, options: Data.WritingOptions = []) throws {
    try storage.write(to: URL(string: path)!, options: options)
  }
  
    public func writeToURL(url: URL, options: Data.WritingOptions = []) throws {
    try storage.write(to: url, options: options)
  }
  
    public func rangeOfData(dataToFind data: Data, options: Data.SearchOptions, range: Range<Int>) -> Range<Int>? {
        return storage.range(of:data, options:options, in:Range(range))
  }
  
  public func enumerateByteRangesUsingBlock(block: (UnsafeBufferPointer<UInt8>, Data.Index, inout Bool) -> Void) {
    storage.enumerateBytes { (bytes, range, stop) in
        var stopTmp = Bool(stop)
        block(bytes, range, &stopTmp)
        stop = stopTmp
    }

  }
  
  public static func readValueFromProtocol(proto: TProtocol) throws -> TBinary {
    var data : NSData?
    try proto.readBinary(&data!)
    return TBinary(data: data! as Data)
  }
  
  public static func writeValue(value: TBinary, toProtocol proto: TProtocol) throws {
    try proto.writeBinary(value.storage)
  }
  
}

extension TBinary : CustomStringConvertible, CustomDebugStringConvertible {
  
  public var description : String {
    return storage.description
  }
  
  public var debugDescription : String {
    return storage.debugDescription
  }
  
}

public func ==(lhs: TBinary, rhs: TBinary) -> Bool {
  return lhs.storage == rhs.storage
}
