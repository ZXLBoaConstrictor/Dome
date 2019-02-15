//
// UINavigationBar+Extension.m
//
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "UINavigationBar+Extension.h"
#import "NSObject+ZXLExtension.h"
#import "UIButton+Extension.h"

@implementation UINavigationBar (Extension)

+(void)load {
    [[self class] zxlSwizzleMethod:@selector(layoutSubviews) swizzledSelector:@selector(replace_layoutSubviews)];
}

-(void)replace_layoutSubviews{
    [self replace_layoutSubviews];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {//需要调节
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                UIEdgeInsets edgeInsets = subview.layoutMargins;
                edgeInsets.left = 0;
                subview.layoutMargins = edgeInsets;//可修正iOS11之后的偏移
                break;
            }
        }
    }else{
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[UIButton class]] && ((UIButton *)subview).navigationBarBack) {
                CGRect rect = subview.frame;
                rect.origin.x = 0;
                subview.frame = rect;
                break;
            }
        }
    }
}

@end
