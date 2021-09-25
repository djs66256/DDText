//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import <UIKit/UIKit.h>
#import "DDLabelUserAction.h"

NS_ASSUME_NONNULL_BEGIN

/// Value type MUST be DDLabelUserAction
extern const NSAttributedStringKey DDUserActionAttributeName;
extern const NSAttributedStringKey DDHighlightedBackgroundColorAttributeName;

/// Why we use recognizer instead of Responder's touch event?
/// In some cases, we need to decide whether this label or its superview should receive events.
/// And recognizer can be decided when challenge.
@interface DDLabelTapGestureRecognizer : UIGestureRecognizer
@end

/// A label can be instead of UILabel. It only support attributed text.
/// It also supports user interactions and custom views.
@interface DDLabel : UILabel

/// DDLabel is not support text, because UILabel is a better choice.
/// And it's not support other attribute on the label, which affect on text.
@property (nonatomic, copy) NSString *text NS_UNAVAILABLE; // Do not suport text, use UILabel instead.
@property (null_resettable, nonatomic,strong) UIFont      *font NS_UNAVAILABLE;
@property (null_resettable, nonatomic,strong) UIColor     *textColor NS_UNAVAILABLE;
@property (nullable, nonatomic,strong) UIColor            *shadowColor NS_UNAVAILABLE;
@property (nonatomic)        CGSize             shadowOffset NS_UNAVAILABLE;
@property (nonatomic)        NSTextAlignment    textAlignment NS_UNAVAILABLE;

@property(nullable, nonatomic, copy) NSAttributedString *attributedText;

/// 在富文本布局中，lineSpacing在最后一行并不会在行末加上spacing，但是lineHeight却会在第一行加上spacing，所以在一些场景下布局不方便
/// 当为YES时，lineSpacing会在最后一行也加上spacing
/// When using `lineSpacing`, it will not add a space after last line.
/// While `lineHeight` will add a space at first line.
/// It will add last character's `lineSpacing` to last line.
@property (nonatomic, assign) BOOL extendLineSpacingAtLastLine; // Default NO.

/// Whether label is tracking user interaction.
@property (nonatomic, readonly, getter=isTracking) BOOL tracking;

@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is NO
@property (nonatomic, strong, readonly) DDLabelTapGestureRecognizer *tapGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
