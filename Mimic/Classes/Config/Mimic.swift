//
//  Mimic.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 2.01.2019.
//

import Foundation

open class Mimic<
  Finder: MockFinder,
  Serialization: MockSuiteSerialization
> where Finder.MockRequest == Serialization.MockSuite.MockRequest {
    private init() {
    }
    
    public class func launch(
        _ application: MimicUIApplication,
        with mockSuite: Serialization.MockSuite
    ) throws {
        MimicProcess.current.register(urlProtocol: MIMURLProtocol<Finder, Serialization>.self)
        
        application.launchArguments += [MimicProcess.LaunchKeys.mimicIsRunning]
        application.launchEnvironment[MimicProcess.LaunchKeys.mockSuite] = try Serialization.encode(mockSuite)

        application.launch()
    }
}
