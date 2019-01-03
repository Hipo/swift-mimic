//
//  HTTPMethod.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 27.12.2018.
//

import Foundation

public enum HTTPMethod: String, Codable {
    case get = "GET"
    case head = "HEAD"
    case delete = "DELETE"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
}

extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
