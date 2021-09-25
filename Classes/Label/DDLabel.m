//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import "DDLabel.h"
#import "DDViewAttachment.h"

const NSAttributedStringKey DDUserActionAttributeName = @"DDUserActionAttributeName";
const NSAttributedStringKey DDHighlightedBackgroundColorAttributeName = @"DDHighlightedBackgroundColorAttributeName";
const NSAttributedStringKey DDHighlightedForegroundColorAttributeName = @"DDHighlightedForegroundColorAttributeName";


@interface DDLabel () <NSLayoutManagerDelegate> {
    NSAttributedString *_attributedText;
    
    NSTextStorage *_textStorage;
    NSTextContainer *_textContainer;
    CGPoint _textOrigin;
    NSLayoutManager *_layoutManager;
    
    BOOL _needsUpdateLayoutManager;
    NSMapTable<NSTextAttachment *, UIView *> *_attachViews;
}

@property (nonatomic, assign, getter=isTracking) BOOL tracking;

- (void)findUserAction:(id<DDLabelUserAction> *)userAction range:(NSRange *)range withTouch:(UITouch *)touch;
@end

@interface DDLabelTapGestureRecognizer () {
    @public
    NSRange _trackingCharactersRange;
    id<DDLabelUserAction> _trackingUserAction;
}

@end

@implementation DDLabelTapGestureRecognizer

- (DDLabel *)label {
    return (DDLabel *)self.view;
}

- (void)setState:(UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateChanged) {
        return;
    }
    [super setState:state];
    if (state == UIGestureRecognizerStateBegan) {
        self.label.tracking = YES;
    }
    else {
        self.label.tracking = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        UITouch *touch = touches.anyObject;

        id<DDLabelUserAction> userAction = nil;
        [self.label findUserAction:&userAction range:&_trackingCharactersRange withTouch:touch];
        if (userAction) {
            _trackingUserAction = userAction;
            self.state = UIGestureRecognizerStateBegan;
        }
        else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1 && self.state == UIGestureRecognizerStateBegan) {
        UITouch *touch = touches.anyObject;

        id<DDLabelUserAction> userAction = nil;
        [self.label findUserAction:&userAction range:&_trackingCharactersRange withTouch:touch];
        if (userAction != _trackingUserAction) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStateBegan) {
        
        if (touches.count == 1) {
            UITouch *touch = touches.anyObject;
            
            id<DDLabelUserAction> userAction = nil;
            [self.label findUserAction:&userAction range:&_trackingCharactersRange withTouch:touch];
            if (userAction == _trackingUserAction) {
                self.state = UIGestureRecognizerStateRecognized;
                NSAttributedString *trackingString = [self.label.attributedText attributedSubstringFromRange:_trackingCharactersRange];
                [userAction invokeWithAttributedString:trackingString];
            }
            else {
                self.state = UIGestureRecognizerStateFailed;
            }
        }
    }
}

@end

@implementation DDLabel
@dynamic text, font, textColor, shadowColor, shadowOffset, textAlignment, userInteractionEnabled;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _attachViews = [NSMapTable strongToStrongObjectsMapTable];
        _textStorage = [[NSTextStorage alloc] init];
        
        _layoutManager = [self buildLayoutManagerFromCurrentContext];
        [_textStorage addLayoutManager:_layoutManager];
        
        _textContainer = [self buildTextContainerFromCurrentContext];
        [_layoutManager addTextContainer:_textContainer];
        
        _tapGestureRecognizer = [DDLabelTapGestureRecognizer new];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return self;
}

