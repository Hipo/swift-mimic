//
//  MockSuiteBundle.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 14.01.2019.
//

import Foundation

public struct MockSuiteBundle: Codable {
    let names: [String]
    
    var isEmpty: Bool {
        for name in names {
            if name.isEmpty {
                return false
            }
        }
        return names.isEmpty
    }
    
    public init(names: [String]) {
        self.names = names
    }
}

extension MockSuiteBundle: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(names: [value])
    }
}

extension MockSuiteBundle: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = String
    
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(names: elements)
    }
}

extension MockSuiteBundle: CustomStringConvertible {
    public var description: String {
        return names.reduce("", +)
    }
}
