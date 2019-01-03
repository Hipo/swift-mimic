//
//  MIMURLProtocol.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

class MIMURLProtocol<
  Serialization: MockSuiteSerialization,
  Finder: MockFinder
>: URLProtocol where Serialization.MockSuite.MockRequest == Finder.MockRequest {
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
        guard let session = Session<Serialization, Finder>.shared else {
            client?.urlProtocol(self, didFailWithError: Error.noSessionLaunched)
            return
        }
            
        let mockSuite: Serialization.MockSuite
            
        switch session.mockSuiteResult {
        case .success(let aMockSuite):
            mockSuite = aMockSuite
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        guard let mockRequest = mockSuite[request] else {
            /// TODO: Call the relevant URL protocol method.
            return
        }

        do {
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
