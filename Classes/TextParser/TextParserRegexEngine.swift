//
//  TextParserRegexEngine.swift
//  DDText
//
//  Created by daniel on 2021/9/25.
//

import UIKit

public class TextParserRegexEngine {
    
    public var atUserRegex: NSRegularExpression   // @Daniel
    public var emailRegex: NSRegularExpression    // djs66256@163.com
    public var emojRegex: NSRegularExpression     // [哈哈大笑]
    public var linkRegex: NSRegularExpression     // https://github.com/djs66256
    public var topicRegex: NSRegularExpression    // #OpenSource#
    
    public init(atUserRegex: NSRegularExpression,
         emailRegex: NSRegularExpression,
         emojRegex: NSRegularExpression,
         linkRegex: NSRegularExpression,
         topicRegex: NSRegularExpression) {
        self.atUserRegex = atUserRegex
        self.emailRegex = emailRegex
        self.emojRegex = emojRegex
        self.linkRegex = linkRegex
        self.topicRegex = topicRegex
    }
    
    public static let defaultEngine: TextParserRegexEngine = {
        let engine = TextParserRegexEngine(
            atUserRegex: try! NSRegularExpression(pattern: "@[^：:\\s@]+", options: .allowCommentsAndWhitespace),
            emailRegex: try! NSRegularExpression(pattern: "[A-Za-z0-9-_\u{4e00}-\u{9fa5}]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+", options: .allowCommentsAndWhitespace),
            emojRegex: try! NSRegularExpression(pattern: "\\[[\\S]+?\\]", options: .allowCommentsAndWhitespace),
            linkRegex: try! NSRegularExpression(pattern: "[-a-zA-Z0-9@:%_+.~#?&//=]{2,256}\\.[a-z]{2,4}\\b([-a-zA-Z0-9@:%_+.~#?&//=]*)?", options: .init(rawValue: 0)),
            topicRegex: try! NSRegularExpression(pattern: "\\#[^\\#]+\\#", options: .allowCommentsAndWhitespace))
        
        return engine
    }()

}
