//
//  CXDBaseLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDBaseLock.h"
#import <UIKit/UIKit.h>

@interface CXDBaseLock ()

@property (nonatomic, assign) CGFloat money;

@end

@implementation CXDBaseLock
/// 存钱、取钱演示
- (void)moneyTest {
    self.money = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __drawMoney];
        }
    });
    
    
}

/// 存钱
- (void)__saveMoney {
    int oldMoney = self.money;
    sleep(2);
    oldMoney += 10;
    self.money = oldMoney;
    
    NSLog(@"存10元，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

- (void)__drawMoney {
    int oldMoney = self.money;
    sleep(2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20元，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}
@end
