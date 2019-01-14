//
//  MockSuiteSerializationResult.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

enum MockSuiteSerializationResult<MockSuite: MockSuiteConvertible> {
    public typealias Collection = MockSuiteCollection<MockSuite>
    
    case success(Collection)
    case failure(Error)
}

extension MockSuiteSerializationResult {
    var isFailed: Bool {
        if case .success = self {
            return false
        }
        return true
    }
    
    var mockSuiteCollection: Collection? {
        if case .success(let collection) = self {
            return collection
        }
        return nil
    }
}
