//
//  UINavigationController+Extension.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/18.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.visibleViewController;
}
@end
