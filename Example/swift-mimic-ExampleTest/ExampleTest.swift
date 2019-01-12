//
//  swift_mimic_ExampleTest.swift
//  swift-mimic-ExampleTest
//
//  Created by Taylan Pince on 2019-01-09.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import swift_mimic


extension XCUIApplication: MimicUIApplication {
    
}


enum MockPaths: String {
    case userRepos = "/repos"
}

extension MockPaths: PathConvertible {
    func toString() -> String {
        return rawValue
    }
}


class ExampleTest: XCTestCase {

    var app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false

        let suite = MIMMockSuite()
        
        let reposMock = MIMMockRequest(path: MockPaths.userRepos)
        suite.append(reposMock)

        try? MimicLauncher.launch(app, with: suite)
    }

    func testLoginAndRepoList() {
        let app = XCUIApplication()

        app.textFields["username"].tap()
        app.textFields["username"].typeText("taylan")

        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("test")
        
        app.buttons["login_button"].tap()

        let successText = app.otherElements.staticTexts["Success"]
        XCTAssert(successText.exists)
    }

}
