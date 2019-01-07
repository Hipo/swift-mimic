//
//  String+Additions.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 7.01.2019.
//

import Foundation

extension String {
    func trimmed(_ characters: String) -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: characters))
    }
}
