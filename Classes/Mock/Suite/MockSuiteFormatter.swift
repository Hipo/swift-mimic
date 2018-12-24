//
//  MockDataSuiteFormatter.swift
//  Avocare
//
//  Created by Göktuğ Berk Ulu on 19.09.2018.
//  Copyright © 2018 DocToc. All rights reserved.
//

import Foundation

public class MockSuiteFormatter {
    
    public weak var delegate: MockContentProviderDelegate?
    
    func getResult(
        for request: URLRequest,
        and mock: Mock)
        -> (response: HTTPURLResponse, data: Data)? {
            
        return delegate?.result(for: request, and: mock)
    }
    
    public static func string(from mockSuite: MockSuite) -> String {
        var result = "["
        
        for (index, mock) in mockSuite.enumerated() {
            var mockString = "{"
            
            mockString += "\"\(MockConstants.path)\": \"\(mock.path)\", \"\(MockConstants.httpMethod)\": \"\(mock.httpMethod.rawValue)\", \"\(MockConstants.contentType)\": \"\(mock.contentType.rawValue)\""
            
            if let statusCode = mock.statusCode {
                switch statusCode {
                case .success(let code):
                    mockString += ", \"\(MockConstants.status)\": \"\(MockConstants.success)\", \"\(MockConstants.code)\": \(code)"
                case .failure(let code):
                    mockString += ", \"\(MockConstants.status)\": \"\(MockConstants.failure)\", \"\(MockConstants.code)\": \(code)"
                }
            }
            
            mockString += ", \"\(MockConstants.customSettings)\": ["
            
            for (i, custom) in mock.customSettings.enumerated() {
                mockString += "\"\(custom)\""
                
                if i != mock.customSettings.count - 1 {
                    mockString += ","
                }
            }
            
            mockString += ["]"]
            
            mockString += "}"
            
            if index != mockSuite.count - 1 {
                mockString += ","
            }
            
            result += mockString
        }
        
        result += "]"

        return result
    }
    
    static func mockSuite(from string: String) -> MockSuite? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(
                with: data,
                options : .mutableContainers) as? [Dictionary<String,Any>] {
                
                var mockSuite = MockSuite()
                
                for json in jsonArray {
                    guard let path = json[MockConstants.path] as? String,
                        let httpMethod = json[MockConstants.httpMethod] as? String,
                        let contentType = json[MockConstants.contentType] as? String,
                        let status = json[MockConstants.status] as? String,
                        let code = json[MockConstants.code] as? Int,
                        let customSetings = json[MockConstants.customSettings] as? [String] else {
                            
                            return nil
                    }
                    
                    var mock = Mock(path: path)
                    
                    if let method = Mock.MockHTTPMethod(rawValue: httpMethod),
                        let type = Mock.MockContentType(rawValue: contentType) {
                        
                        mock.httpMethod = method
                        mock.contentType = type
                        
                        if status == MockConstants.success {
                            mock.statusCode = .success(code)
                        } else if status == MockConstants.failure {
                            mock.statusCode = .failure(code)
                        }
                        
                        mock.customSettings = customSetings
                    }
                    
                    mockSuite.append(mock)
                }
                
                return mockSuite
            }
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }
}
