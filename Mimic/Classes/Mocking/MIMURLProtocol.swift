//
//  MIMURLProtocol.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 31.12.2018.
//

import Foundation

class MIMURLProtocol<Finder: MockFinder>: URLProtocol {
    typealias MockSuite = Finder.MockSuite
    
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
        guard let session = Session<Finder>.shared else {
            client?.urlProtocol(self, didFailWithError: Error.noSession)
            return
        }
            
        let mockSuiteCollection: MockSuiteCollection<MockSuite>
            
        switch session.serializationResult {
        case .success(let collection):
            mockSuiteCollection = collection
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let baseUrl = request.url?.baseUrlString else {
            client?.urlProtocol(self, didFailWithError: Error.unidentifierUrl)
            return
        }
        
        guard let mockSuite = mockSuiteCollection[baseUrl] else {
            client?.urlProtocol(self, didFailWithError: Error.mockSuite(.notFound(baseUrl: baseUrl)))
            return
        }
        
        let mockRequest = mockSuite[request]
        
        guard let response = urlResponse(with: mockRequest) else {
            client?.urlProtocol(self, didFailWithError: Error.unidentifierUrl)
            return
        }
        
        let mockFinder = Finder(mockSuite: mockSuite)

        do {
            let mock = try mockFinder.findMock(for: mockRequest)

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: mock)
            client?.urlProtocolDidFinishLoading(self)
        } catch let error {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    open override func stopLoading() {
    }
}

extension MIMURLProtocol {
    private func urlResponse(with mockRequest: MockSuite.MockRequest) -> HTTPURLResponse? {
        guard let url = request.url else {
            return nil
        }
        
        var headers: [String: String] = [:]
        
        headers["Allow"] = request.httpMethod
        headers["Content-Type"] = request.value(forHTTPHeaderField: "Accept")
        headers["Date"] = getFakeServerTime()
        
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
    
    private func getFakeServerTime() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return formatter.string(from: Date())
    }
}
