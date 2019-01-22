//
//  ViewController.m
//  load&initialize
//
//  Created by 张小龙 on 2019/1/21.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "ViewController.h"
#import "Son.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Son *boy = [Son alloc];
    boy.name = @"lilei";
    NSLog(@"%@",boy.name);
    
    [self test];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)test{
    Son *boy = [Son alloc];
    boy.name = @"wuwu";
    NSLog(@"%@",boy.name);
}

@end
