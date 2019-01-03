//
//  MimicLauncher.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 3.01.2019.
//

import Foundation

open class Launcher<Serialization: MockSuiteSerialization> {
    open class func launch(
        _ application: MimicUIApplication,
        with mockSuite: Serialization.MockSuite
    ) throws {
        application.launchArguments += [LaunchKeys.mimicIsRunning]
        application.launchEnvironment[LaunchKeys.mockSuite] = try Serialization.encode(mockSuite)
        
        application.launch()
    }
}

public typealias MimicLauncher = Launcher<MIMMockSuiteSerialization>

enum LaunchKeys {
    static let mimicIsRunning = "com.hipo.mimic.launcher.isRunning"
    static let mockSuite = "com.hipo.mimic.launcher.mockSuite"
}
