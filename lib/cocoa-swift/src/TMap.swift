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


public struct TMap<Key : TSerializable, Value : TSerializable> : Collection, DictionaryLiteralConvertible, TSerializable {
    
    public func index(after i: Index) -> Index {
        return storage.index(after: i)
    }
    
  
  public static var thriftType : TType { return .MAP }

  typealias Storage = Dictionary<Key, Value>

  public typealias Index = Storage.Index

  public typealias Element = Storage.Element
  
  var storage : Storage

  public var startIndex : Index {
    return storage.startIndex
  }
  
  public var endIndex: Index {
    return storage.endIndex
  }

  public var keys: LazyMapCollection<[Key : Value], Key> {
    return storage.keys
  }
  
  public var values: LazyMapCollection<[Key : Value], Value> {
    return storage.values
  }
    
    public var dictionary: [Key: Value] {
        return storage
    }
  
  public init() {
    storage = Storage()
  }
    
    /// init from Dictionary<K,V>
    public init(_ dict: [Key: Value]) {
        storage = dict
    }
  
  public init(dictionaryLiteral elements: (Key, Value)...) {
    storage = Storage()
    for (key, value) in elements {
      storage[key] = value
    }
  }
  
  public init(minimumCapacity: Int) {
    storage = Storage(minimumCapacity: minimumCapacity)
  }
  
  public subscript (position: Index) -> Element {
    get {
      return storage[position]
    }
  }
  
    public func indexForKey(_ key: Key) -> Index? {
        return storage.index(forKey: key)
    }
  
  public subscript (key: Key) -> Value? {
    get {
      return storage[key]
    }
    set {
      storage[key] = newValue
    }
  }

    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        return updateValue(value, forKey: key)
    }
    
    public mutating func removeAtIndex(_ index: DictionaryIndex<Key, Value>) -> (Key, Value) {
        return removeAtIndex(index)
    }
    
    public mutating func removeValueForKey(_ key: Key) -> Value? {
        return storage.removeValue(forKey: key)
    }
  
    public mutating func removeAll(keepCapacity: Bool = false) {
    storage.removeAll(keepingCapacity: keepCapacity)
  }

  public var hashValue : Int {
    let prime = 31
    var result = 1
    for (key, value) in storage {
      result = prime * result + key.hashValue
      result = prime * result + value.hashValue
    }
    return result
  }
  
  public static func readValueFromProtocol(proto: TProtocol) throws -> TMap {
    let (keyType, valueType, size) = try proto.readMapBegin()
    if keyType != Key.thriftType || valueType != Value.thriftType {
      throw NSError(
        domain: TProtocolErrorDomain,
        code: Int(TProtocolError.invalidData.rawValue),
        userInfo: [TProtocolErrorExtendedErrorKey: NSNumber(value: TProtocolExtendedError.unexpectedType.rawValue)])
    }
    var map = TMap()
    for _ in 0..<size {
        let key = try Key.readValueFromProtocol(proto: proto)
        let value = try Value.readValueFromProtocol(proto: proto)
      map.storage[key] = value
    }
    try proto.readMapEnd()
    return map
  }
  
  public static func writeValue(value: TMap, toProtocol proto: TProtocol) throws {
    try proto.writeMapBeginWithKeyType(keyType: Key.thriftType, valueType: Value.thriftType, size: value.count)
    for (key, value) in value.storage {
        try Key.writeValue(value: key, toProtocol: proto)
        try Value.writeValue(value: value, toProtocol: proto)
    }
    try proto.writeMapEnd()
  }
  
}


extension TMap : CustomStringConvertible, CustomDebugStringConvertible {
  
  public var description : String {
    return storage.description
  }
  
  public var debugDescription : String {
    return storage.debugDescription
  }
  
}

public func ==<Key, Value>(lhs: TMap<Key,Value>, rhs: TMap<Key, Value>) -> Bool {
  if lhs.count != rhs.count {
    return false
  }
  return lhs.storage == rhs.storage
}
