//
//  MockSuiteConvertible.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

public protocol MockSuiteConvertible: AnyObject, Codable {
    associatedtype MockRequest: MockRequestConvertible
    
    var baseUrl: String { get }
    var bundle: MockSuiteBundle { get }

    init(
        baseUrl: String,
        bundleNames: MockSuiteBundle
    )

    subscript(request: URLRequest) -> MockRequest { get }
    func append(_ newMockRequest: MockRequest)
}
