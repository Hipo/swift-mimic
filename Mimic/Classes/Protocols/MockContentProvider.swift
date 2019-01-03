//
//  MockDataProvider.swift
//  Avocare
//
//  Created by Göktuğ Berk Ulu on 24.09.2018.
//  Copyright © 2018 DocToc. All rights reserved.
//

import Foundation

public protocol MockContentProvider {
    
    func findContent(for mock: Mock) -> Data?
}
