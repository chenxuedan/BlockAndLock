//
//  ViewController.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/16.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>
#import "CXDDispatchSemaphore.h"
#import "CXDBlock.h"
#import "CXDPerson.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger testNumber;

@property (nonatomic, assign) CGFloat money;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    CXDDispatchSemaphore *semaphore = [[CXDDispatchSemaphore alloc] init];
//    [semaphore otherTest];
    
    
    [self blocktest];
    
    
}


- (void)blocktest {
    CXDBlock *block = [[CXDBlock alloc] init];
    [block test];
}

- (void)osspinLock {
    //初始化
    OSSpinLock lock = OS_SPINLOCK_INIT;
    //尝试加锁(如果不需要等待，就直接加锁，返回true,如果需要等待，就不加锁，返回false)
    BOOL res = OSSpinLockTry(&lock);
    //加锁
    OSSpinLockLock(&lock);
    //解锁
    OSSpinLockUnlock(&lock);
}

/// 存钱、取钱演示
- (void)moneyTest {
    self.money = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __drawMoney];
        }
    });
    
    
}

/// 存钱
- (void)__saveMoney {
    int oldMoney = self.money;
    sleep(2);
    oldMoney += 10;
    self.money = oldMoney;
    
    NSLog(@"存10元，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

- (void)__drawMoney {
    int oldMoney = self.money;
    sleep(2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20元，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

/*
OSSpinLock 自旋锁
os_unfair_lock 互斥锁
pthread_mutex 递归锁
pthread_mutex 条件锁
dispatch_semaphore信号量
dispatch_queue(DISPATCH_QUEUE_SERIAL)
NSLock
NSRecursiveLock
NSCondition
NSConditionLock
@synchronized
dispatch_barrier_async栅栏
dispatch_group调度组

除了OSSpinLock外，dispatch_semaphore和pthread_mutex性能是最高的。现在苹果在新系统中已经优化了pthread_mutex的性能，所以它看上去和OSSpinLock的差距并没有那么大了。


OSSpinLock自旋锁
OSSpinLock叫做"自旋锁"，等待锁的线程会处于忙等(busy-wait)状态，一直占用着CPU资源
目前已经不再安全，可能会出现优先级反转问题
需要导入头文件#import <libkern/OSAtomic.h>



**/

- (void)dispatchSemaphore {
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("com.ccxd.download", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(semaphore);
            NSLog(@"任务aaaaaa");
        });
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(semaphore);
            NSLog(@"任务bbbbbbbbb");
        });
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"notify任务任务问去任务e任务");
    });
    NSLog(@"我就是想看看会不会阻塞前面的线程");
}

- (void)dispatchNotify {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("com.ccxd.download", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_group_leave(group);
            NSLog(@"任务aaaaaa");
        });
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_group_leave(group);
            NSLog(@"任务bbbbbb");
        });
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify任务任务问去任务e任务");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务66666666");
    });
    NSLog(@"我就是想看看会不会阻塞前面的线程");
}

- (void)asyncConcurrent {

    dispatch_queue_t queue = dispatch_queue_create("com.ccxd.download", DISPATCH_QUEUE_CONCURRENT);
    
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"download1----- %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"延时函数----- %@",[NSThread currentThread]);
//        });
        sleep(20);
        NSLog(@"download2----- %@",[NSThread currentThread]);
    });
//    dispatch_async(queue, ^{
//        NSLog(@"download3----- %@",[NSThread currentThread]);
//    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier函数l开始");
        NSLog(@"barrier函数----- %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download4----- %@",[NSThread currentThread]);
    });
    NSLog(@"执行结束");
}





- (void)ttttt {
    //    NSLog(@"testNumber111   %ld",self.testNumber);
    //
    //
    //    NSInteger num = 3;
    //    __block NSInteger blockInter = 4;
    //    void (^Testblock)(NSString *nameString) = ^(NSString *nameString){
    ////        NSLog(@"%@",nameString);
    //        blockInter = 90;
    //        NSLog(@"testNumber222    %ld",self->_testNumber);
    //        NSLog(@"%ld",num);
    //        NSLog(@"%ld",blockInter);
    //    };
    //    self.testNumber = 2;
    //
    //    Testblock(@"123");
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"1111你   %@",[NSThread currentThread]);
        [self performSelector:@selector(testThre) withObject:nil afterDelay:0];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"为   %@",[NSThread currentThread]);
        [self performSelector:@selector(testThre) withObject:nil afterDelay:0];
    });
    
    /*
     performSelector:withObject:afterDelay:内部大概是怎么实现的，有什么注意事项么？
     ·创建一个定时器，时间结束后系统会使用runtime通过方法名称(Selector本质就是方法名称)去方法列表中找到对应的方法实现并调用方法。
     注意事项
     调用performSelector:withObject:afterDelay:方法时，先判断希望调用的方法是否存在respondsToSelector:
     这个方法是异步方法，必须在主线程调用，在子线程调用永远不会调用到想调用的方法。
     **/
    
    
    
    
    /*
     有哪些常见的Crash场景？
     访问了僵尸对象
     访问了不存在的方法
     数组越界
     在定时器下一次回调前将定时器释放，会Crash
     **/
    
    /*
     你一般是怎么用Instruments的？
     1. Time Profiler:性能分析
     2. Zoombies:检查是否访问了僵尸对象，但是这个工具只能从上往下检查，不智能
     3. Allocations:用来检查内存，写算法的那批人也用这个来检查
     4. Leaks:检查内存，看是否有内存泄漏
     **/

}

