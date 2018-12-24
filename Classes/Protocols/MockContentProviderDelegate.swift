//
//  MockContentProviderDelegate.swift
//  Avocare
//
//  Created by Göktuğ Berk Ulu on 12.10.2018.
//  Copyright © 2018 DocToc. All rights reserved.
//

import Foundation

protocol MockContentProviderDelegate: class {
    
    var contentProvider: MockContentProvider { get }
    func result(for request: URLRequest, and mock: Mock) -> (response: HTTPURLResponse, data: Data)?
}

extension MockContentProviderDelegate {
    
    var contentProvider: MockContentProvider {
        return HIPMockContentProvider()
    }
    
    func result(
        for request: URLRequest,
        and mock: Mock)
        -> (response: HTTPURLResponse, data: Data)? {
        
        guard let url = request.url else {
            return nil
        }
        
        guard let response = response(with: url),
            let data = contentProvider.findContent(for: mock) else {
                return nil
        }
        
        return (response, data)
    }
    
    private func response(with url: URL) -> HTTPURLResponse? {
        let headers = [
            "Content-Type": "application/json",
            "Server": "nginx/1.10.3 (Ubuntu)",
            "allow": "POST, OPTIONS",
            "x-frame-options": "SAMEORIGIN",
            "Date": now
        ]
        
        guard let response = HTTPURLResponse(url: url,
                                             statusCode: 200,
                                             httpVersion: "HTTP/1.1",
                                             headerFields: headers) else {
                                                return nil
        }
        
        return response
    }
    
    private var now: String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "E, d MMM yyyy MM:dd:yyyy"
        
        let now = formatter.string(from: Date())
        
        return now
    }
}
