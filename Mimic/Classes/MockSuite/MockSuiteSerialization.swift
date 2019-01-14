//
//  MockSuiteSerialization.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

class MockSuiteSerialization<MockSuite: MockSuiteConvertible> {
    typealias Collection = MockSuiteCollection<MockSuite>
    
    class func encode(_ collection: Collection) throws -> String {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(collection)
            
            if let dataString = String(data: data, encoding: .utf8) {
                return dataString
            }
            
            throw Error.serialization(.encodingToStringFailed)
        } catch let error {
            throw Error.serialization(.encodingToDataFailed(underlyingError: error))
        }
    }
    
    class func decode(_ string: String) throws -> Collection {
        let decoder = JSONDecoder()
        
        do {
            guard let data = string.data(using: .utf8) else {
                throw Error.serialization(.decodingFromStringFailed)
            }
            
            return try decoder.decode(Collection.self, from: data)
        } catch let error {
            throw Error.serialization(.decodingFromDataFailed(underlyingError: error))
        }
    }
}
