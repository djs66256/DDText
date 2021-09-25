//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import "DDLabelUserAction.h"

@implementation DDLabelUserAction

- (void)invokeWithAttributedString:(NSAttributedString *)text {
    
}

@end

@implementation DDLabelBlockUserAction

+ (instancetype)userActionWithBlock:(void (^)(NSAttributedString * _Nonnull))block {
    DDLabelBlockUserAction *userAction = [DDLabelBlockUserAction new];
    userAction.block = block;
    return userAction;
}

- (void)invokeWithAttributedString:(NSAttributedString *)text {
    if (self.block) {
        self.block(text);
    }
}

@end
