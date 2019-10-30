//
//  CXDDispatchSemaphore.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDDispatchSemaphore.h"

@interface CXDDispatchSemaphore ()

@property (nonatomic, strong) dispatch_semaphore_t moneySemaphore;

@end

@implementation CXDDispatchSemaphore

- (instancetype)init {
    self = [super init];
    if (self) {
        self.moneySemaphore = dispatch_semaphore_create(3);
    }
    return self;
}

- (void)__drawMoney {
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    [super __drawMoney];
    dispatch_semaphore_signal(self.moneySemaphore);
}

- (void)__saveMoney {
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    [super __saveMoney];
    dispatch_semaphore_signal(self.moneySemaphore);
}

/// 信号量还可以控制线程数量，例如初始化的时候，设置最多3条线程
- (void)otherTest {
    for (int i = 0; i < 20; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}
//线程10、7、6、9、8
- (void)test {
    ///如果信号量的值>0，就让信号量的值减1，然后继续执行下面的代码
    ///如果信号量的值<=0,就会休眠等待，知道信号量的值变成>0,就让信号量的值减1，然后继续往下执行代码
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"test = %@",[NSThread currentThread]);
    
    //让 信号量的值+1
    dispatch_semaphore_signal(self.moneySemaphore);
}


- (void)semaphoreTest {
    /*
     dispatch_semaphore信号量
     semaphore叫做”信号量“
     信号量的初始值，可以用来控制线程并发访问的最大数量
     信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步
     
     
     信号量原理
     dispatch_semaphore_create(long value);  //创建信号量
     dispatch_semaphore_signal(dispatch_semaphore_t deem); //发送信号量
     dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout); //等待信号量
     
     dispatch_semaphore_create(long value)和GCD的group等用法一致，这个函数式创建一个dispatch_semaphore_类型的信号量，并且创建的时候需要制定信号量的大小。
     
     dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout)等待信号量。如果信号量值为0，那么该函数就会一直等待，也就是不返回(相当于阻塞当前线程)，直到该函数等待的信号量的值大于等于1，该函数会对信号量的值进行减1操作，然后返回。
     
     dispatch_semaphore_signal(dispatch_semaphore_t deem)发送信号量。该函数会对信号量的值进行加1操作。
     
     通常等待信号量和发送信号量的函数是成对出现的。并发执行任务时候，在当前任务执行之前，用dispatch_semaphore_wait函数进行等待(阻塞),直到上一个任务执行完毕后且通过dispatch_semaphore_signal函数发送信号量(使信号量的值加1)，dispatch_semaphore_signal函数发送信号量(使信号量的值加1)，dispatch_semaphore_wait函数收到信号量之后判断信号量的值大于等于1，会再对信号量的值减1，然后当前任务可以执行，执行完毕当前任务后，再通过dispatch_semaphore_signal函数发送信号量(使信号量的值加1)，通知执行下一个任务。。。。如此一来，通过信号量，就达到了并发队列中的任务同步执行的要求。
     
     
     **/

}


@end
