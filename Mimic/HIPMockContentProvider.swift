//
//  HIPMockDataProvider.swift
//  Avocare
//
//  Created by Göktuğ Berk Ulu on 24.09.2018.
//  Copyright © 2018 DocToc. All rights reserved.
//

import Foundation

class HIPMockContentProvider: MockContentProvider {
    
    func findContent(for mock: Mock) -> Data? {
        
        let base = MockConstants.baseFile
        let request = mock.path
        let method = mock.httpMethod.rawValue
        let type = mock.contentType.rawValue
        let customSettings = mock.customSettings
        
        var path: String
        
        if let statusCode = mock.statusCode {
            switch statusCode {
            case .success:
                if customSettings.count > 0 {
                    path = "\(base)\(request)"
                    for custom in customSettings {
                        path += "\(custom)"
                    }
                    
                    path += "/\(MockConstants.success)/"
                } else {
                    path = "\(base)\(request)"
                    
                    if let lastCharacter = path.last, lastCharacter != "/" {
                        path += "/"
                    }
                    
                    path += "\(MockConstants.success)/"
                }
            case .failure(let code):
                if customSettings.count > 0 {
                    path = "\(base)\(request)"
                    for custom in customSettings {
                        path += "/\(custom)"
                    }
                    
                    path += "/\(MockConstants.failure)/\(code)/"
                } else {
                    path = "\(base)\(request)"
                    
                    if let lastCharacter = path.last, lastCharacter != "/" {
                        path += "/"
                    }
                    
                    path += "\(MockConstants.failure)/\(code)/"
                }
            }
        } else {
            if customSettings.count > 0 {
                path = "\(base)\(request)"
                for custom in customSettings {
                    path += "/\(custom)"
                }
            } else {
                path = "\(base)\(request)"
            }
            
        }
        
        guard let filePath = Bundle.main.path(
            forResource: method,
            ofType: type,
            inDirectory: path) else {
                
            return nil
        }
        
        do {
            let url = URL(fileURLWithPath: filePath)
            
            let data = try Data(
                contentsOf: url,
                options: .mappedIfSafe
            )
            
            return data
        } catch {
        
        }
        
        return nil
    }
}
