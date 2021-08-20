//
//  KeychainStorage.swift
//  keychainStorage
//
//  Created by Inpyo Hong on 2021/08/20.
//


import SwiftUI
import KeychainAccess

@propertyWrapper
struct KeychainStorage<T: Codable>: DynamicProperty {
  typealias Value = T
  let key: String
  @State private var value: Value?
  
  init(wrappedValue: Value? = nil, _ key: String) {
    self.key = key
    var initialValue = wrappedValue
    do {
      try Keychain().get(key) {
        attributes in
        if let attributes = attributes, let data = attributes.data {
          do {
            let decoded = try JSONDecoder().decode(Value.self, from: data)
            initialValue = decoded
          } catch let error {
            fatalError("\(error)")
          }
        }
      }
    }
    catch let error {
      fatalError("\(error)")
    }
    self._value = State<Value?>(initialValue: initialValue)
  }
  var wrappedValue: Value? {
    get  { value }
    
    nonmutating set {
      value = newValue
      do {
        let encoded = try JSONEncoder().encode(value)
        try Keychain().set(encoded, key: key)
      } catch let error {
        fatalError("\(error)")
      }
    }
  }
  var projectedValue: Binding<Value?> {
    Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
  }
}
