//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import <DDText/DDAttributedTextBuilder.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAttributedTextBuilder (DDLabel)

// 用户点击高亮色
@property (nonatomic, readonly) DDAttributedTextBuilder *(^DDHighlightedBackgroundColor)(UIColor * nullable);
// 用户点击事件
@property (nonatomic, readonly) DDAttributedTextBuilder *(^DDUserAction)(void(^_Nullable block)(NSAttributedString *text));

@end

NS_ASSUME_NONNULL_END
