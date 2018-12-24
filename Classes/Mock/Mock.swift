//
//  MockDataSuiteCase.swift
//  Avocare
//
//  Created by Göktuğ Berk Ulu on 19.09.2018.
//  Copyright © 2018 DocToc. All rights reserved.
//

import Foundation

public struct Mock {
    
    // MARK: Variables
    
    public var httpMethod = MockHTTPMethod.get
    public var contentType = MockContentType.json
    public var statusCode = MockStatusCode(rawValue: 200)
    public var customSettings = [String]()
    
    let path: String
    
    // MARK: Initialization
    
    public init(path: String) {
        self.path = path
    }
}

// MARK: Configuration

extension Mock {
    public enum MockHTTPMethod: String {
        case get = "get"
        case post = "post"
        case put = "put"
        case patch = "patch"
        case delete = "delete"
    }
    
    public enum MockContentType: String {
        case json = "json"
    }
    
    public enum MockStatusCode {
        case success(Int)
        case failure(Int)
    }
}

// MARK: MockStatusCode

extension Mock.MockStatusCode: RawRepresentable {
    public typealias RawValue = Int
    
    public var rawValue: RawValue {
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
        case 300...500:
            self = .failure(500)
        default:
            return nil
        }
    }
}

// MARK: Hashable

extension Mock: Hashable {
    public var hashValue: Int {
        return path.hashValue ^ httpMethod.hashValue
    }
    
    public static func == (lhs: Mock, rhs: Mock) -> Bool {
        return true
    }
}
