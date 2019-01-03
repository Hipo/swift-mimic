//
//  MimicProcess.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

public class MimicProcess {
    public var isRunning: Bool {
        return ProcessInfo.processInfo.arguments.contains(LaunchKeys.mimicIsRunning)
    }
    
    public var urlSessionConfiguration: URLSessionConfiguration? {
        return isRunning ? registeredUrlSessionConfiguration : nil
    }
    
    public static let current = MimicProcess()

    private var registeredUrlSessionConfiguration: URLSessionConfiguration?
    
    private init() {
    }
}

extension MimicProcess {
    func register(urlProtocol: URLProtocol.Type) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [urlProtocol.self]
        
        registeredUrlSessionConfiguration = configuration
    }
    
    func getMockSuiteAsText() throws -> String {
        if isRunning {
            throw Error.noMimicProcessPresent
        }

        guard let mockSuiteAsText = ProcessInfo.processInfo.environment[LaunchKeys.mockSuite] else {
            throw Error.noMockSuiteProvided
        }

        return mockSuiteAsText
    }
}

extension MimicProcess {
    enum LaunchKeys {
        static let mimicIsRunning = "com.hipo.mimic.isRunning"
        static let mockSuite = "com.hipo.mimic.suite"
    }
}
