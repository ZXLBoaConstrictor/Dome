//
//  ViewController.m
//  podTest
//
//  Created by 张小龙 on 2019/2/28.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+Category.h"
#import "UIViewController+Extension.h"

#import <coobjc/coobjc.h>
#import "coobjcCommon.h"

static COPromise<NSData *> *co_downloadWithURL(NSString *url) {
    NSLog(@"111");
    return [COPromise promise:^(COPromiseFullfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        NSLog(@"下载--%@",[NSThread currentThread]);
        [NSURLSession sharedSession].configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:
                                          ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                              if (error) {
                                                  reject(error);
                                                  return;
                                              }
                                              else{
                                                  NSData *data = [[NSData alloc] initWithContentsOfURL:location];
                                                   NSLog(@"下载完成--%@",[NSThread currentThread]);
                                                  fullfill(data);
                                                  return;
                                              }
                                          }];
        
        [task resume];
        
    }];
}


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   CGRect rect = self.frame;
    self.extentionString = @"123";
  
    
    COCoroutine *co1 = co_sequence(^{
        while(co_isActive()){
            yield([NSData co_downloadWithURL:@"http://pytstore.oss-cn-shanghai.aliyuncs.com/GalileoShellApp.ipa"]);
        }
    });
    int filebytes = 248564;
    __block int val = 0;
    co_launch(^{
        for(int i = 0; i < 10; i++){
            NSData *data = [co1 next];
            val += data.length;
            //val = [[co1 next] intValue];
        }
        [co1 cancel];
    });
    
    // Do any additional setup after loading the view, typically from a nib.
}


@end
