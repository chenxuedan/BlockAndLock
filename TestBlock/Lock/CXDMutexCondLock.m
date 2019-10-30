//
//  CXDMutexCondLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDMutexCondLock.h"
#import <pthread.h>

@interface CXDMutexCondLock ()

@property (nonatomic, assign) pthread_mutex_t mutex; //锁
@property (nonatomic, assign) pthread_cond_t cond;  //条件
@property (nonatomic, strong) NSMutableArray *data;  //数据源

@end

@implementation CXDMutexCondLock
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        //初始化锁
        pthread_mutex_init(&_mutex, &attr);
        //销毁属性
        pthread_mutexattr_destroy(&attr);
        
        //初始化条件
        pthread_cond_init(&_cond, NULL);
        
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

// 生产者-消费者模式
//线程1
//删除数组中的元素
- (void)__remove {
    pthread_mutex_lock(&_mutex);
    
    if (self.data.count == 0) {
        //数据为空就等待(进入休眠，放开mutex锁，被唤醒后，会再次对mutex加锁)
        NSLog(@"__remove 等待");
        pthread_cond_wait(&_cond, &_mutex);
    }
    
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    pthread_mutex_unlock(&_mutex);
}

//线程2
//往数组中添加元素
- (void)__add {
    pthread_mutex_lock(&_mutex);
    
    sleep(1);
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    //激活一个等待该条件的线程
    pthread_cond_signal(&_cond);
    //激活所有等待该条件的线程
//    pthread_cond_broadcast(&_cond);
    
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}


- (void)mutexCondLock {
    /*
     pthread_mutex条件锁
     mutex除了有"互斥锁" "递归锁"  还有条件锁
     
     生产者消费者
     为了掩饰条件锁的作用，就用生产者消费者来展示效果
     
      **/
}

@end
