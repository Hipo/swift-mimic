//
//  MIMMockSuiteSerialization.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

open class MIMMockSuiteSerialization {
    open class func encode(_ mockSuite: MockSuite) throws -> String {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(mockSuite)
            
            if let dataString = String(data: data, encoding: .utf8) {
                return dataString
            }
            
            throw Error.serialization(.encodingToStringFailed)
        } catch let error {
            throw Error.serialization(.encodingToDataFailed(underlyingError: error))
        }
    }

    open class func decode(_ string: String) throws -> MockSuite {
        let decoder = JSONDecoder()
        
        do {
            guard let data = string.data(using: .utf8) else {
                throw Error.serialization(.decodingFromStringFailed)
            }
            
            return try decoder.decode(MockSuite.self, from: data)
        } catch let error {
            throw Error.serialization(.decodingFromDataFailed(underlyingError: error))
        }
    }
}

extension MIMMockSuiteSerialization: MockSuiteSerialization {
    public typealias MockSuite = MIMMockSuite
    
}
