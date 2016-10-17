//
//  Parameter.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 16.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import Foundation

protocol KeyValueCodable : _KeyValueCodable {
    mutating func setValue<T>(value: T, forKey: String) throws
    func getValue<T>(forKey: String) throws -> T
}

protocol _KeyValueCodable {
    static var _codables: [KVCTypeInfo] { get }
    var _kvcstore: Dictionary<String, Any> { get set }
}

struct KVCTypeInfo : Hashable {
    let key: String
    let type: Any.Type
    
    // Terrible hash value, just FYI.
    var hashValue: Int { return key.hashValue &* 3 }
}

func ==(lhs: KVCTypeInfo, rhs: KVCTypeInfo) -> Bool {
    return lhs.key == rhs.key && lhs.type == rhs.type
}

extension KeyValueCodable {
    mutating func setValue<T>(value: T, forKey: String) {
        for codable in Self._codables {
            if codable.key == forKey {
                if type(of: value) != codable.type {
                    fatalError("The stored type information does not match the given type.")
                }
                
                _kvcstore[forKey] = value
                return
            }
        }
        
        fatalError("Unable to set the value for key: \(forKey).")
    }
    
    func getValue<T>(forKey: String) -> T {
        guard let stored = _kvcstore[forKey] else {
            fatalError("The property is not set; default values are not supported.")
        }
        
        guard let value = stored as? T else {
            fatalError("The stored value does not match the expected type.")
        }
        
        return value
    }
}


struct Parameter: KeyValueCodable {
    
    static var _codables: [KVCTypeInfo] { return [_idKey]}
    var _kvcstore: Dictionary<String, Any> = [:]

    private static let _idKey = KVCTypeInfo(key: "value", type: Int.self)
    
    init(value: Int) {
        self.value = value
    }
    
    var value: Int {
        get { return getValue(forKey: "value") as Int }
        set { setValue(value: newValue, forKey: "value") }
    }

}
