//
//  UIButton+Extension.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/2/15.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@implementation UIButton (Extension)

- (BOOL)navigationBarBack {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
}

- (void)setNavigationBarBack:(BOOL)back {
    objc_setAssociatedObject(self, @selector(navigationBarBack), [NSNumber numberWithBool:back], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
