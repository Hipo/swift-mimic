//
//  MIMMockRequest.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 27.12.2018.
//

import Foundation

open class MIMMockRequest: MockRequestConvertible {
    public var httpMethod = HTTPMethod.get

    public var responseStatusCode = ResponseStatusCode.success(200)
    public var responseEncoding = ResponseEncoding.json
    public var options: MockOptions = [:]
    
    /// Accepts an url path pattern matching to the related mock file path, i.e. api/users/authenticate/
    public let path: String
    
    public required init(path: PathConvertible) {
        self.path = path.toString()
    }
}

extension MIMMockRequest: CustomStringConvertible {
    public var description: String {
        return """
        Request: \(httpMethod.description) \(path.description)
        Status: \(responseStatusCode.description)
        Encoding: \(responseEncoding.description)
        Options: \(options.description)
        """
    }
}
