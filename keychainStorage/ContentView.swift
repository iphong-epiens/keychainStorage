//
//  ContentView.swift
//  keychainStorage
//
//  Created by Inpyo Hong on 2021/08/20.
//

import SwiftUI
import KeychainAccess

struct MyType: Codable {
    let string: String
}

struct ContentView: View {
    @State var newValue = ""
    @KeychainStorage("MyKey") var savedValue = MyType(string: "Hello")
    @KeychainStorage("MyKey") var savedValue2: MyType?
    
    init() {
        do {
            try Keychain().remove("MyKey")
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Value", text: $newValue)
            Button("Save") {
                savedValue = MyType(string: newValue)
            }
            Text(savedValue?.string ?? "No value")
            Text(savedValue2?.string ?? "No value")
        }
    }
}
