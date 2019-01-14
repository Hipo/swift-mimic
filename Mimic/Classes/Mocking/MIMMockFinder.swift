//
//  MIMMockFinder.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 2.01.2019.
//

import Foundation

open class MIMMockFinder: MockFinder {
    public typealias MockSuite = MIMMockSuite
    
    public var mockSuite: MIMMockSuite

    public required init() {
        mockSuite = MIMMockSuite()
    }
    
    public func findMock(for mockRequest: MockSuite.MockRequest) throws -> Data {
        let dir = pathDir(for: mockRequest)
        
        for bundleName in mockSuite.bundle.names.reversed() {
            if let file = fileUrl(for: mockRequest, relativeToDir: "/\(bundleName).bundle/\(dir)") {
                do {
                    return try Data(contentsOf: file, options: .mappedIfSafe)
                } catch let error {
                    throw Error.mock(.emptyOrCorrupted(error))
                }
            }
        }
        throw Error.mock(.notFound(path: dir))
    }
}

extension MIMMockFinder {
    private func pathDir(for mockRequest: MockSuite.MockRequest) -> String {
        let ignoredDirChars = "/"
        var path = mockRequest.path.trimmed(ignoredDirChars)
        
        if let addition: String = mockRequest.options.value(for: .additionalPathComponents) {
            path += "/\(addition.trimmed(ignoredDirChars))"
        }
        return path
    }
    
    private func fileUrl(for mockRequest: MockSuite.MockRequest, relativeToDir dir: String) -> URL? {
        let baseFilename = mockRequest.httpMethod.rawValue.lowercased()
        let fileExtension = mockRequest.responseEncoding.rawValue
        let mockStatusCode = mockRequest.responseStatusCode.rawValue
        
        /// Assume {httpMethod}.{encoding} = {httpMethod}_200.{encoding} by default. Return file url for it if possible.
        if mockStatusCode == 200 {
            if let defaultFileUrl = Bundle.main.url(
                forResource: baseFilename,
                withExtension: fileExtension,
                subdirectory: dir
            ) {
                return defaultFileUrl
            }
        }
        let filename = "\(baseFilename)_\(mockStatusCode)"
        return Bundle.main.url(
            forResource: filename,
            withExtension: fileExtension,
            subdirectory: dir
        )
    }
}
