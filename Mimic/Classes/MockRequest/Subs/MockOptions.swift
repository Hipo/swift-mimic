//
//  MockOptions.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 28.12.2018.
//

import Foundation

public struct MockOptions: Codable {
    private var values = OptionValues()

    private init() {
    }
}

extension MockOptions {
    public func value<T>(for option: Option) -> T? {
        switch option {
        case .additionalPathComponents:
            return values.additionalPathComponents as? T
        case .mockDeattached:
            return values.mockDeattached as? T
        }
    }
}

extension MockOptions {
    struct OptionValues: Codable {
        var additionalPathComponents: String?
        var mockDeattached: Bool?
    }
}

extension MockOptions {
    public enum Option: String, Codable {
        /// For additional folder structures which are not included in the path of the request, i.e. mocks for different user types.
        /// Accepts a string value similar to the url path pattern, i.e. admin/{admin_id}/.
        case additionalPathComponents
        /// In order to by-pass mock finding step, instead returns an empty mock placeholder.
        /// Accepts a boolean value.
        case mockDeattached
    }
}

extension MockOptions: ExpressibleByDictionaryLiteral {
    public typealias Key = Option
    public typealias Value = Any
    
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        
        elements.forEach { (option, value) in
            var isTypeConversionFailed = false
            
            switch option {
            case .additionalPathComponents:
                let theValue = value as? String
                values.additionalPathComponents = theValue

                isTypeConversionFailed = theValue == nil
            case .mockDeattached:
                let theValue = value as? Bool
                values.mockDeattached = theValue
                
                isTypeConversionFailed = theValue == nil
            }
            
            if isTypeConversionFailed {
                assertionFailure("Should get a value with the correct type for the option: \(option.rawValue)")
            }
        }
    }
}

extension MockOptions: CustomStringConvertible {
    public var description: String {
        return [
            Option.additionalPathComponents,
            Option.mockDeattached
        ].reduce("") { (r, option) in
            let theValue: Any? = value(for: option)
            return theValue.map({ r + "\n\t\(option.rawValue): \($0)" }) ?? r
        }
    }
}
