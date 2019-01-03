//
//  Error.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

public enum Error {
    public typealias System = Swift.Error

    case serialization(Serialization)
    case noMimicProcessPresent
    case noMockSuiteProvided
}

extension Error {
    public enum Serialization {
        case encodingToDataFailed(underlyingError: System)
        case encodingToStringFailed
        case decodingFromStringFailed
        case decodingFromDataFailed(underlyingError: System)
    }
}

extension Error: Swift.Error {
}
