//
//  Person.m
//  ReactiveCocoa
//
//  Created by 张小龙 on 2019/1/27.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "Person.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "PersonManager.h"

@implementation Person
-(instancetype)init{
    if (self = [super init]) {
        
        [self addObserver:self
                    forKeyPath:@"age"
                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context:nil];
//        [RACObserve(self, age)subscribeNext:^(id  _Nullable x) {
//            if ([[PersonManager manager].ayPerson indexOfObject:self] == NSNotFound) {
//                [[PersonManager manager] change:self];
//            }
//        }];
    }
    return self;
}


@end
