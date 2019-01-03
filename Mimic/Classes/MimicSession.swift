//
//  MimicSession.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

open class Session<
  Serialization: MockSuiteSerialization,
  Finder: MockFinder
> where Serialization.MockSuite.MockRequest == Finder.MockRequest {
    public typealias SharedSession = Shared<Serialization.MockSuite>
    
    public static var shared: SharedSession? {
        if !isRunning {
            return nil
        }
        
        if let session = savedSession as? SharedSession {
            return session
        }
        
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral
        urlSessionConfiguration.protocolClasses = [MIMURLProtocol<Finder>.self]

        let mockSuiteResult: MockSuiteSerializationResult<Serialization.MockSuite>
        
        if let mockSuiteAsText = ProcessInfo.processInfo.environment[LaunchKeys.mockSuite] {
            do {
                let mockSuite = try Serialization.decode(mockSuiteAsText)
                mockSuiteResult = .success(mockSuite)
            } catch let error as Error {
                mockSuiteResult = .failure(error)
            } catch let err {
                mockSuiteResult = .failure(.unknown(underlyingError: err))
            }
        } else {
            mockSuiteResult = .failure(.emptyOrCorruptedMockSuite)
        }
        
        let session = Shared<Serialization.MockSuite>(
            urlSessionConfiguration: urlSessionConfiguration,
            mockSuiteResult: mockSuiteResult
        )
        
        savedSession = session
        
        return session
    }
    
    private static var isRunning: Bool {
        return ProcessInfo.processInfo.arguments.contains(LaunchKeys.mimicIsRunning)
    }
}

extension Session {
    public class Shared<MockSuite: MockSuiteConvertible>: SessionInterface {
        typealias MockSuiteResult = MockSuiteSerializationResult<MockSuite>
        
        public var mockSuite: MockSuite? {
            return mockSuiteResult.mockSuite
        }
        
        public let urlSessionConfiguration: URLSessionConfiguration

        let mockSuiteResult: MockSuiteResult

        fileprivate init(
            urlSessionConfiguration: URLSessionConfiguration,
            mockSuiteResult: MockSuiteResult
        ) {
            self.urlSessionConfiguration = urlSessionConfiguration
            self.mockSuiteResult = mockSuiteResult
        }
    }
}

public typealias MimicSession = Session<MIMMockSuiteSerialization, MIMMockFinder>

protocol SessionInterface {
    var urlSessionConfiguration: URLSessionConfiguration { get }
}

var savedSession: SessionInterface?
