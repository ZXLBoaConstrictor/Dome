//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by 张小龙 on 2019/1/27.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "Person.h"
#import "PersonManager.h"
@interface ViewController ()
@property (nonatomic ,strong)Person * person;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [PersonManager manager].ayPerson = [NSMutableArray array];
    Person *person1 = [Person new];
    person1.name = @"lili";
    [[PersonManager manager].ayPerson addObject:person1];
    Person *person2 = [Person new];
    person2.name = @"lili";
    [[PersonManager manager].ayPerson addObject:person2];
    Person *person3 = [Person new];
    person3.name = @"lili";
    [[PersonManager manager].ayPerson addObject:person3];
    Person *person4 = [Person new];
    person4.name = @"lili";
    [[PersonManager manager].ayPerson addObject:person4];
    Person *person5 = [Person new];
    person5.name = @"lili";
    [[PersonManager manager].ayPerson addObject:person5];
    
    self.person = [[Person alloc] init];
    self.person.name = @"lili";
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(progress) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)progress{
    if (self.person.age <= 1) {
        self.person.age += 0.01;
    }else{
        self.person = nil;
    }
}
@end
