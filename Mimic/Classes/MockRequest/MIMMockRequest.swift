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
    public var options: ResponseReadingOptions = [:]
    
    public let path: Path
    
    public required init(path: Path) {
        self.path = path
    }
}

extension MIMMockRequest: CustomStringConvertible {
    public var description: String {
        return """
        Request: \(httpMethod.description) \(path.description)
        Status: \(responseStatusCode.description)
        Encoding: \(responseEncoding.description)
        """
    }
}