- (void)setTextStorage:(NSTextStorage *)textStorage {
    _textStorage = textStorage;
    
    _layoutManager = _textStorage.layoutManagers.firstObject;
    if (!_layoutManager) {
       _layoutManager = [self buildLayoutManagerFromCurrentContext];
       [_textStorage addLayoutManager:_layoutManager];
    }
    _layoutManager.delegate = self;
    
    _textContainer = _layoutManager.textContainers.firstObject;
    if (!_textContainer) {
        _textContainer = [self buildTextContainerFromCurrentContext];
        [_layoutManager addTextContainer:_textContainer];
    }
    _attributedText = _textStorage;
    
    [self clearAttachViews];
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (NSAttributedString *)attributedText {
    return _attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText != attributedText) {
        _attributedText = attributedText.copy;
        
        [self invalidateTextStorageClearViews];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)invalidateTextStorageClearViews {
    [self clearAttachViews];
    
    NSUInteger length = _textStorage.length;
    if (_attributedText) {
        [_textStorage replaceCharactersInRange:NSMakeRange(0, length) withAttributedString:_attributedText];
    }
    else {
        [_textStorage deleteCharactersInRange:NSMakeRange(0, length)];
    }

    // 在最后一行是\n的时候，numberOfLines会不起作用，UILabel中似乎是对这种场景做了特殊处理的，这里也做同样的处理
    NSString *str = _textStorage.string;
    NSCharacterSet *newLine = [NSCharacterSet newlineCharacterSet];
    unichar lastChar = [str characterAtIndex:str.length - 1];
    if ([newLine characterIsMember:lastChar]) {
        __auto_type attrs = [_textStorage attributesAtIndex:_textStorage.length - 1 effectiveRange:nil];
        [_textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrs]];
    }
    
    length = _textStorage.length;
    [_layoutManager invalidateLayoutForCharacterRange:NSMakeRange(0, length) actualCharacterRange:nil];
    
    [self setNeedsDisplay];
}

- (void)clearAttachViews {
    for (UIView *view in _attachViews.objectEnumerator) {
        [view removeFromSuperview];
    }
    [_attachViews removeAllObjects];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _textContainer.size = self.bounds.size;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    _textContainer.size = self.bounds.size;
}

- (void)setTracking:(BOOL)tracking {
    if (_tracking != tracking) {
        _tracking = tracking;
//        [self invalidateTextStorageClearViews:NO];
        [self setNeedsDisplay];
    }
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _textContainer.maximumNumberOfLines = numberOfLines;
    [super setNumberOfLines:numberOfLines];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _textContainer.lineBreakMode = lineBreakMode;
    [super setLineBreakMode:lineBreakMode];
}

- (NSLayoutManager *)buildLayoutManagerFromCurrentContext {
    NSLayoutManager *layout = [[NSLayoutManager alloc] init];
    layout.delegate = self;
    layout.usesFontLeading = NO;
    return layout;
}

- (NSTextContainer *)buildTextContainerFromCurrentContext {
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:self.frame.size];
    [self setupTextContainerFromCurrentContext:container];
    return container;
}