- (void)testThre {
    NSLog(@"2222   %@",[NSThread currentThread]);
}


void test1() {
    

    int a = 10;
    
    void (^block)(void) = ^{
        NSLog(@"a is %d", a);
    };

    a = 20;
    
    block();//10
}

void test2() {
    __block int a = 10;
    
    void (^block)(void) = ^{
        NSLog(@"a is %d", a);
    };
    
    a = 20;
    
    block();//20
}

void test3() {
    static int a = 10;
    
    void (^block)(void) = ^{
        NSLog(@"a is %d", a);
    };
    
    a = 20;
    
    block();//20
}

int a = 10;
void test4() {
    void (^block)(void) = ^{
        NSLog(@"a is %d", a);
    };
    
    a = 20;
    
    block();//20
}

//造成这样的原因是：传值和传址。为什么说会有传值和传址，把.m编译成c++代码。得到.cpp文件，我们来到文件的最后看到如下代码：

/***
 总结：只有普通局部变量是传值，其他情况都是传址。
 
 2、block的定义
 //无参无返回
 void(^block)();
 //无参有返回
 int(^block1)();
 //有参有返回
 int(^block1)(int number)
 
 3、block的内存管理
 
 1. 无论当前环境是ARC还是MRC,只要block没有访问外部变量，block始终在全局区
 2.MRC情况下，
 block如果访问外部变量，block在栈里
 不能对block使用retain，否则不能保存在堆里
 只有使用copy才能放到堆里
 3.ARC情况下
 block如果访问外部变量，block在堆里
 block可以使用copy和strong，并且block是一个对象
 
 4、block的循环引用
    如果要在block中直接使用外部强指针会发生错误，使用以下代码在block外部实现可以解决
 __weak typeof(self) weakSelf = self;
 但是如果在block内部使用延时操作还是用弱指针的话回去不到该弱指针，需要在block内部再将弱指针强引用以下
 __strong typeof(self) strongSelf = weakSelf;
 
 5、block中的weak self,是任何时候都需要加的么？
 不是什么任何时候都需要加的，不过任何时候都添加似乎总是好的。只要出现像self->block->self.property/self->Ivar这样的结构连时，才会出现循环引用问题。
 
 6、block的变量传递
 如果block访问的外部变量是局部变量，那么就是值传递，外界改了，不会影响里面
 如果block访问的外部变量是__block或者static修饰，或者是全局变量，那么就是指针传递，block里面的值和外界同一个变量，外界改变，里面也会改变
 验证一下是不是这样
 通过Clang来将main.m文件编译成C++
 在终端输入如下命令clang -rewrite-objc main.m
 
 void(*block)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0,         &__main_block_desc_0_DATA, (__Block_byref_a_0 *)&a, 570425344));
 void(*block)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0,
 
 可以看到在编译后的代码最后可以发现被__block修饰过的变量使用的是&a,而局部变量是a
 
 7、block的注意点
 在block内部使用外部指针且会造成循环引用情况下，需要用__weak修饰外部指针
 __weak typeof(self) weakSelf = self;
 在block内部如果使用了延时函数还是用弱指针会取不到该指针，因为已经被销毁了，需要在block内部再将弱指针重新强引用一下
 __strong typeof(self) strongSelf = weakSelf;
 如果需要在block内部改变外部变量的话，需要在用__block修饰外部变量
 
 8、使用block有什么好处？使用NSTimer写出一个使用block显示(在UILabel上)秒表的代码。
 说到block的好处，最直接的就是代码紧凑，传值、回调都很方便，省去了写代理的很多代码。
 
 NSTimer *timer = [NSTimer scheduledTimerWIthTimeInterval:1.0 repeats:YES callback:^(){
 weakSelf.secondsLabel.text = ...
 }];
 [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
 
 9、block跟函数很像
 可以保存代码
 有返回值
 有形参
 调用方式一样
 
 
 10、使用系统的某些block api(如UIView的block版本写动画时)，是否也考虑引用循环问题？
 系统的某些block api中，UIView的block版本写动画时不需要考虑，但也有一些api需要考虑。所谓”引用循环“是指双向的强引用。
 所以那些”单向的强引用“(block强引用self)没有问题，比如这些：
 [UIView animateWithDuration:duration animations:^{ [self.superview layoutIfNeeded]; }];
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{ self.someProperty = xyz; }];
 [[NSNotificationCenter defaultCenter] addObserverForName:@"someNotification"
 object:nil
 queue:[NSOperationQueue mainQueue]
 usingBlock:^(NSNotification * notification) {
 self.someProperty = xyz;
 }];
 这些情况不需要考虑"引用循环"。
 但如果你使用一些参数中可能含有成员变量的系统api，如GCD、NSNotificationCenter就要小心一点。比如GCD内部如果引用了self，而且GCD的其他参数是成员变量，则要考虑到循环引用：
 __weak __typeof(self) weakSelf = self;
 dispatch_group_async(_operationsGroup, _operationsQueue, ^{
 __typeof__(self) strongSelf = weakSelf;
 [strongSelf doSomething];
 [strongSelf doSomethingElse];
 });
 类似的：
 __weak __typeof(self) weakSelf = self;
 _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"testKey"
 object:nil
 queue:nil
 usingBlock:^(NSNotification *note) {
 __typeof__(self) strongSelf = weakSelf;
 [strongSelf dismissModalViewControllerAnimated:YES];
 }];
 self –> _observer –> block –> self 显然这也是一个循环引用。
 
 
 
 
 
 **/




@end
