//
//  MIMMockSuite.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 27.12.2018.
//

import Foundation

open class MIMMockSuite: MockSuiteConvertible {
    public typealias MockRequest = MIMMockRequest
    
    private var mockRequests: [MockRequest] = []
    
    public required init() {
    }
    
    public required init(from decoder: Decoder) throws {
    }
    
    public func encode(to encoder: Encoder) throws {
    }
    
    open subscript(request: URLRequest) -> MockRequest? {
        return nil
    }
    
    open func append(_ newMockRequest: MockRequest) {
        mockRequests.append(newMockRequest)
    }
}

extension MIMMockSuite: Collection {
    public typealias Index = Int
    public typealias Element = MockRequest
    
    public var startIndex: Index {
        return mockRequests.startIndex
    }
    
    public var endIndex: Index {
        return mockRequests.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return mockRequests.index(after: i)
    }
    
    public subscript (i: Index) -> Element {
        return mockRequests[i]
    }
}

extension MIMMockSuite: CustomStringConvertible {
    public var description: String {
        return mockRequests.description
    }
}
