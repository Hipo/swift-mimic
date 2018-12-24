//
//  MockDataSuite.swift
//  Avocare
//
//  Created by Göktuğ Berk Ulu on 19.09.2018.
//  Copyright © 2018 DocToc. All rights reserved.
//

import Foundation

public struct MockSuite {
    
    typealias Mocks = [Mock]
    
    private var mocks = Mocks()
    
    // MARK: Initialization
    
    public init() {
    }
}

// MARK: Public:API

public extension MockSuite {
    mutating func append(_ mock: Mock) {
        mocks.append(mock)
    }
    
    mutating func removeAll() {
        mocks.removeAll()
    }
}

// MARK: Collection

extension MockSuite: Collection {
    
    public var startIndex: Int {
        return mocks.startIndex
    }
    
    public var endIndex: Int {
        return mocks.endIndex
    }
    
    public subscript(index: Int) -> Mock {
        return mocks[index]
    }
    
    public func index(after i: Int) -> Int {
        return mocks.index(after: i)
    }
}

// MARK: CustomStringConvertible

extension MockSuite: CustomStringConvertible {
    public var description: String {
        return String(describing: mocks)
    }
}
