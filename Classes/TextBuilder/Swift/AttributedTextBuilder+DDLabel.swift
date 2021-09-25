//
//  AttributedTextBuilder+DDLabel.swift
//  DDText
//
//  Created by daniel on 2021/9/25.
//

import Foundation

extension AttributedTextBuilder {
    
    @discardableResult
    public func DDHighlightedBackgroundColor(_ backgroundColor: UIColor?) -> AttributedTextBuilder {
        return set(.DDHighlightedBackgroundColorAttributeName, backgroundColor)
    }
    
    @discardableResult
    public func DDUserAction(_ action: @escaping (NSAttributedString)->Void) -> AttributedTextBuilder {
        return set(.DDUserActionAttributeName, DDLabelBlockUserAction(block: action))
    }
}
