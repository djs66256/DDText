//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// An attributed text builder. Easy to use and read.
@interface DDAttributedTextBuilder : NSObject

@property (nonatomic, readonly) NSAttributedString *NSAttributedString;
@property (nonatomic, readonly) NSDictionary<NSAttributedStringKey, id> *attributes;

@property (nonatomic, readonly) DDAttributedTextBuilder *(^appendString)(NSString * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^appendFormat)(NSString * nullable, ...);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^appendAttributedString)(NSAttributedString * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^appendAttachment)(NSTextAttachment * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^appendSpacing)(CGFloat);

/// Save current attributes. Editing after save() will recover when restore().
@property (nonatomic, readonly) DDAttributedTextBuilder *(^save)(void);
/// Restore previous attributes.
@property (nonatomic, readonly) DDAttributedTextBuilder *(^restore)(void);

/// Add all attributes in the dictionary.
@property (nonatomic, readonly) DDAttributedTextBuilder *(^addAttributes)(NSDictionary<NSAttributedStringKey, id> * nullable);
/// Set an attribute.
@property (nonatomic, readonly) DDAttributedTextBuilder *(^set)(NSAttributedStringKey, id nullable);
/// Remvoe an attribute.
@property (nonatomic, readonly) DDAttributedTextBuilder *(^remove)(NSAttributedStringKey);

// Set attributes

@property (nonatomic, readonly) DDAttributedTextBuilder *(^font)(UIFont * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^fontSize)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^boldFontSize)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^lightFontSize)(CGFloat) API_AVAILABLE(ios(8.2));

@property (nonatomic, readonly) DDAttributedTextBuilder *(^textColor)(UIColor * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^backgroundColor)(UIColor * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^ligature)(NSInteger);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^kern)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^strikethrough)(NSInteger);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^underlineStyle)(NSUnderlineStyle);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^strokeWidth)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^strokeColor)(UIColor * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^shadow)(NSShadow * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^textEffect)(NSString * nullable);

@property (nonatomic, readonly) DDAttributedTextBuilder *(^link)(id nullable);  // NSURL (preferred) or NSString
@property (nonatomic, readonly) DDAttributedTextBuilder *(^baselineOffset)(CGFloat);

@property (nonatomic, readonly) DDAttributedTextBuilder *(^underlineColor)(UIColor * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^strikethroughColor)(UIColor * nullable);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^obliqueness)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^expansion)(CGFloat);

@property (nonatomic, readonly) DDAttributedTextBuilder *(^writingDirection)(NSWritingDirectionFormatType) API_AVAILABLE(ios(9.0));
@property (nonatomic, readonly) DDAttributedTextBuilder *(^verticalGlyphForm)(NSInteger);

@property (nonatomic, readonly) DDAttributedTextBuilder *(^paragraph)(NSParagraphStyle * nullable);

// Set attributes in NSParagraphStyle.
// Will create a new NSParagraphStyle when not exists.

@property (nonatomic, readonly) DDAttributedTextBuilder *(^lineSpacing)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^paragraphSpacing)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^alignment)(NSTextAlignment);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^headIndent)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^tailIndent)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^firstLineHeadIndent)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^minimumLineHeight)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^maximumLineHeight)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^lineBreakMode)(NSLineBreakMode);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^baseWritingDirection)(NSWritingDirection);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^lineHeightMultiple)(CGFloat);
@property (nonatomic, readonly) DDAttributedTextBuilder *(^paragraphSpacingBefore)(CGFloat);

@end

static inline DDAttributedTextBuilder *DDAttributedTextBuilderDefault() {
    return [[DDAttributedTextBuilder alloc] init];
}

static inline DDAttributedTextBuilder *DDAttributedTextBuilderFromUILabel(UILabel *label) {
    return DDAttributedTextBuilderDefault()
    .font(label.font)
    .alignment(label.textAlignment)
    .textColor(label.textColor)
    .lineBreakMode(label.lineBreakMode);
}

NS_ASSUME_NONNULL_END
