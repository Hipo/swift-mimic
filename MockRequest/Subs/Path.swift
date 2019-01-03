//
//  Path.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 27.12.2018.
//

import Foundation

public struct Path: Codable {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
}

extension Path: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: StringLiteralType) {
        self = Path(value)
    }
}

extension Path: CustomStringConvertible {
    public var description: String {
        return value
    }
}
