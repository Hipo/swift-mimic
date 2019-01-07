//
//  MIMMockFinder.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 2.01.2019.
//

import Foundation

open class MIMMockFinder {
    public static var mainDirectoryUrl: URL {
        return Bundle.main.bundleURL.appendingPathComponent("Mocks", isDirectory: true)
    }
}

extension MIMMockFinder: MockFinder {
    public typealias MockRequest = MIMMockRequest
}
