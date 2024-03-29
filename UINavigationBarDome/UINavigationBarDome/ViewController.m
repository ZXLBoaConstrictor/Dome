//
//  ViewController.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/1/17.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "ViewController.h"
#import "BackEventViewController.h"
#import "TransparentViewController.h"
#import "TitleColorViewController.h"

@interface ViewController ()
@property (nonatomic,strong)UIView *titleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
//    if (_titleView == nil){
//        _titleView = [[UIImageView alloc] init]; //用UIImageView 这里可以快速实现你想要的任何顶部颜色
//        _titleView.backgroundColor = [UIColor whiteColor];
//        _titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height);
//        [self.view addSubview:_titleView];
//    }
    
    self.title = [NSString stringWithFormat:@"第%lu个界面",self.navigationController.viewControllers.count];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, self.view.frame.size.height - 100, 80, 80);
    [button setTitle:@"next" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

-(UIView *)topTitleView{
    return _titleView;
}

-(void)nextPage{
    
    switch (self.navigationController.viewControllers.count) {
        case 1:{
            [self.navigationController pushViewController:[BackEventViewController new] animated:YES];
        }
            break;
        case 2:{
            [self.navigationController pushViewController:[TransparentViewController new] animated:YES];
        }
            break;
        case 3:{
            
            UIWindow * window = [UIApplication sharedApplication].delegate.window;
            if (window.rootViewController){
                window.rootViewController = nil;
            }
            
            TitleColorViewController *mainVC = [[TitleColorViewController alloc] init];
            UINavigationController *pNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
            window.rootViewController = pNav;
//            [self.navigationController pushViewController:[TitleColorViewController new] animated:YES];
        }
            break;
        case 4:{
            UINavigationController * navTabBar = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
            navTabBar.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.navigationController presentViewController:navTabBar animated:YES completion:nil];
        }
            break;
        default:{
           [self.navigationController pushViewController:[ViewController new] animated:YES];
        }
            break;
    }
}

@end
