//
//  CXDDispatchBarrierAsync.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/29.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDDispatchBarrierAsync.h"

@interface CXDDispatchBarrierAsync ()

@property (nonatomic, strong) dispatch_queue_t queue;


@end


@implementation CXDDispatchBarrierAsync

- (void)otherTest {
    //初始化
    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 3; i++) {
        //读
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        //写
        dispatch_barrier_async(self.queue, ^{
            [self write];
        });
        
        //读
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        //读
        dispatch_async(self.queue, ^{
            [self read];
        });
    }
}

- (void)read {
    sleep(1);
    NSLog(@"read");
}

- (void)write {
    sleep(1);
    NSLog(@"write");
}


/*
 dispatch_barrier_async异步栅栏
 
 这个函数传入的并发队列必须是自己通过dispatch_queue_create创建的
 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispacth_async函数的效果
 
 使用
 //初始化队列
 self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_COONCURRENT);
 
 //读
 dispatch_async(self.queue. ^{
 
 });
 
 //写
 dispatch_barrier_async(self.queue, ^{
 
 });
 
 
 
 **/



@end
