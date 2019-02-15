//
//  ViewController+Extension.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/17.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "ViewController+Extension.h"
#import "NSObject+ZXLExtension.h"
#import "UIButton+Extension.h"
@interface UIViewController()<UIGestureRecognizerDelegate>
@end

@implementation UIViewController (Extension)

+(void)load{
    //runtime 函数替换
    [[self class] zxlSwizzleMethod:@selector(viewDidLoad) swizzledSelector:@selector(replace_viewDidLoad)];
    [[self class] zxlSwizzleMethod:@selector(viewWillAppear:) swizzledSelector:@selector(replace_viewWillAppear:)];
}

- (void)replace_viewDidLoad{
    [self replace_viewDidLoad];
    if ([self isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];//隐藏返回按钮跟随的字体
}

-(void)replace_viewWillAppear:(BOOL)animated{
    [self replace_viewWillAppear:animated];
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    if (self.navigationController &&
        self.navigationController.presentationController &&
        [[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]] &&
        self.navigationController != [UIApplication sharedApplication].keyWindow.rootViewController) {
        if (self.navigationController.viewControllers.count == 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"Titlebackbg.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 70, 30);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.imageEdgeInsets = UIEdgeInsetsMake(-9.0, 8.2, 0, 0);
            button.navigationBarBack = YES;
            [button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    }
}

-(void)onBack{
    if([self respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        [self navigationShouldPopOnBackButton];
    }else{
      [self dismissViewControllerAnimated:YES completion:nil];
    }
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
