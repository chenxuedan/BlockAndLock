//
//  CXDLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDLock.h"

@interface CXDLock ()

@property (nonatomic, strong) NSLock *lock;

@end

@implementation CXDLock
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)__saveMoney {
    [self.lock lock];
    [super __saveMoney];
    [self.lock unlock];
}

- (void)__drawMoney {
    [self.lock lock];
    [super __drawMoney];
    [self.lock unlock];
}

- (void)dealloc {
}


- (void)lockDemo {
    /*
     NSLock是对mutex普通锁的封装
     
     api
     NSLocking协议有加锁lock和解锁unlock
     
     NSLock遵守这个协议，锁可以直接使用，另外，还有tryLock和lockBeforeDate
     - (void)lock; //加锁
     - (void)unlock; //解锁
     - (void)tryLock; //尝试加锁，如果加锁失败，就返回NO,加锁成功就返回YES
     - (void)lockBeforeDate:(NSDate *)limit; //在给定的时间内尝试加锁，加锁成功就返回YES,如果过了时间还没加上所，就返回NO。
     
     
     NSLock是对mutex普通锁的封装
     如果想要证明NSLock是对mutex普通锁的封装有两种方式
     汇编分析
     汇编分析来说，可以打断点进去，最终会发现调用了mutex，因为，lock是调用的msgSend,
     GNUstep
     
     
     **/

}


@end
