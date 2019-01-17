//
//  ViewController+Extension.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/17.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "ViewController+Extension.h"
#import "NSObject+ZXLExtension.h"

@implementation UIViewController (Extension)

+(void)load{
    //runtime 函数替换
    [[self class] zxlSwizzleMethod:@selector(viewDidLoad) swizzledSelector:@selector(replace_viewDidLoad)];
}

- (void)replace_viewDidLoad{
    [self replace_viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];//隐藏返回按钮跟随的字体
}


@end

//https://github.com/onegray/UIViewController-BackButtonHandler

@implementation UINavigationController (JLBExtension)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}
@end
