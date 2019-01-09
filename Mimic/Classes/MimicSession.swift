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
>: SessionStorable where Serialization.MockSuite.MockRequest == Finder.MockRequest {
    public typealias MockSuite = Serialization.MockSuite
    typealias MockSuiteResult = MockSuiteSerializationResult<MockSuite>

    public var mockSuite: MockSuite? {
        return mockSuiteResult.mockSuite
    }

    public let isRunning: Bool
    public let urlSessionConfiguration: URLSessionConfiguration

    let mockSuiteResult: MockSuiteResult
    
    private static var isRunning: Bool {
        return ProcessInfo.processInfo.arguments.contains(LaunchKeys.mimicIsRunning)
    }
    
    public static var shared: Session<Serialization, Finder>? {
        if !isRunning {
            return nil
        }
        
        if let session = savedSession as? Session<Serialization, Finder> {
            return session
        }
        
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral
        urlSessionConfiguration.protocolClasses = [MIMURLProtocol<Serialization, Finder>.self]

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
        
        let session = Session<Serialization, Finder>(
            urlSessionConfiguration: urlSessionConfiguration,
            mockSuiteResult: mockSuiteResult
        )
        
        savedSession = session
        
        return session
    }
    
    private init(
        urlSessionConfiguration: URLSessionConfiguration,
        mockSuiteResult: MockSuiteResult
    ) {
        self.isRunning = true
        self.urlSessionConfiguration = urlSessionConfiguration
        self.mockSuiteResult = mockSuiteResult
    }
}

public typealias MimicSession = Session<MIMMockSuiteSerialization, MIMMockFinder>

protocol SessionStorable {
}

var savedSession: SessionStorable?
