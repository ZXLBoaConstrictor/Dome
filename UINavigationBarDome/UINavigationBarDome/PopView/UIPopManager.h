//
//  UIPopManager.h
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/2/12.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIPopManager : NSObject
/**
 提示框展示
 
 @param content 内容
 @param contentWidth 宽度
 @param arrowDirection 方向 （上、下）
 @param cornerRadius 圆角
 @param sender 触发控件
 @param controller 控制器
 */
+(void)showTipsContent:(NSString *)content
                  with:(CGFloat)contentWidth
             direction:(UIPopoverArrowDirection)arrowDirection
          cornerRadius:(CGFloat)cornerRadius
                sender:(id)sender
  navigationController:(UINavigationController *)controller;





@end


