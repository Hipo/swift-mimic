//
//  MockSuiteCollection.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 14.01.2019.
//

import Foundation

public struct MockSuiteCollection<MockSuite: MockSuiteConvertible>: Codable {
    typealias InternalType = [String: MockSuite]
    
    private var mockSuites: InternalType = [:]
    
    init(mockSuites: [MockSuite]) throws {
        var mockSuiteDict: InternalType = [:]
        
        for suite in mockSuites {
            if suite.baseUrl.isEmpty {
                throw Error.mockSuite(.emptyBaseUrl(bundle: suite.bundle.description))
            }
            if suite.bundle.isEmpty {
                throw Error.mockSuite(.emptyBundle(baseUrl: suite.baseUrl))
            }
            if let foundMockSuite = self.mockSuites[suite.baseUrl] {
                throw Error.mockSuite(.multipleSameBaseUrl(bundles: "\(foundMockSuite.bundle.description) & \(suite.bundle.description)"))
            }
            mockSuiteDict[suite.baseUrl] = suite
        }
        
        self.mockSuites = mockSuiteDict
    }
    
    subscript (baseUrl: String) -> MockSuite? {
        if mockSuites.count == 1 {
            return mockSuites.first?.value
        }
        return mockSuites[baseUrl]
    }
}

extension MockSuiteCollection: CustomStringConvertible {
    public var description: String {
        return mockSuites.reduce("") {
            $0 + String(describing: $1.value)
        }
    }
}
