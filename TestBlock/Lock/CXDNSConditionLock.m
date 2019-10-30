//
//  CXDNSConditionLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDNSConditionLock.h"

@interface CXDNSConditionLock ()



@end

@implementation CXDNSConditionLock


- (void)otherTest {
    //主线程中
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:2];
        NSLog(@"线程1");
        sleep(2);
        NSLog(@"线程1解锁成功");
        [lock unlockWithCondition:3];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:0];
        NSLog(@"线程2");
        sleep(3);
        NSLog(@"线程2解锁成功");
        [lock unlockWithCondition:1];
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:3];
        NSLog(@"线程3");
        sleep(3);
        NSLog(@"线程3解锁成功");
        [lock unlockWithCondition:4];
    });
    
    //线程4
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:1];
        NSLog(@"线程4");
        sleep(2);
        NSLog(@"线程4解锁成功");
        [lock unlockWithCondition:2];
    });
}



- (void)test {
    
}


@end
