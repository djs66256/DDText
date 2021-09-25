//
//  DDTextKit.h
//  DDText
//
//  Created by daniel on 2021/9/25.
//

#import "DDViewAttachment.h"

@implementation DDViewAttachment

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.image = [UIImage new];
    }
    return self;
}

- (instancetype)initWithViewCreator:(UIView * _Nonnull (^)(void))viewCreator {
    self = [self init];
    if (self) {
        _viewCreator = viewCreator;
        _viewSize = viewCreator().intrinsicContentSize;
        self.bounds = (CGRect){CGPointZero, _viewSize};
    }
    return self;
}

- (instancetype)initWithViewCreator:(UIView * _Nonnull (^)(void))viewCreator viewSize:(CGSize)viewSize {
    self = [self init];
    if (self) {
        _viewCreator = viewCreator;
        _viewSize = viewSize;
        self.bounds = (CGRect){CGPointZero, _viewSize};
    }
    return self;
}

@end
