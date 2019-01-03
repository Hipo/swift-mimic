//
//  ResponseEncoding.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 27.12.2018.
//

import Foundation

public enum ResponseEncoding: String, Codable {
    case json = "json"
}

extension ResponseEncoding: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
