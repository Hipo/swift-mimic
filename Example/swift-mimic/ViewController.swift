//
//  ViewController.swift
//  swift-mimic
//
//  Created by goktugberkulu on 12/24/2018.
//  Copyright (c) 2018 goktugberkulu. All rights reserved.
//

import UIKit
import swift_mimic

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {

            let suite = MIMMockSuite()
        
            let mockRequest = MIMMockRequest(path: "api/authenticate/")
            mockRequest.httpMethod = .post
            mockRequest.responseStatusCode = .failure(403)
            mockRequest.options = [.additionalPathComponents: "admin"]

            let data = try JSONEncoder().encode(mockRequest)
            let dataString = String(data: data, encoding: .utf8)
            let returnData = dataString?.data(using: .utf8)
            
            let returnMockRequest = try JSONDecoder().decode(MIMMockRequest.self, from: returnData!)
        
            suite.append(mockRequest)
            let text = try MIMMockSuiteSerialization.encode(suite)
            print("")
        } catch let err {
            print("\(err.localizedDescription)")
        }
    }
}
