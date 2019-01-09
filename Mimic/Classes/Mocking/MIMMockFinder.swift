//
//  MIMMockFinder.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 2.01.2019.
//

import Foundation

open class MIMMockFinder {
    public static var mainDirectoryUrl: URL {
        guard let url = Bundle.main.url(
            forResource: "Mocks",
            withExtension: "bundle"
        ) else {
            fatalError("Mocks not found.")
        }
        return url
    }
}

extension MIMMockFinder: MockFinder {
    public typealias MockRequest = MIMMockRequest
}
