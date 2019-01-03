//
//  MockFinder.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

public protocol MockFinder: AnyObject {
    associatedtype MockRequest: MockRequestConvertible

    static func findMock(for mockRequest: MockRequest) throws -> Data
}
