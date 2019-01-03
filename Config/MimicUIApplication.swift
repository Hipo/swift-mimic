//
//  MimicUIApplication.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 2.01.2019.
//

import Foundation

public protocol MimicUIApplication: AnyObject {
    var launchArguments: [String] { get set }
    var launchEnvironment: [String : String] { get set }
    
    func launch()
}
