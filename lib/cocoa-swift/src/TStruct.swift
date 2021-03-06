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


/// Protocol for Generated Structs to conform to
/// Dictionary maps field names to internal IDs and uses Reflection
/// to iterate through all fields.
/// `writeFieldValue(_:name:type:id:)` calls `TSerializable.write(to:)` internally
/// giving a nice recursive behavior for nested TStructs, TLists, TMaps, and TSets
public protocol TStruct : TSerializable {
}

public extension TStruct {
    public static var thriftType : TType { return TType.STRUCT }
}
