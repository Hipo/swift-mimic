//
//  Error.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

public enum Error {
    public typealias System = Swift.Error

    case noSession

    case serialization(Serialization)
    case mockSuite(MockSuite)
    case mock(Mock)

    case unidentifierUrl

    case unknown(underlyingError: System?)
}

extension Error {
    public enum Serialization {
        case encodingToDataFailed(underlyingError: System)
        case encodingToStringFailed
        case decodingFromStringFailed
        case decodingFromDataFailed(underlyingError: System)
    }
    
    public enum MockSuite {
        case emptyOrCorrupted
        case emptyBaseUrl(bundle: String)
        case emptyBundle(baseUrl: String)
        case multipleSameBaseUrl(bundles: String)
        case notFound(baseUrl: String?)
    }
    
    public enum Mock {
        case notFound(path: String)
        case emptyOrCorrupted(System?)
    }
}

extension Error: Swift.Error {
}
