//
//  MimicSession.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

open class Session<Finder: MockFinder>: SessionStorable {
    public typealias SharedSession = Session<Finder>
    public typealias MockSuite = Finder.MockSuite

    typealias Serialization = MockSuiteSerialization<MockSuite>
    typealias SerializationResult = MockSuiteSerializationResult<MockSuite>

    public var mockSuiteCollection: MockSuiteCollection<MockSuite>? {
        return serializationResult.mockSuiteCollection
    }

    public let isRunning: Bool
    public let urlSessionConfiguration: URLSessionConfiguration

    let serializationResult: SerializationResult
    
    private static var sessionIsRunning: Bool {
        return ProcessInfo.processInfo.arguments.contains(LaunchKeys.mimicIsRunning)
    }
    
    public static var shared: SharedSession? {
        if !sessionIsRunning {
            return nil
        }
        if let session = savedSession as? SharedSession {
            return session
        }

        let urlSessionConfiguration = URLSessionConfiguration.ephemeral
        urlSessionConfiguration.protocolClasses = [MIMURLProtocol<Finder>.self]

        let serializationResult: SerializationResult

        if let mockSuiteCollectionAsText = ProcessInfo.processInfo.environment[LaunchKeys.mockSuiteCollection] {
            do {
                let mockSuiteCollection = try Serialization.decode(mockSuiteCollectionAsText)
                serializationResult = .success(mockSuiteCollection)
            } catch let error as Error {
                serializationResult = .failure(error)
            } catch let err {
                serializationResult = .failure(.unknown(underlyingError: err))
            }
        } else {
            serializationResult = .failure(.mockSuite(.notFound(baseUrl: nil)))
        }
        let session = SharedSession(
            urlSessionConfiguration: urlSessionConfiguration,
            serializationResult: serializationResult
        )
        savedSession = session

        return session
    }
    
    private init(
        urlSessionConfiguration: URLSessionConfiguration,
        serializationResult: SerializationResult
    ) {
        self.isRunning = true
        self.urlSessionConfiguration = urlSessionConfiguration
        self.serializationResult = serializationResult
    }
}

public typealias MimicSession = Session<MIMMockFinder>

protocol SessionStorable {
}

var savedSession: SessionStorable?