- (void)setupTextContainerFromCurrentContext:(NSTextContainer *)container {
    container.maximumNumberOfLines = self.numberOfLines;
    container.lineFragmentPadding = 0;
    container.lineBreakMode = self.lineBreakMode;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGSize originalSize = _textContainer.size;
    NSInteger originalLines = _textContainer.maximumNumberOfLines;
    CGRect fittingRect = CGRectZero;
    _textContainer.maximumNumberOfLines = numberOfLines;
    _textContainer.size = bounds.size;

    [_layoutManager invalidateLayoutForCharacterRange:NSMakeRange(0, _textStorage.length) actualCharacterRange:nil];
    [_layoutManager ensureLayoutForTextContainer:_textContainer];
    fittingRect = [_layoutManager usedRectForTextContainer:_textContainer];
    
    _textContainer.maximumNumberOfLines = originalLines;
    _textContainer.size = originalSize;
    
    return CGRectIntegral(fittingRect);
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    _textContainer.size = bounds.size;
    for (UIView *view in _attachViews.objectEnumerator) {
        view.hidden = YES;
    }
    
    if (_textStorage.length == 0) return;
    
    NSUInteger index = [_layoutManager glyphIndexForCharacterAtIndex:_textStorage.length - 1];
    if (index != NSNotFound) {
        NSRange allCharactorRange = NSMakeRange(0, _textStorage.length);
        NSRange allGlyphRange = NSMakeRange(0, index + 1);

        [_layoutManager ensureLayoutForTextContainer:_textContainer];
        CGRect usedRect = [_layoutManager usedRectForTextContainer:_textContainer];
        
        CGPoint origin = { 0, (bounds.size.height - usedRect.size.height) / 2 - usedRect.origin.y };
        _textOrigin = origin;
        
        [_layoutManager drawBackgroundForGlyphRange:allGlyphRange atPoint:origin];
        
        // Draw background at user touched area.
        if (self.isTracking
            && _tapGestureRecognizer->_trackingCharactersRange.location != NSNotFound
            && _tapGestureRecognizer->_trackingCharactersRange.length + _tapGestureRecognizer->_trackingCharactersRange.location <= _textStorage.length) {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            [_textStorage enumerateAttribute:DDHighlightedBackgroundColorAttributeName inRange:_tapGestureRecognizer->_trackingCharactersRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                if ([value isKindOfClass:UIColor.class]) {
                    [(UIColor *)value setFill];
                    NSRange highlightedGlyphsRange = [_layoutManager glyphRangeForCharacterRange:range actualCharacterRange:NULL];
                    if (highlightedGlyphsRange.location != NSNotFound && highlightedGlyphsRange.length > 0) {
                        [_layoutManager enumerateEnclosingRectsForGlyphRange:highlightedGlyphsRange withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0) inTextContainer:_textContainer usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {
                            rect.origin.x += origin.x;
                            rect.origin.y += origin.y;
                            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2] fill];
                        }];
                    }
                }
            }];
            CGContextRestoreGState(ctx);
        }
        
        // Add custom views to the label
        [_textStorage enumerateAttribute:NSAttachmentAttributeName inRange:allCharactorRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            if (value && [value isKindOfClass:DDViewAttachment.class]) {
                DDViewAttachment *attachment = (DDViewAttachment *)value;
                UIView *view = [_attachViews objectForKey:attachment];
                if (view == nil) {
                    view = attachment.viewCreator();
                    if (view) {
                        [_attachViews setObject:view forKey:attachment];
                    }
                }
                if (view) {
                    NSRange glyphRange = [_layoutManager glyphRangeForCharacterRange:range actualCharacterRange:NULL];
                    NSRange truncatedRange = [_layoutManager truncatedGlyphRangeInLineFragmentForGlyphAtIndex:glyphRange.location];
                    if (glyphRange.location != NSNotFound && glyphRange.length > 0 &&
                        !(glyphRange.location >= truncatedRange.location && glyphRange.location < truncatedRange.location + truncatedRange.length)) {
                        CGPoint attachOrigin = [_layoutManager locationForGlyphAtIndex:glyphRange.location];
                        CGSize attachSize = [_layoutManager attachmentSizeForGlyphAtIndex:glyphRange.location];
                        CGRect lineFragment = [_layoutManager lineFragmentRectForGlyphAtIndex:glyphRange.location effectiveRange:nil];
                        attachOrigin.x += lineFragment.origin.x;
                        attachOrigin.y += lineFragment.origin.y - attachSize.height;
                        CGRect frame = { attachOrigin, attachSize };
                        if (attachSize.width > 0 && attachSize.height > 0) {
                            frame.origin.x += origin.x;
                            frame.origin.y += origin.y;
                            view.frame = CGRectIntegral(frame);
                            view.hidden = NO;
                            [self addSubview:view];
                        }
                        else {
                            view.hidden = YES;
                        }
                    }
                    else {
                        view.hidden = YES;
                    }
                }
            }
        }];
        
        [_layoutManager drawGlyphsForGlyphRange:allGlyphRange atPoint:origin];
    }
}

- (void)findUserAction:(id<DDLabelUserAction> *)userAction range:(NSRange *)range withTouch:(UITouch *)touch {
    if (userAction) *userAction = nil;
    if (range) *range = NSMakeRange(0, 0);
    CGPoint location = [touch locationInView:self];
    location.x -= _textOrigin.x;
    location.y -= _textOrigin.y;
    NSUInteger index = [_layoutManager glyphIndexForPoint:location inTextContainer:_textContainer];
    CGRect rect = [_layoutManager boundingRectForGlyphRange:NSMakeRange(index, 1) inTextContainer:_textContainer];
    if (!CGRectContainsPoint(rect, location)) return;
    if (index != NSNotFound && _layoutManager.numberOfGlyphs > index) {
        NSUInteger chIndex = [_layoutManager characterIndexForGlyphAtIndex:index];
        if (chIndex != NSNotFound) {
            id aUserAction = [_textStorage attribute:DDUserActionAttributeName atIndex:chIndex effectiveRange:range];
            if (aUserAction && [aUserAction conformsToProtocol:@protocol(DDLabelUserAction)]) {
                if (userAction) {
                    *userAction = aUserAction;
                }
            }
        }
    }
}

static const CGFloat DDDefaultLineSpacingAfterGlyph = 0.;

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    NSUInteger charactorIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    if (charactorIndex == _textStorage.length - 1 && !self.extendLineSpacingAtLastLine) {
        return DDDefaultLineSpacingAfterGlyph;
    }
    NSParagraphStyle *style = [_textStorage attribute:NSParagraphStyleAttributeName atIndex:charactorIndex effectiveRange:NULL];
    return MAX(DDDefaultLineSpacingAfterGlyph, style.lineSpacing);
}

@end
