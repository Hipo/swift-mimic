//
//  ResponseReadingOptions.swift
//  swift-mimic
//
//  Created by Salih Karasuluoglu on 28.12.2018.
//

import Foundation

public struct ResponseReadingOptions: Codable {
    public typealias OptionType = Option
    public typealias ParameterType = String /// TODO: How to change needed parameter type???
    
    fileprivate typealias InnerType = Dictionary<OptionType, ParameterType>
    
    private var options: InnerType = [:]

    private init() {
    }
    
    private init<S>(_ sequence: S) where S: Sequence, S.Element == Element {
        self.init()
        sequence.forEach { options[$0.option] = $0.parameter }
    }
}

extension ResponseReadingOptions {
    public subscript (option: OptionType) -> Any? {
        return options[option]
    }
}

extension ResponseReadingOptions {
    public struct InnerIndex {
        fileprivate typealias InnerType = ResponseReadingOptions.InnerType.Index

        fileprivate let index: InnerType
        
        fileprivate init(_ index: InnerType) {
            self.index = index
        }
    }
}

extension ResponseReadingOptions {
    /// TODO: Think about what to add next. Request or body parameters???
    public enum Option: String, Codable {
        /// For additional folder structures which are not included in the path of the request, i.e. mocks for different user types.
        case additionalPathComponents
//        case noMockAttached
    }
}

extension ResponseReadingOptions: Sequence {
    public typealias Iterator = AnyIterator<Element>
    
    public func makeIterator() -> AnyIterator<Element> {
        var innerIterator = options.makeIterator()
        return AnyIterator { innerIterator.next() }
    }
}

extension ResponseReadingOptions: Collection {
    public typealias Index = InnerIndex
    public typealias Element = (option: OptionType, parameter: ParameterType)
    
    public var startIndex: Index {
        return Index(options.startIndex)
    }
    
    public var endIndex: Index {
        return Index(options.endIndex)
    }
    
    public func index(after i: Index) -> Index {
        let innerIndex = options.index(after: i.index)
        return Index(innerIndex)
    }
    
    public subscript (i: Index) -> Element {
        let innerElement = options[i.index]
        return (option: innerElement.key, parameter: innerElement.value)
    }
}

extension ResponseReadingOptions: ExpressibleByDictionaryLiteral {
    public typealias Key = OptionType
    public typealias Value = ParameterType
    
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(elements.map { (option: $0.0, value: $0.1) })
    }
}

extension ResponseReadingOptions: CustomStringConvertible {
    public var description: String {
        return options.description
    }
}

extension ResponseReadingOptions.Index: Comparable {
    public static func == (
        lhs: ResponseReadingOptions.Index,
        rhs: ResponseReadingOptions.Index
    ) -> Bool {
        return lhs.index == rhs.index
    }

    public static func < (
        lhs: ResponseReadingOptions.Index,
        rhs: ResponseReadingOptions.Index
    ) -> Bool {
        return lhs.index < rhs.index
    }
}
