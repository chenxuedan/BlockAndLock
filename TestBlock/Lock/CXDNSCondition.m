//
//  CXDNSCondition.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDNSCondition.h"

@interface CXDNSCondition ()

@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation CXDNSCondition
- (instancetype)init {
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];
        self.data = [NSMutableArray array];
    }
    return self;
}


- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

//生产者消费者模式
//线程1
//删除数组中的元素
- (void)__remove {
    [self.condition lock];
    
    if (self.data.count == 0) {
        //数据为空就等待(进入休眠，放开锁，被唤醒后，会再次对Mutex加锁)
        NSLog(@"__remove - 等待");
        [self.condition wait];
    }
    
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    [self.condition unlock];
}

- (void)__add {
    [self.condition lock];
    
    sleep(1);
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    // 激活一个等待该条件的线程
    [self.condition signal];
    //激活所有等待该条件的线程
//    [self.condition broadcast];
    
    [self.condition unlock];
}


- (void)conditionDemo {
    /*
     NSCondition是对mutex和cond的封装
     
     使用
     生产者消费者
     
     api
     - (void)wait; //等待
     - (BOOL)waitUntilDate:(NSDate *)limit; //在给定时间之前等待
     - (void)signal; //激活一个等待该条件的线程
     - (void)broadcast; //激活所有等待该条件的线程
     **/

}



@end
