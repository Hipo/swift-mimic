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
    var options: MockOptions { get }
    
    var path: String { get }
    
    init(path: PathConvertible)
    
    func isEqual(to request: URLRequest) -> Bool
}

extension MockRequestConvertible {
    public var responseEncoding: ResponseEncoding {
        return .json
    }
    
    public var options: MockOptions {
        return [:]
    }
    
    public func isEqual(to request: URLRequest) -> Bool {
        let ignoredPathChars = "/"
        return
            path.trimmed(ignoredPathChars) == request.url?.path.trimmed(ignoredPathChars) &&
            httpMethod.rawValue == request.httpMethod
    }
}
