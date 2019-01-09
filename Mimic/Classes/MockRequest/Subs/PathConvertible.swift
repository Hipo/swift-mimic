//
//  PathConvertible.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 4.01.2019.
//

import Foundation

public protocol PathConvertible: CustomStringConvertible {
    func toString() -> String
}

extension PathConvertible {
    public var description: String {
        return toString()
    }
}

extension String: PathConvertible {
    public func toString() -> String {
        return self
    }
}
