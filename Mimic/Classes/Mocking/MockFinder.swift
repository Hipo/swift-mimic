//
//  MockFinder.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

public protocol MockFinder: AnyObject {
    associatedtype MockSuite: MockSuiteConvertible
    
    var mockSuite: MockSuite { get set }
    
    init()
    func findMock(for request: MockSuite.MockRequest) throws -> Data
}

extension MockFinder {
    init(mockSuite: MockSuite) {
        self.init()
        self.mockSuite = mockSuite
    }
}
