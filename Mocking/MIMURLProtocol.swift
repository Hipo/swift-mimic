//
//  MIMURLProtocol.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

class MIMURLProtocol<
  Finder: MockFinder,
  Serialization: MockSuiteSerialization
>: URLProtocol where Finder.MockRequest == Serialization.MockSuite.MockRequest {
    open override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    open override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    open override func startLoading() {
        do {
            let mockSuiteAsText = try MimicProcess.current.getMockSuiteAsText()
            let mockSuite = try Serialization.decode(mockSuiteAsText)

            guard let mockRequest = mockSuite[request] else {
                /// TODO: Call the relevant URL protocol method.
                return
            }
            
            let mock = try Finder.findMock(for: mockRequest)
            /// TODO: Create a propert response object.
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: mock)
            client?.urlProtocolDidFinishLoading(self)
        } catch let error {
            print("Error \(error.localizedDescription)")
            /// TODO: Call the relevant URL protocol method.
        }
    }
    
    open override func stopLoading() {
    }
}
