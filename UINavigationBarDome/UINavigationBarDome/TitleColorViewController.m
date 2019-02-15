//
//  TitleColorViewController.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/17.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "TitleColorViewController.h"
#import "UIButton+Extension.h"

@interface TitleColorViewController ()<UIGestureRecognizerDelegate>
@end

@implementation TitleColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topTitleView].backgroundColor = [UIColor blueColor];


    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"TitleWhitebackbg.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 70, 30);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(-9, 8.2, 0, 0);
    button.navigationBarBack = YES;
    [button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
