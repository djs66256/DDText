//
//  CompositeTextParser.swift
//  DDText
//
//  Created by daniel on 2021/9/25.
//

import UIKit

public protocol EmojAttachmentGenerator {
    func generate(text: Substring) -> DDViewAttachment
}

public struct CompositeTextParserConfiguration {
    public let engine: TextParserRegexEngine
    
    public var defaultAttributes: [NSAttributedString.Key: Any]?
    
    public var atUserAttributes: [NSAttributedString.Key: Any]?
    public var emailAttributes: [NSAttributedString.Key: Any]?
    public var linkAttributes: [NSAttributedString.Key: Any]?
    public var topicAttributes: [NSAttributedString.Key: Any]?
    public var emojViewGenerator: EmojAttachmentGenerator?
    
    public var atUserParserEnabled = true
    public var emailParserEnabled = true
    public var linkParserEnabled = true
    public var topicParserEnabled = true
    public var emojParserEnabled = true
    
    public init() {
        self.engine = TextParserRegexEngine.defaultEngine
    }
    public init(engine: TextParserRegexEngine) {
        self.engine = engine
    }
}

public class CompositeTextParser {
    public let config: CompositeTextParserConfiguration
    
    lazy var atUserParser = RegexTextParser(regex: config.engine.atUserRegex)
    lazy var emailParser = RegexTextParser(regex: config.engine.emailRegex)
    lazy var linkParser = RegexTextParser(regex: config.engine.linkRegex)
    lazy var topicParser = RegexTextParser(regex: config.engine.topicRegex)
    lazy var emojParser = RegexTextParser(regex: config.engine.emojRegex)
    
    public init(config: CompositeTextParserConfiguration) {
        self.config = config
    }

    public func parse(string: String, _ callback: (NSAttributedString)->Void) {
        guard string.count > 0 else {
            return
        }
        
        let attributedString = NSMutableAttributedString(string: string, attributes: config.defaultAttributes)
        if config.atUserParserEnabled, let attributes = config.atUserAttributes {
            atUserParser.parse(string: string) { (range) in
                attributedString.addAttributes(attributes, range: range)
            }
        }
        if config.emailParserEnabled, let attributes = config.emailAttributes {
            emailParser.parse(string: string) { (range) in
                attributedString.addAttributes(attributes, range: range)
            }
        }
        if config.linkParserEnabled, let attributes = config.linkAttributes {
            linkParser.parse(string: string) { (range) in
                attributedString.addAttributes(attributes, range: range)
            }
        }
        if config.topicParserEnabled, let attributes = config.topicAttributes {
            topicParser.parse(string: string) { (range) in
                attributedString.addAttributes(attributes, range: range)
            }
        }
        if config.emojParserEnabled, let emojView = config.emojViewGenerator {
            var ranges: [NSRange] = []
            emojParser.parse(string: string) { (range) in
                ranges.append(range)
            }
            for range in ranges.reversed() {
                let start = string.index(string.startIndex, offsetBy: range.location)
                let end = string.index(string.startIndex, offsetBy: range.length + range.location)
                let emojString = string[start..<end]
                
                var attrs = config.defaultAttributes ?? [:]
                let attachment = emojView.generate(text: emojString)
                attrs[.attachment] = attachment
                if let font = attrs[.font] as? UIFont {
                    attrs[.baselineOffset] = font.descender
                }
                let text = NSAttributedString(string: "\u{FFFC}", attributes: attrs)
                attributedString.replaceCharacters(in: range, with: text)
            }
        }
        
        callback(attributedString)
    }
}
