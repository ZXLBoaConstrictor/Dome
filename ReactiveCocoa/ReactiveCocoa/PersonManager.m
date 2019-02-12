//
//  PersonManager.m
//  ReactiveCocoa
//
//  Created by 张小龙 on 2019/1/27.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "PersonManager.h"

@implementation PersonManager
+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static PersonManager* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[PersonManager alloc] init];
    });
    return _sharedObject;
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self addObserver:self
               forKeyPath:@"progress"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    }
    return self;
}

-(NSMutableArray *)ayPerson{
    if (!_ayPerson) {
        _ayPerson = [NSMutableArray array];
    }
    return _ayPerson;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"])
    {
        NSLog(@"%f",self.progress);
    }
}

-(void)change:(Person *)person{
    [self.ayPerson enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([((Person *)obj).name isEqualToString:person.name]) {
            ((Person *)obj).age = person.age;
            [self printf];
        }
    }];
}

-(void)printf{
    __block float fprogress = 0;
    [self.ayPerson enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        fprogress += ((Person *)obj).age;
    }];
    self.progress = fprogress/(float)self.ayPerson.count;
}


@end
