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


public struct TSet<Element : TSerializable> : Collection, ArrayLiteralConvertible, TSerializable {
    
    public func index(after i: Index) -> Index {
        return storage.index(after: i)
    }
    
    public func formIndex(after i: inout Storage.Index) {
        storage.formIndex(after: &i)
    }
    
  
  public static var thriftType : TType { return .SET }
  
  public typealias Index = Storage.Index
  
  typealias Storage = Set<Element>
  
  var storage : Storage
  
  public init() {
    storage = Storage()
  }
  
  public init(arrayLiteral elements: Element...) {
    storage = Storage(elements)
  }
  
    public init<Source : Sequence>(_ sequence: Source) where Source.Iterator.Element == Element {
        storage = Storage(sequence)
    }
  
  public var startIndex : Index { return storage.startIndex }
  
  public var endIndex : Index { return storage.endIndex }
  
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        return storage.insert(newMember)
    }
  
  public mutating func remove(element: Element) -> Element? {
    return storage.remove(element)
  }
  
    public mutating func removeAll(keepCapacity: Bool = false) {
    return storage.removeAll(keepingCapacity: keepCapacity)
  }
  
  public mutating func removeAtIndex(index: SetIndex<Element>) -> Element {
    return storage.remove(at: index)
  }
  
  public subscript (position: SetIndex<Element>) -> Element {
    return storage[position]
  }
  
  public func union(other: TSet) -> TSet {
    return TSet(storage.union(other))
  }
  
    public func intersection(_ other: TSet<Element>) -> TSet {
        return TSet(storage.intersection(other.storage))
    }

  public var isEmpty: Bool { return storage.isEmpty }

  public var hashValue : Int {
    let prime = 31
    var result = 1
    for element in storage {
      result = prime * result + element.hashValue
    }
    return result
  }
  
  public static func readValueFromProtocol(proto: TProtocol) throws -> TSet {
    let (elementType, size) = try proto.readSetBegin()
    if elementType != Element.thriftType {
      throw NSError(
        domain: TProtocolErrorDomain,
        code: Int(TProtocolError.invalidData.rawValue),
        userInfo: [TProtocolErrorExtendedErrorKey: NSNumber(value: elementType.rawValue)])
    }
    var set = TSet()
    for _ in 0..<size {
        let element = try Element.readValueFromProtocol(proto: proto)
      set.storage.insert(element)
    }
    try proto.readSetEnd()
    return set
  }
  
  public static func writeValue(value: TSet, toProtocol proto: TProtocol) throws {
    try proto.writeSetBeginWithElementType(elementType: Element.thriftType, size: value.count)
    for element in value.storage {
        try Element.writeValue(value: element, toProtocol: proto)
    }
    try proto.writeSetEnd()
  }
  
}

extension TSet : CustomStringConvertible, CustomDebugStringConvertible {
  
  public var description : String {
    return storage.description
  }
  
  public var debugDescription : String {
    return storage.debugDescription
  }
  
}

public func ==<Element>(lhs: TSet<Element>, rhs: TSet<Element>) -> Bool {
  return lhs.storage == rhs.storage
}
