//
//  TransparentViewController.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/17.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "TransparentViewController.h"
#import "UIPopManager.h"
@interface TransparentViewController ()

@end

@implementation TransparentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topTitleView].alpha = 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setTitle:@"popTips-up" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(popTipsUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 200, 100, 40);
    [button1 setTitle:@"popTips-down" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor greenColor];
    [button1 addTarget:self action:@selector(popTipsDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setTitle:@"提示" forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(onTitleRight:) forControlEvents:UIControlEventTouchUpInside];
    customBtn.frame = CGRectMake(0, 0, 80, 20);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
    // Do any additional setup after loading the view.
}
-(void)onTitleRight:(id)sender{
   
    [UIPopManager showTipsContent:@"这是一个提示信息，别管它有多长，现在字数够了！！！" with:160 direction:UIPopoverArrowDirectionUp cornerRadius:6 sender:sender navigationController:self.navigationController];
}

-(void)popTipsUp:(id)sender{
    [UIPopManager showTipsContent:@"这是一个提示信息，别管它有多长，现在字数够了！！！" with:160 direction:UIPopoverArrowDirectionUp cornerRadius:6 sender:sender navigationController:self.navigationController];
}

-(void)popTipsDown:(id)sender{
    [UIPopManager showTipsContent:@"这是一个提示信息，别管它有多长，现在字数够了！！！" with:160 direction:UIPopoverArrowDirectionDown cornerRadius:6 sender:sender navigationController:self.navigationController];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
