//
//  MockSuiteSerialization.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

public protocol MockSuiteSerialization: AnyObject {
    associatedtype MockSuite: MockSuiteConvertible
    
    static func encode(_ mockSuite: MockSuite) throws -> String
    static func decode(_ text: String) throws -> MockSuite
}
