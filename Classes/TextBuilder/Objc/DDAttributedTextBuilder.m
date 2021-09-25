//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import <objc/message.h>
#import "DDAttributedTextBuilder.h"

@interface DDSpacingInterceptorAttachment : NSTextAttachment
@property (nonatomic, assign) CGFloat spacing;
@end

@implementation DDSpacingInterceptorAttachment

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.image = [UIImage new];
    }
    return self;
}

- (CGRect)bounds {
    return CGRectMake(0, 0, _spacing, 1 /* min height */);
}

@end

@implementation DDAttributedTextBuilder {
    NSMutableArray<NSMutableDictionary<NSAttributedStringKey, id> *> *_attributesStack;
    NSMutableDictionary<NSAttributedStringKey, id> *_currentAttributes;
    NSMutableAttributedString *_attributedString;
    NSMutableParagraphStyle *_currentParagraphStyle;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _attributedString = [NSMutableAttributedString new];
        _currentAttributes = [NSMutableDictionary new];
    }
    return self;
}

- (NSAttributedString *)NSAttributedString {
    return _attributedString.copy;
}

- (NSDictionary<NSAttributedStringKey,id> *)attributes {
    return _currentAttributes.copy;
}

- (DDAttributedTextBuilder * _Nonnull (^)(NSString * _Nonnull))appendString {
    return ^DDAttributedTextBuilder *(NSString *string) {
        if (string.length) {
            NSAttributedString *text = [[NSAttributedString alloc] initWithString:string attributes:self->_currentAttributes];
            [self->_attributedString appendAttributedString:text];
        }
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(NSString * _Nonnull, ...))appendFormat {
    return ^DDAttributedTextBuilder *(NSString * _Nonnull fmt, ...) {
        if (fmt) {
            va_list list;
            va_start(list, fmt);
            NSString *string = [[NSString alloc] initWithFormat:fmt arguments:list];
            va_end(list);
            NSAttributedString *text = [[NSAttributedString alloc] initWithString:string attributes:self->_currentAttributes];
            [self->_attributedString appendAttributedString:text];
        }
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(NSAttributedString * _Nonnull))appendAttributedString {
    return ^DDAttributedTextBuilder *(NSAttributedString *text) {
        [self->_attributedString appendAttributedString:text];
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(NSTextAttachment * _Nonnull))appendAttachment {
    return ^DDAttributedTextBuilder *(NSTextAttachment *attachment) {
        NSMutableDictionary *dict = self->_currentAttributes.mutableCopy;
        dict[NSAttachmentAttributeName] = attachment;
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"\uFFFC" attributes:dict];
        [self->_attributedString appendAttributedString:text];
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(CGFloat))appendSpacing {
    return ^DDAttributedTextBuilder *(CGFloat spacing) {
        DDSpacingInterceptorAttachment *attachment = [DDSpacingInterceptorAttachment new];
        attachment.spacing = spacing;
        return self.appendAttachment(attachment);
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(void))save {
    return ^DDAttributedTextBuilder *() {
        if (self->_attributesStack == nil) {
            self->_attributesStack = [NSMutableArray new];
        }
        [self->_attributesStack addObject:self->_currentAttributes];
        // 从原来的属性上深拷贝一份，作为新的属性，这样就能继承之前的属性了。
        self->_currentAttributes = [self->_currentAttributes mutableCopy];
        self->_currentParagraphStyle = self->_currentAttributes[NSParagraphStyleAttributeName];
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(void))restore {
    return ^DDAttributedTextBuilder *() {
        if (self->_attributesStack.count > 0) {
            self->_currentAttributes = self->_attributesStack.lastObject;
            self->_currentParagraphStyle = self->_currentAttributes[NSParagraphStyleAttributeName];
            [self->_attributesStack removeLastObject];
        }
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(NSDictionary<NSAttributedStringKey, id> * _Nonnull))addAttributes {
    return ^DDAttributedTextBuilder *(NSDictionary<NSAttributedStringKey, id> * dict) {
        if (dict) {
            [self->_currentAttributes addEntriesFromDictionary:dict];
            NSParagraphStyle *style = dict[NSParagraphStyleAttributeName];
            if (style) {
                self->_currentParagraphStyle = style.mutableCopy;
                self->_currentAttributes[NSParagraphStyleAttributeName] = self->_currentParagraphStyle;
            }
        }
        return self;
    };
}

#define GetterDefine(Type, Name, Key)                       \
- (DDAttributedTextBuilder * _Nonnull (^)(Type *))Name {    \
    return ^DDAttributedTextBuilder *(Type *value) {        \
        self->_currentAttributes[Key] = value;              \
        return self;                                        \
    };                                                      \
}                                                           \

#define GetterDefineBaseType(Type, Name, Key)               \
- (DDAttributedTextBuilder * _Nonnull (^)(Type))Name {      \
    return ^DDAttributedTextBuilder *(Type value) {         \
        self->_currentAttributes[Key] = @(value);           \
        return self;                                        \
    };                                                      \
}                                                           \

GetterDefine(UIFont, font, NSFontAttributeName)

- (DDAttributedTextBuilder * _Nonnull (^)(CGFloat))fontSize {
    return ^DDAttributedTextBuilder *(CGFloat size) {
        self->_currentAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:size];
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(CGFloat))boldFontSize {
    return ^DDAttributedTextBuilder *(CGFloat size) {
        self->_currentAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:size];
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(CGFloat))lightFontSize API_AVAILABLE(ios(8.2)) {
    return ^DDAttributedTextBuilder *(CGFloat size) {
        self->_currentAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:size weight:UIFontWeightLight];
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(NSParagraphStyle * _Nonnull))paragraph {
    return ^DDAttributedTextBuilder *(NSParagraphStyle *style) {
        self->_currentParagraphStyle = style.mutableCopy;
        self->_currentAttributes[NSParagraphStyleAttributeName] = self->_currentParagraphStyle;
        return self;
    };
}

- (NSMutableParagraphStyle *)currentParagraphStyle {
    if (_currentParagraphStyle == nil) {
        _currentParagraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        _currentAttributes[NSParagraphStyleAttributeName] = _currentParagraphStyle;
    }
    return _currentParagraphStyle;
}

#define ParagraphStyleGetterDefine(Type, Name)          \
- (DDAttributedTextBuilder * _Nonnull (^)(Type))Name {  \
    return ^DDAttributedTextBuilder *(Type value) {     \
        self.currentParagraphStyle.Name = value;        \
        return self;                                    \
    };                                                  \
}                                                       \

ParagraphStyleGetterDefine(CGFloat, lineSpacing)
ParagraphStyleGetterDefine(CGFloat, paragraphSpacing)
ParagraphStyleGetterDefine(NSTextAlignment, alignment)
ParagraphStyleGetterDefine(CGFloat, headIndent)
ParagraphStyleGetterDefine(CGFloat, tailIndent)
ParagraphStyleGetterDefine(CGFloat, firstLineHeadIndent)
ParagraphStyleGetterDefine(CGFloat, minimumLineHeight)
ParagraphStyleGetterDefine(CGFloat, maximumLineHeight)
ParagraphStyleGetterDefine(NSLineBreakMode, lineBreakMode)
ParagraphStyleGetterDefine(NSWritingDirection, baseWritingDirection)
ParagraphStyleGetterDefine(CGFloat, lineHeightMultiple)
ParagraphStyleGetterDefine(CGFloat, paragraphSpacingBefore)

GetterDefine(UIColor, textColor, NSForegroundColorAttributeName)
GetterDefine(UIColor, backgroundColor, NSBackgroundColorAttributeName)

GetterDefineBaseType(NSInteger, ligature, NSLigatureAttributeName)
GetterDefineBaseType(CGFloat, kern, NSKernAttributeName)
GetterDefineBaseType(NSInteger, strikethrough, NSStrikethroughStyleAttributeName)
GetterDefineBaseType(NSUnderlineStyle, underlineStyle, NSUnderlineStyleAttributeName)
GetterDefineBaseType(CGFloat, strokeWidth, NSStrokeWidthAttributeName)
GetterDefine(UIColor, strokeColor, NSStrokeColorAttributeName)
GetterDefine(NSShadow, shadow, NSShadowAttributeName)
GetterDefine(NSString, textEffect, NSTextEffectAttributeName)

//GetterDefine(NSTextAttachment, attachment, NSAttachmentAttributeName)
- (DDAttributedTextBuilder * _Nonnull (^)(id _Nonnull))link {
    return ^DDAttributedTextBuilder *(id value) {
        self->_currentAttributes[NSLinkAttributeName] = value;
        return self;
    };
}
GetterDefineBaseType(CGFloat, baselineOffset, NSBaselineOffsetAttributeName)

GetterDefine(UIColor, underlineColor, NSUnderlineColorAttributeName)
GetterDefine(UIColor, strikethroughColor, NSStrikethroughColorAttributeName)
GetterDefineBaseType(CGFloat, obliqueness, NSObliquenessAttributeName)
GetterDefineBaseType(CGFloat, expansion, NSExpansionAttributeName)

GetterDefineBaseType(NSWritingDirectionFormatType, writingDirection, NSWritingDirectionAttributeName)
GetterDefineBaseType(NSInteger, verticalGlyphForm, NSVerticalGlyphFormAttributeName)

- (DDAttributedTextBuilder * _Nonnull (^)(NSAttributedStringKey _Nonnull, id _Nonnull))set {
    return ^DDAttributedTextBuilder *(NSAttributedStringKey key, id value) {
        NSParameterAssert(key != nil);
        self->_currentAttributes[key] = value;
        return self;
    };
}

- (DDAttributedTextBuilder * _Nonnull (^)(NSAttributedStringKey _Nonnull))remove {
    return ^DDAttributedTextBuilder *(NSAttributedStringKey key) {
        NSParameterAssert(key != nil);
        self->_currentAttributes[key] = nil;
        return self;
    };
}

@end
