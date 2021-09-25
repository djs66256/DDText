//
//  AttributedTextBuilder.swift
//  DDText
//
//  Created by daniel on 2021/9/25.
//

import Foundation

/// An attributed text builder. Easy to use and read.
public class AttributedTextBuilder {
    private var attributes: [NSAttributedString.Key: Any] = [:]
    private var attributesStack: [[NSAttributedString.Key: Any]] = []
    private var attributedText = NSMutableAttributedString()
    private var paragraphStyle: NSMutableParagraphStyle?
    
    public init() {
    }
    public convenience init(label: UILabel) {
        self.init()
        self.font(label.font)
            .alignment(label.textAlignment)
            .textColor(label.textColor)
            .lineBreakMode(label.lineBreakMode)
    }
    
    public func buildAttributedString() -> NSAttributedString {
        return NSAttributedString(attributedString: attributedText)
    }
    
    public func buildAttributes() -> [NSAttributedString.Key: Any] {
        let copy = attributes
        return copy
    }

    /// Save current attributes. Editing after save() will recover when restore().
    @discardableResult
    public func save() -> AttributedTextBuilder {
        saveParagraphStyle()
        let copy = attributes
        attributesStack.append(copy)
        
        return self
    }

    /// Restore previous attributes.
    @discardableResult
    public func restore() -> AttributedTextBuilder {
        attributes = attributesStack.removeLast()
        restoreParagrphStyle()
        return self
    }
    
    private func saveParagraphStyle() {
        attributes[.paragraphStyle] = paragraphStyle?.copy()
    }
    private func restoreParagrphStyle() {
        let style = attributes[.paragraphStyle] as? NSParagraphStyle
        paragraphStyle = style?.mutableCopy() as? NSMutableParagraphStyle
    }
    
    @discardableResult
    public func append(string: String?) -> AttributedTextBuilder {
        if let string = string, string.count > 0 {
            let txt = NSAttributedString(string: string, attributes: attributes)
            saveParagraphStyle()
            attributedText.append(txt)
        }
        return self
    }
    
    @discardableResult
    public func append(attributedString: NSAttributedString?) -> AttributedTextBuilder {
        if let txt = attributedString, txt.length > 0 {
            saveParagraphStyle()
            attributedText.append(txt)
        }
        return self
    }
    
    @discardableResult
    public func append(attachment: NSTextAttachment?) -> AttributedTextBuilder {
        if let attachment = attachment {
            saveParagraphStyle()
            var attrs = attributes
            attrs[.attachment] = attachment
            let txt = NSAttributedString(string: "\u{FFFC}", attributes: attrs)
            attributedText.append(txt)
        }
        return self
    }
    
    /// We can custom spacing width by attachment.
    private class SpacingAttachment : NSTextAttachment {
        init(spacing: CGFloat) {
            super.init(data: nil, ofType: nil)
            self.image = UIImage()
            self.bounds = CGRect(x: 0, y: 0, width: spacing, height: 1 /* min height */)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    @discardableResult
    public func append(spacing: CGFloat) -> AttributedTextBuilder {
        append(attachment: SpacingAttachment(spacing: spacing))
        return self
    }

    /// Add all attributes in the dictionary.
    @discardableResult
    public func add(attributes: [NSAttributedString.Key: Any]?) -> AttributedTextBuilder {
        if let attributes = attributes {
            self.attributes.merge(attributes, uniquingKeysWith: {(_, other) in other})
        }
        return self
    }

    /// Set an attribute.
    @discardableResult
    public func set(_ key: NSAttributedString.Key, _ object: Any?) -> AttributedTextBuilder {
        attributes[key] = object
        return self
    }

    /// Remvoe an attribute.
    @discardableResult
    public func remove(_ key: NSAttributedString.Key) -> AttributedTextBuilder {
        attributes.removeValue(forKey: key)
        return self
    }

    // Set attributes
    
    @discardableResult
    public func font(_ font: UIFont?) -> AttributedTextBuilder {
        attributes[.font] = font
        return self
    }
    @discardableResult
    public func systemFont(ofSize: CGFloat) -> AttributedTextBuilder {
        return self.font(.systemFont(ofSize: ofSize))
    }
    @available(iOS 8.2, *)
    @discardableResult
    public func systemFont(ofSize: CGFloat, weight: UIFont.Weight) -> AttributedTextBuilder {
        return self.font(.systemFont(ofSize: ofSize, weight: weight))
    }
    @discardableResult
    public func boldSystemFont(ofSize: CGFloat) -> AttributedTextBuilder {
        return self.font(.boldSystemFont(ofSize: ofSize))
    }
    
    @discardableResult
    public func textColor(_ textColor: UIColor?) -> AttributedTextBuilder {
        attributes[.foregroundColor] = textColor
        return self
    }
    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor?) -> AttributedTextBuilder {
        attributes[.backgroundColor] = backgroundColor
        return self
    }
    @discardableResult
    public func ligature(_ ligature: NSInteger) -> AttributedTextBuilder {
        attributes[.ligature] = ligature
        return self
    }
    @discardableResult
    public func kern(_ kern: CGFloat) -> AttributedTextBuilder {
        attributes[.kern] = kern
        return self
    }
    @discardableResult
    public func strikethrough(_ strikethrough: NSInteger) -> AttributedTextBuilder {
        attributes[.strikethroughStyle] = strikethrough
        return self
    }
    @discardableResult
    public func underlineStyle(_ underlineStyle: NSUnderlineStyle) -> AttributedTextBuilder {
        attributes[.underlineStyle] = underlineStyle
        return self
    }
    @discardableResult
    public func strokeWidth(_ strokeWidth: CGFloat) -> AttributedTextBuilder {
        attributes[.strokeWidth] = strokeWidth
        return self
    }
    @discardableResult
    public func strokeColor(_ strokeColor: UIColor?) -> AttributedTextBuilder {
        attributes[.strokeColor] = strokeColor
        return self
    }
    @discardableResult
    public func shadow(_ shadow: NSShadow?) -> AttributedTextBuilder {
        attributes[.shadow] = shadow
        return self
    }
    @discardableResult
    public func textEffect(_ textEffect: String?) -> AttributedTextBuilder {
        attributes[.textEffect] = textEffect
        return self
    }
    
