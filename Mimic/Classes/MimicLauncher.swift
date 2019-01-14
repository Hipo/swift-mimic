//
//  MimicLauncher.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

open class Launcher<MockSuite: MockSuiteConvertible> {
    open class func launch(_ application: MimicUIApplication, with mockSuites: [MockSuite]) throws {
        let collection = try MockSuiteCollection(mockSuites: mockSuites)
        
        application.launchArguments += [LaunchKeys.mimicIsRunning]
        application.launchEnvironment[LaunchKeys.mockSuiteCollection] = try MockSuiteSerialization.encode(collection)
        application.launch()
    }
}

public typealias MimicLauncher = Launcher<MIMMockSuite>

enum LaunchKeys {
    static let mimicIsRunning = "com.hipo.mimic.launcher.isRunning"
    static let mockSuiteCollection = "com.hipo.mimic.launcher.mockSuiteCollection"
}
