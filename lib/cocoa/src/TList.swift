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



public struct TList<Element : TSerializable> : Collection, Hashable, ArrayLiteralConvertible, TSerializable {
    
    
    public static var thriftType : TType { return .LIST }
    
    public typealias Storage = [Element]
    
    public typealias Index = Storage.Index
    
    public var storage = Storage()
    
    public var startIndex : Index {
        return storage.startIndex
    }
    
    public var endIndex : Index {
        return storage.endIndex
    }
    
    public subscript (position: Index) -> Element {
        get {
            return storage[position]
        }
        set {
            storage[position] = newValue
        }
    }
    
    public var hashValue : Int {
        let prime = 31
        var result = 1
        for element in storage {
            result = prime * result + element.hashValue
        }
        return result
    }
    
    public init(arrayLiteral elements: Element...) {
        self.storage = Storage(elements)
    }
    
    public init<Source : Sequence>(_ sequence: Source) where Source.Iterator.Element == Element {
        storage = Storage(sequence)
    }
    
    public init() {
        self.storage = Storage()
    }
    
    public mutating func append(newElement: Element) {
        self.storage.append(newElement)
    }
    
    public mutating func appendContentsOf<C : Collection>(newstorage: C) where C.Generator.Element == Element {
        self.storage.append(contentsOf: newstorage)
    }
    
    public mutating func insert(newElement: Element, atIndex index: Int) {
        self.storage.insert(newElement, at: index)
    }
    
    public mutating func removeAll(keepCapacity: Bool = true) {
        self.storage.removeAll(keepingCapacity: keepCapacity)
    }
    
    public mutating func removeAtIndex(index: Index) {
        self.storage.remove(at: index)
    }
    
    public mutating func removeFirst(n: Int = 0) {
        self.storage.removeFirst(n)
    }
    
    public mutating func removeLast() -> Element {
        return self.storage.removeLast()
    }
    
    public mutating func removeRange(subRange: Range<Index>) {
        self.storage.removeSubrange(subRange)
    }
    
    public mutating func reserveCapacity(minimumCapacity: Int) {
        self.storage.reserveCapacity(minimumCapacity)
    }
    
    public static func readValueFromProtocol(proto: TProtocol) throws -> TList {
        let (elementType, size) = try proto.readListBegin()
        if elementType != Element.thriftType {
            throw NSError(
                domain: TProtocolErrorDomain,
                code: Int(TProtocolError.invalidData.rawValue),
                userInfo: [TProtocolErrorExtendedErrorKey: NSNumber(value: TProtocolExtendedError.unexpectedType.rawValue)])
        }
        var list = TList()
        for _ in 0..<size {
            let element = try Element.readValueFromProtocol(proto: proto)
            list.storage.append(element)
        }
        try proto.readListEnd()
        return list
    }
    
    public static func writeValue(value: TList, toProtocol proto: TProtocol) throws {
        try proto.writeListBeginWithElementType(elementType: Element.thriftType, size: value.count)
        for element in value.storage {
            try Element.writeValue(value: element, toProtocol: proto)
        }
        try proto.writeListEnd()
    }
    
    /// Mark: IndexableBase
    public func index(after i: Index) -> Index {
        return storage.index(after: i)
    }
    
    public func formIndex(after i: inout Storage.Index) {
        storage.formIndex(after: &i)
    }
}

extension TList : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return storage.description
    }
    
    public var debugDescription : String {
        return storage.debugDescription
    }
    
}

public func ==<Element>(lhs: TList<Element>, rhs: TList<Element>) -> Bool {
    return lhs.storage == rhs.storage
}
