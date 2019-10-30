//
//  CXDUnfairLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDUnfairLock.h"
#import <os/lock.h>

@interface CXDUnfairLock ()

@property (nonatomic, assign) os_unfair_lock moneyLock;

@end

@implementation CXDUnfairLock
- (instancetype)init {
    self = [super init];
    if (self) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__saveMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneyLock);
}


- (void)__drawMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_moneyLock);
}



- (void)unfairLock {
    //初始化
    if (@available(iOS 10.0, *)) {
        os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
        //尝试加锁(如果不需要等待，就直接加锁，返回true;如果需要等待，就不加锁，返回false)
        BOOL res = os_unfair_lock_trylock(&lock);
        //加锁
        os_unfair_lock_lock(&lock);
        //解锁
        os_unfair_lock_unlock(&lock);
    } else {
        // Fallback on earlier versions
    }
    
    /*
     os_unfair_lock互斥锁
     os_unfair_lock用于取代不安全的OSSpinLock,从iOS10开始才支持
     从底层调用看，等待os_unfair_lock锁的线程会处于休眠状态，并非忙等
     
     需要导入头文件#import <os/lock.h>
     **/

}


@end
