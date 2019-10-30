//
//  CXDDispatchGroupt.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/29.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDDispatchGroupt.h"

@interface CXDDispatchGroupt ()

@end

@implementation CXDDispatchGroupt

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)otherTest {
    //创建调度组
    dispatch_group_t group = dispatch_group_create();
    //队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //调度组监听队列 标记开始本次执行
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self downLoadImage1];
        //标记本地请求完成
        dispatch_group_leave(group);
    });
    
    //调度组监听队列 标记开始本次执行
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self downloadImage2];
        //标记本地请求完成
        dispatch_group_leave(group);
    });
    
    
    //调度组都完成了
    dispatch_group_notify(group, queue, ^{
       //执行完test1和test2之后，在进行请求test3
        [self reloadUI];
    });
    
    /*
     子线程耗时操作，等两个图片都下载弯沉，才回到主线程刷新UI
     
     dispatch_group有两个需要注意的地方
     dispatch_group_enter必须在dispatch_group_leave之前出现
     dispatch_group_enter和dispatch_group_leave必须成对出现
     
     
     
     自旋锁， 互斥锁的选择
     什么情况使用自旋锁比较划算？
     预计线程等待锁的时间很短
     加锁的代码(临界区)经常被调用，但竞争情况很少发生
     CPU资源不紧张
     多核处理
     
     什么情况使用互斥锁比较划算？
     
     预计线程等待锁的时间较长
     单核处理
     临界区有IO操作
     临界区代码复杂或者循环量大
     临界区竞争非常激烈
     
     **/

}

- (void)downLoadImage1 {
    sleep(1);
    NSLog(@"%s-- %@",__func__, [NSThread currentThread]);
}

- (void)downloadImage2 {
    sleep(2);
    NSLog(@"%s -- %@", __func__, [NSThread currentThread]);
}

- (void)reloadUI {
    NSLog(@"%s -- %@", __func__, [NSThread currentThread]);
}


/*
 dispatch_group_t 调度组
 
 //创建调度组
 dispatch_group_t group = dispatch_group_create();
 //队列
 dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
 
 //调度组监听队列 标记开始本次执行
 dispatch_group_enter(group);
 //标记本次请求完成
 dispatch_group_leave(group);
 
 //调度组都完成了
 dispatch_group_notify(group, dispatch_get_main_group(), ^{
 //执行刷新UI等操作
 
 });
 
 
 
 
 **/


@end
