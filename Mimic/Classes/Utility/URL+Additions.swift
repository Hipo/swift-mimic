//
//  URL+Additions.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 14.01.2019.
//

import Foundation

extension URL {
    var baseUrlString: String? {
        var components = URLComponents()
        components.scheme = scheme
        components.user = user
        components.password = password
        components.host = host
        components.port = port
        return components.string
    }
}
