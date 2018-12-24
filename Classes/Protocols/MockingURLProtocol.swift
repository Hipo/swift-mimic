//
//  MockingURLProtocol.swift
//  Avocare
//
//  Created by Göktuğ Berk Ulu on 10.09.2018.
//  Copyright © 2018 DocToc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MockingURLProtocol: URLProtocol {
    private struct PropertyKeys {
        static let handledByForwarderURLProtocol = "HandledByProxyURLProtocol"
    }
    
    lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            
            return configuration
        }()
        
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    var activeTask: URLSessionTask?
    
    public static let formatter = MockSuiteFormatter()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return URLProtocol.property(
            forKey: PropertyKeys.handledByForwarderURLProtocol,
            in: request) == nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard let headers = request.allHTTPHeaderFields else {
            return request
        }
        
        do {
            return try URLEncoding.default.encode(request, with: headers)
        } catch {
            return request
        }
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        guard let mockString = ProcessInfo.processInfo.environment[MockConstants.mockDataSuiteKey] else {
            return
        }
        
        guard let mockSuite = MockSuiteFormatter.mockSuite(from: mockString) else {
            return
        }
        
        var currentMock: Mock?
        
        for mock in mockSuite {
            guard var path = request.url?.path,
                let httpMethod = request.httpMethod else {
                return
            }
            
            if let lastCharacter = mock.path.last, lastCharacter == "/" {
                path += "/"
            }
            
            if mock.path == path && mock.httpMethod.rawValue == httpMethod.lowercased() {
                currentMock = mock
                break
            }
        }
        
        guard let mock = currentMock else {
            return
        }

        let result = MockingURLProtocol.formatter.getResult(for: request, and: mock)
        
        guard let response = result?.response,
            let data = result?.data else {
                client?.urlProtocolDidFinishLoading(self)
                return
        }
        
        client?.urlProtocol(
            self,
            didReceive: response,
            cacheStoragePolicy: URLCache.StoragePolicy.notAllowed
        )
        
        guard let urlRequest = request.urlRequest as NSURLRequest?,
            let urlRequestCopy = urlRequest.mutableCopy() as? NSMutableURLRequest else {
                return
        }
        
        URLProtocol.setProperty(true, forKey: PropertyKeys.handledByForwarderURLProtocol, in: urlRequestCopy)

        activeTask = session.dataTask(with: urlRequest as URLRequest)
        activeTask?.resume()

        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
}

// MARK: URLSessionDelegate

extension MockingURLProtocol: URLSessionDelegate {
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data) {
        
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?) {
        
        if let response = task.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        client?.urlProtocolDidFinishLoading(self)
    }
}
