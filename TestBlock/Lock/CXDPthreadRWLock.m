//
//  CXDPthreadRWLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/29.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDPthreadRWLock.h"
#import <pthread.h>
@interface CXDPthreadRWLock ()

@property (nonatomic, assign) pthread_rwlock_t lock;

@end

@implementation CXDPthreadRWLock
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化锁
        pthread_rwlock_init(&_lock, NULL);
    }
    return self;
}

- (void)otherTest {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 3; i++) {
        dispatch_async(queue, ^{
            [self write];
            [self read];
        });
    }
    
    for (int i = 0; i < 3; i++) {
        dispatch_async(queue, ^{
            [self write];
        });
    }
    
    
    
    
}


- (void)read {
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}


- (void)write {
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"%s",__func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)dealloc {
    pthread_rwlock_destroy(&_lock);
}


/*
 pthread_rwlock读写锁
 
 读写锁是计算机程序的并发控制的一种同步机制，也称“共享-互斥锁”、多读者-单写者锁。多读者锁，“push lock”用于解决读写问题。读操作可并发重入，写操作是互斥的。
 
 // 初始化锁
 pthread_rwlock_t lock;
 pthread_rwlock_init(&lock, NULL);
 // 读-加锁
 pthread_rwlock_rdlock(&lock);
 // 读-尝试加锁
 pthread_rwlock_tryrdlock(&lock);
 // 写-加锁
 pthread_rwlock_wrlock(&lock);
 // 写-尝试加锁
 pthread_rwlock_trywrlock(&lock);
 // 解锁
 pthread_rwlock_unlock(&lock);
 // 销毁
 pthread_rwlock_destroy(&lock);
 
 
 多读单写的功能，被称为读写锁。
 
 **/



@end
