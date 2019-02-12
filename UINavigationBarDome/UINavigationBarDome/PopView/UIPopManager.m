//
//  UIPopManager.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/2/12.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "UIPopManager.h"
#import "UIPopTipsViewController.h"
#import "UIPopBackgroundView.h"

@implementation UIPopManager

+(void)showTipsContent:(NSString *)content
                  with:(CGFloat)contentWidth
             direction:(UIPopoverArrowDirection)arrowDirection
          cornerRadius:(CGFloat)cornerRadius
                sender:(id)sender
  navigationController:(UINavigationController *)controller{
    
    if (!content || content.length == 0 || contentWidth == 0 || !sender || !controller) {
        return;
    }
    
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(contentWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.height + 20;
    
    UIPopTipsViewController *tipsVC = [[UIPopTipsViewController alloc] init];
    tipsVC.tipsText = content;
    tipsVC.modalPresentationStyle = UIModalPresentationPopover;
    tipsVC.popoverPresentationController.sourceView = (UIView *)sender;
    CGRect sourceRect = ((UIView *)sender).bounds;
    sourceRect.origin.y -= 5;//修改整个内容和触发控件位子
    tipsVC.popoverPresentationController.sourceRect = sourceRect;
    tipsVC.popoverPresentationController.permittedArrowDirections = arrowDirection;
    //控制提示框大小
    tipsVC.preferredContentSize = CGSizeMake(contentWidth, contentHeight);
    tipsVC.popoverPresentationController.delegate = tipsVC;
    tipsVC.popoverPresentationController.popoverBackgroundViewClass = [UIPopBackgroundView class];
    [controller presentViewController:tipsVC animated:YES completion:nil];
    // 改变弹出框圆角.(一定要放在后面写，这里会调用viewDidLoad，如果不清楚可以去苹果官网看一些调用顺序)
    tipsVC.view.layer.cornerRadius = cornerRadius;
    tipsVC.view.layer.masksToBounds = YES;
}
@end
