//
//  MockFinder.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

public protocol MockFinder: AnyObject {
    associatedtype MockRequest: MockRequestConvertible
    
    static var mainDirectoryUrl: URL { get }

    static func findMock(for mockRequest: MockRequest) throws -> Data
}

extension MockFinder {
    public static func findMock(for mockRequest: MockRequest) throws -> Data {
        let dir = dirUrl(for: mockRequest)
        let file = mockRequest.httpMethod.rawValue
        let fileExtension = mockRequest.responseEncoding.rawValue
        
        let fileUrl = dir
            .appendingPathComponent(file, isDirectory: false)
            .appendingPathExtension(fileExtension)
        
        do {
            return try Data(contentsOf: fileUrl, options: .mappedIfSafe)
        } catch let error {
            throw Error.emptyOrCorruptedMock(error)
        }
    }
}

extension MockFinder {
    private static func dirUrl(for mockRequest: MockRequest) -> URL {
        let ignoredDirChars = "/"
        
        var dirPath = mockRequest.path.trimmed(ignoredDirChars)
        
        if let addition: String = mockRequest.options.value(for: .additionalPathComponents) {
            dirPath += "/\(addition.trimmed(ignoredDirChars))"
        }
        
        switch mockRequest.responseStatusCode {
        case .success(let code):
            dirPath += "/success"

            let isEnabled: Bool = mockRequest.options.value(for: .enablesPathComponentForSuccessCode) ?? false

            if isEnabled {
                dirPath += "/\(code)"
            }
        case .failure(let code):
            dirPath += "/failure"
            
            let isEnabled: Bool = mockRequest.options.value(for: .enablesPathComponentForFailureCode) ?? false
            
            if isEnabled {
                dirPath += "/\(code)"
            }
        }
        
        return mainDirectoryUrl.appendingPathComponent(dirPath, isDirectory: true)
    }
}
