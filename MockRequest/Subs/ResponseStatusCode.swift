//
//  ResponseStatusCode.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 27.12.2018.
//

import Foundation

public enum ResponseStatusCode: Codable {
    case success(Int)
    case failure(Int)
}

extension ResponseStatusCode: RawRepresentable {
    public typealias RawValue = Int
    
    public var rawValue: Int {
        switch self {
        case .success(let code),
             .failure(let code):
            return code
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case 200..<300:
            self = .success(rawValue)
        case 300..<600:
            self = .failure(rawValue)
        default:
            return nil
        }
    }
}

extension ResponseStatusCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success(let code):
            return "\(code) OK"
        case .failure(let code):
            return "\(code) FAILED"
        }
    }
}
