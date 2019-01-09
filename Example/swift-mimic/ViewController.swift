//
//  ViewController.swift
//  swift-mimic
//
//  Created by goktugberkulu on 12/24/2018.
//  Copyright (c) 2018 goktugberkulu. All rights reserved.
//

import UIKit
import swift_mimic

class App: MimicUIApplication {
    var launchArguments: [String] = []
    var launchEnvironment: [String : String] = [:]
    
    func launch() {
    }
}

enum Pat: String {
    case authenticate = "api/authenticate/"
}

extension Pat: PathConvertible {
    func toString() -> String {
        return rawValue
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {

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
            
            try MimicLauncher.launch(App(), with: suite)
            
            let text = try MIMMockSuiteSerialization.encode(suite)
            let newMockSuite = try MIMMockSuiteSerialization.decode(text)
            
            var req = URLRequest(url: URL(string: "http://moment.com/api/authenticate/")!)
            req.httpMethod = "POST"
            let isEqual = mockRequest.isEqual(to: req)
            print("")
            
            try MimicLauncher.launch(App(), with: newMockSuite)
        } catch let err {
            print("\(err.localizedDescription)")
        }
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "test", ofType: "bundle")
        
    }
}
