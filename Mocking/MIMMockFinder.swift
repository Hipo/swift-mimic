//
//  MIMMockFinder.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 2.01.2019.
//

import Foundation

open class MIMMockFinder {
    open class func findMock(for mockRequest: MockRequest) throws -> Data {
        return Data()
    }
}

extension MIMMockFinder: MockFinder {
    public typealias MockRequest = MIMMockRequest
}
