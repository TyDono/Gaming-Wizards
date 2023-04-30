//
//  DependencyInjector.swift
//  Foodiii
//
//  Created by Tyler Donohue on 4/5/23.
//

import Foundation

struct DependencyInjector {
    private static var dependencyList: [String: Any] = [:]
    
    static func resolve<T>() -> T {
        guard let t = dependencyList[String(describing: T.self)] as? T else {
            fatalError("No provider registered for type \(T.self)")
        }
        return t
    }
    
    static func register<T>(dependency: T) {
        dependencyList[String(describing: T.self)] = dependency
    }
    
}

@propertyWrapper struct Inject<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = DependencyInjector.resolve()
        print("Injected <-", self.wrappedValue)
    }
}

@propertyWrapper struct Provider<T> { //call Provider before the Inject property wrapper
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        DependencyInjector.register(dependency: wrappedValue)
        print("Provided ->", self.wrappedValue)
    }
}
