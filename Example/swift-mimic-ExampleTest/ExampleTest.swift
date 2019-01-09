//
//  swift_mimic_ExampleTest.swift
//  swift-mimic-ExampleTest
//
//  Created by Taylan Pince on 2019-01-09.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import swift_mimic


enum Pat: String {
    case authenticate = "api/authenticate/"
}

extension Pat: PathConvertible {
    func toString() -> String {
        return rawValue
    }
}

extension XCUIApplication: MimicUIApplication {
    
}


class ExampleTest: XCTestCase {

    var app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false

        let suite = MIMMockSuite()
        
        let mockRequest = MIMMockRequest(path: Pat.authenticate)
        mockRequest.httpMethod = .post
        mockRequest.responseStatusCode = .failure(403)
        mockRequest.options = [.additionalPathComponents: "admin"]
        
        suite.append(mockRequest)
        
        let mockRequest1 = MIMMockRequest(path: "api/authenticate/3/")
        mockRequest1.httpMethod = .post
        mockRequest1.responseStatusCode = .failure(403)
        mockRequest1.options = [.additionalPathComponents: "user", .mockDeattached: true]
        
        suite.append(mockRequest1)
        
        try? MimicLauncher.launch(app, with: suite)

//        let text = try MIMMockSuiteSerialization.encode(suite)
//        let newMockSuite = try MIMMockSuiteSerialization.decode(text)
//
//        var req = URLRequest(url: URL(string: "http://moment.com/api/authenticate/")!)
//        req.httpMethod = "POST"
//        _ = mockRequest.isEqual(to: req)
//        print("")
//
//        try MimicLauncher.launch(App(), with: newMockSuite)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
