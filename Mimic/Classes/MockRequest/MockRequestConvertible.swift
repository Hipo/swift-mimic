//
//  MockRequestConvertible.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

public protocol MockRequestConvertible: AnyObject, Codable {
    var httpMethod: HTTPMethod { get set }
    
    var responseStatusCode: ResponseStatusCode { get set }
    var responseEncoding: ResponseEncoding { get }
    var options: ResponseReadingOptions { get }
    
    var path: Path { get }
    
    init(path: Path)
}

extension MockRequestConvertible {
    public var responseEncoding: ResponseEncoding {
        return .json
    }
    
    public var options: ResponseReadingOptions {
        return [:]
    }
}
