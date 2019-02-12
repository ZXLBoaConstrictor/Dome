//
//  PersonManager.h
//  ReactiveCocoa
//
//  Created by 张小龙 on 2019/1/27.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonManager : NSObject
@property (nonatomic,assign)float progress;
@property (nonatomic,strong)NSMutableArray *ayPerson;
+(instancetype)manager;
-(void)change:(Person *)person;
@end

NS_ASSUME_NONNULL_END
