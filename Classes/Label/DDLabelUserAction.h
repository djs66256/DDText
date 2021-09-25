//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDLabelUserAction <NSObject>

- (void)invokeWithAttributedString:(NSAttributedString *)text;

@end

@interface DDLabelUserAction : NSObject <DDLabelUserAction>

@end

@interface DDLabelBlockUserAction : NSObject <DDLabelUserAction>

@property (nonatomic, copy, nullable) void (^block)(NSAttributedString *text);

+ (instancetype)userActionWithBlock:(void(^_Nullable)(NSAttributedString *text))block;

@end

NS_ASSUME_NONNULL_END
