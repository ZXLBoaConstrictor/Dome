//
//  UIPopTipsViewController.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/2/12.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "UIPopTipsViewController.h"

@interface UIPopTipsViewController ()
@property(nonatomic,strong)UILabel * tipsLabel;
@end

@implementation UIPopTipsViewController

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:12.0f];
        _tipsLabel.frame = CGRectMake(10, 10, self.preferredContentSize.width - 20, self.preferredContentSize.height - 20);
        [self.view addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.tipsLabel.text = self.tipsText;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.superview.clipsToBounds = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}
@end
