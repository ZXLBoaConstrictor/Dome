//
//  Person.m
//  load&initialize
//
//  Created by 张小龙 on 2019/1/21.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "Person.h"

@implementation Person
+(void)load{
    NSLog(@"Person load");
}

+(void)initialize{
    NSLog(@"Person initialize");
}
@end
