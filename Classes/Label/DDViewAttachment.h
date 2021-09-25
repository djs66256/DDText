//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDViewAttachment : NSTextAttachment

@property (nonatomic, copy, readonly) UIView *(^viewCreator)(void);
@property (nonatomic, assign, readonly) CGSize viewSize;

- (instancetype)initWithViewCreator:(UIView *(^)(void))viewCreator;
- (instancetype)initWithViewCreator:(UIView *(^)(void))viewCreator viewSize:(CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