    @discardableResult
    public func link(_ link: String?) -> AttributedTextBuilder {
        attributes[.link] = link
        return self
    }
    @discardableResult
    public func link(_ link: URL?) -> AttributedTextBuilder {
        attributes[.link] = link
        return self
    }
    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat) -> AttributedTextBuilder {
        attributes[.baselineOffset] = baselineOffset
        return self
    }
    
    @discardableResult
    public func underlineColor(_ underlineColor: UIColor?) -> AttributedTextBuilder {
        attributes[.underlineColor] = underlineColor
        return self
    }
    @discardableResult
    public func strikethroughColor(_ strikethroughColor: UIColor?) -> AttributedTextBuilder {
        attributes[.strikethroughColor] = strikethroughColor
        return self
    }
    @discardableResult
    public func obliqueness(_ obliqueness: CGFloat) -> AttributedTextBuilder {
        attributes[.obliqueness] = obliqueness
        return self
    }
    @discardableResult
    public func expansion(_ expansion: CGFloat) -> AttributedTextBuilder {
        attributes[.expansion] = expansion
        return self
    }
    
    @available(iOS 9.0, *)
    @discardableResult
    public func writingDirection(_ writingDirection: NSWritingDirectionFormatType) -> AttributedTextBuilder {
        attributes[.writingDirection] = writingDirection
        return self
    }
    @discardableResult
    public func verticalGlyphForm(_ verticalGlyphForm: NSInteger) -> AttributedTextBuilder {
        attributes[.verticalGlyphForm] = verticalGlyphForm
        return self
    }
    
    @discardableResult
    public func paragraph(_ paragraph: NSParagraphStyle?) -> AttributedTextBuilder {
        self.paragraphStyle = paragraph?.mutableCopy() as? NSMutableParagraphStyle
        return self
    }

    // Set attributes in NSParagraphStyle.
    // Will create a new NSParagraphStyle when not exists.

    private func ensureParagraphStyle() -> NSMutableParagraphStyle {
        if paragraphStyle == nil {
            paragraphStyle = NSMutableParagraphStyle()
        }
        return paragraphStyle!
    }
    
    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        return self
    }
    @discardableResult
    public func paragraphSpacing(_ paragraphSpacing: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.paragraphSpacing = paragraphSpacing
        return self
    }
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.alignment = alignment
        return self
    }
    @discardableResult
    public func headIndent(_ headIndent: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.headIndent = headIndent
        return self
    }
    @discardableResult
    public func tailIndent(_ tailIndent: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.tailIndent = tailIndent
        return self
    }
    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.minimumLineHeight = minimumLineHeight
        return self
    }
    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.maximumLineHeight = maximumLineHeight
        return self
    }
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        return self
    }
    @discardableResult
    public func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.baseWritingDirection = baseWritingDirection
        return self
    }
    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        return self
    }
    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> AttributedTextBuilder {
        let paragraphStyle = ensureParagraphStyle()
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
}
