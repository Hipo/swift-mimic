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
    
    open override class func requestIsCacheEquivalent(
        _ a: URLRequest,
        to b: URLRequest
    ) -> Bool {
        return false
    }
    
    open override func startLoading() {
        guard let session = Session<Serialization, Finder>.shared else {
            client?.urlProtocol(
                self,
                didFailWithError: Error.noSession
            )
            return
        }
            
        let mockSuite: Serialization.MockSuite
            
        switch session.mockSuiteResult {
        case .success(let aMockSuite):
            mockSuite = aMockSuite
        case .failure(let error):
            client?.urlProtocol(
                self,
                didFailWithError: error
            )
            return
        }
        
        let mockRequest = mockSuite[request]

        guard let response = urlResponse(with: mockRequest, for: request) else {
            client?.urlProtocol(
                self,
                didFailWithError: Error.unidentifierUrl
            )
            return
        }

        do {
            let mock = try Finder.findMock(for: mockRequest)

            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            client?.urlProtocol(
                self,
                didLoad: mock
            )
            client?.urlProtocolDidFinishLoading(self)
        } catch let error {
            client?.urlProtocol(
                self,
                didFailWithError: error
            )
        }
    }
    
    open override func stopLoading() {
    }
}

extension MIMURLProtocol {
    private func urlResponse(
        with mockRequest: Finder.MockRequest,
        for request: URLRequest
    ) -> HTTPURLResponse? {
        guard let url = request.url else {
            return nil
        }
        
        var headers: [String: String] = [:]
        
        headers["Allow"] = request.httpMethod
        headers["Content-Type"] = request.value(forHTTPHeaderField: "Accept")
        headers["Date"] = getServerTime()
        
        if let body = request.httpBody {
            headers["Content-Length"] = String(body.count)
        }
        
        return HTTPURLResponse(
            url: url,
            statusCode: mockRequest.responseStatusCode.rawValue,
            httpVersion: "HTTP/1.1",
            headerFields: headers
        )
    }
    
    private func getServerTime() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return formatter.string(from: Date())
    }
}
