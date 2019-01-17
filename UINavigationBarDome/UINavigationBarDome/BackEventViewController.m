//
//  BackEventViewController.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/17.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "BackEventViewController.h"

@interface BackEventViewController ()

@end

@implementation BackEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"返回事件点击Test";
    // Do any additional setup after loading the view.
}

-(void)navigationShouldPopOnBackButton{
    NSLog(@"返回 ---事件");
    [self.navigationController popViewControllerAnimated:YES];
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
