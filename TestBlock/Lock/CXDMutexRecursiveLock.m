//
//  CXDMutexRecursiveLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDMutexRecursiveLock.h"
#import <pthread.h>

@interface CXDMutexRecursiveLock ()

@property (nonatomic, assign) pthread_mutex_t mutexLock;

@end

@implementation CXDMutexRecursiveLock

- (void)__initMutexLock:(pthread_mutex_t *)mutex {
    //递归锁：允许同一个线程对一把锁进行重复加锁
    //初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    //初始化锁
    pthread_mutex_init(mutex, &attr);
    //销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (void)otherTest {
    //第一次进来直接加锁，第二次进来，已经加锁了。还能递归继续加锁
    pthread_mutex_lock(&_mutexLock);
    NSLog(@"加锁  %s",__func__);
    static int count = 0;
    if (count < 5) {
        count++;
        [self otherTest];
    }
    NSLog(@"解锁  %s",__func__);
    pthread_mutex_unlock(&_mutexLock);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    //dealloc时候，需要销毁锁
    pthread_mutex_destroy(&_mutexLock);
}



@end

