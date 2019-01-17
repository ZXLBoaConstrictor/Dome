//
//  ViewController+Extension.h
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/17.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXLBackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (Extension)<ZXLBackButtonHandlerProtocol>

@end

NS_ASSUME_NONNULL_END
