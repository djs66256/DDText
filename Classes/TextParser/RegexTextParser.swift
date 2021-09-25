//
//  RegexTextParser.swift
//  DDText
//
//  Created by daniel on 2021/9/25.
//

import UIKit

public class RegexTextParser {
    public let regex: NSRegularExpression
    
    init(regex: NSRegularExpression) {
        self.regex = regex
    }
    
    public func parse(string: String, _ callback:(NSRange)->Void) {
        guard string.count > 0 else {
            return
        }
        
        regex.enumerateMatches(in: string, options: .reportProgress, range: NSRange(location: 0, length: string.count)) { (result, _, _) in
            if let range = result?.range, range.length > 0 {
                callback(range)
            }
        }
    }
}
