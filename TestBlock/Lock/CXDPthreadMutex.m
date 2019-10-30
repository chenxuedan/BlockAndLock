//
//  CXDPthreadMutex.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDPthreadMutex.h"
#import <pthread.h>

@interface CXDPthreadMutex ()

@property (nonatomic, assign) pthread_mutex_t moneyMutexLock;

@end


@implementation CXDPthreadMutex

- (void)__initMutexLock:(pthread_mutex_t *)mutex {
    //静态初始化
//    pthread_mutex_t mutex = PTHREAD_MUTEX_DEFAULT;
    //初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    //初始化锁
    pthread_mutex_init(mutex, &attr);
    //销毁属性
    pthread_mutexattr_destroy(&attr);
    
    //上面五行相当于下面一行
//    pthread_mutex_init(mutex, NULL); // 传空，相当于PTHREAD_MUTEX_DEFAULT
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self __initMutexLock:&_moneyMutexLock];
    }
    return self;
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneyMutexLock);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyMutexLock);
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneyMutexLock);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneyMutexLock);
}

- (void)dealloc {
    //dealloc时候，需要销毁锁
    pthread_mutex_destroy(&_moneyMutexLock);
}


/// pthread_mutex 互斥锁
/// pthread_mutex除了有”互斥锁“,还有递归锁
/// mutex叫做”互斥锁“，等待锁的线程会处于休眠状态
- (void)pthread_mutex {
    
    //初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    //初始化锁
//    pthread_mutex_init(mutex, &attr);
    //销毁属性
    pthread_mutexattr_destroy(&attr);
    
    /*
     其中锁的类型有四种
     #define PTHREAD_MUTEX_NORMAL     0   //一般的锁
     #define PTHREAD_MUTEX_ERRORCHECK 1   // 错误检查
     #define PTHREAD_MUTEX_RECURSIVE  2   //递归锁
     #define PTHREAD_MUTEX_DEFAULT    PTHREAD_MUTEX_NORMAL //默认
     **/

    
}



@end
