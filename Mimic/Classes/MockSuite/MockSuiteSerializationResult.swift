//
//  MockSuiteSerializationResult.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

public enum MockSuiteSerializationResult<MockSuite: MockSuiteConvertible> {
    case success(MockSuite)
    case failure(Error)
}

extension MockSuiteSerializationResult {
    var isFailed: Bool {
        if case .success = self {
            return false
        }
        return true
    }
    
    var mockSuite: MockSuite? {
        if case .success(let mockSuite) = self {
            return mockSuite
        }
        return nil
    }
}
