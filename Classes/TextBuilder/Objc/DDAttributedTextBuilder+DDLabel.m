//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import "DDAttributedTextBuilder+DDLabel.h"
#import "DDLabel.h"

@implementation DDAttributedTextBuilder (DDLabel)

- (DDAttributedTextBuilder * (^)(UIColor *))DDHighlightedBackgroundColor {
    return ^(UIColor *color) {
        return self.set(DDHighlightedBackgroundColorAttributeName, color);
    };
}

- (DDAttributedTextBuilder * (^)(void (^)(NSAttributedString *)))DDUserAction {
    return ^(void (^block)(NSAttributedString *)) {
        DDLabelBlockUserAction *userAction = [DDLabelBlockUserAction userActionWithBlock:block];
        return self.set(DDUserActionAttributeName, userAction);
    };
}

@end
