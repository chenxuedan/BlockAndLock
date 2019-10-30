//
//  CXDOSSpinLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDOSSpinLock.h"
#import <libkern/OSAtomic.h>

@interface CXDOSSpinLock ()

@property (nonatomic, assign) OSSpinLock moneyLock;

@end


@implementation CXDOSSpinLock
- (instancetype)init {
    self = [super init];
    if (self) {
        self.moneyLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney {
    OSSpinLockLock(&_moneyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saveMoney {
    OSSpinLockLock(&_moneyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_moneyLock);
}


/**
 能保证线程安全，但是OSSpinLock已经不再安全了。
 
 
 为什么OSSpinLock不再安全
 如果一个低优先级的线程获得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，它会处于spin lock的忙等状态从而占用大量CPU。此时低优先级线程无法与高优先级线程争夺CPU时间，从而导致任务迟迟完不成，无法释放lock,这就是优先级反转。这并不只是理论上的问题，开发者已经遇到很多次这个问题，于是苹果工程师停用了OSSpinLock。
 结论
 除非开发者能保证访问锁的线程全部都处于同一优先级，否则iOS系统中所有类型的自旋锁都不能再使用了。
 
 
 
 **/



@end
