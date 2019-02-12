//
//  Person.h
//  ReactiveCocoa
//
//  Created by 张小龙 on 2019/1/27.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,assign)float age;
@end

NS_ASSUME_NONNULL_END
