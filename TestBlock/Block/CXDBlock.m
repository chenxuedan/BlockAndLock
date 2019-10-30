//
//  CXDBlock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/29.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDBlock.h"
#import "CXDPerson.h"
#import "CXDSubPerson.h"

@interface CXDBlock ()

@end

@implementation CXDBlock

- (void)test {
    
//    [self tttt];
    
//    CXDSubPerson *per = [[CXDSubPerson alloc] init];
//    NSLog(@"%@",[per class]);
//    [per test];
//    
//    NSMutableString *testString = [[NSMutableString alloc] initWithString:@"1124"];
//    NSLog(@"%p   %@",&testString, testString);
//    testString = [NSMutableString stringWithString:@"3333"];
//    NSLog(@"%p   %@",&testString, testString);
//
//    testString = [[NSMutableString alloc] initWithFormat:@"666"];
//    NSLog(@"%p   %@",&testString, testString);

    
    [self ageDemo];
}


- (void)ageDemo {
    typedef void (^Block)(void);
        __block int age = 10;
    //    int age = 10;

//        NSLog(@"1111age  %d  %p", age, &age);

        NSMutableArray *array = [NSMutableArray array];
        NSLog(@"111array  %@   %p", array, &array);

        Block block = ^{
    //        age = 20;  //无法修改
            [array addObject:@"3"];
            NSLog(@"bbbage   %d  %p", age, &age);
           NSLog(@"bbbbbbarray  %@   %p", array, &array);
        };
        
//        age = 666;
//        NSLog(@" qweqweqweage   %d   %p", age, &age);

        
        block();

        NSLog(@"qweqweqwearray  %@   %p", array, &array);
}

- (void)age2 {
    typedef void (^Block)(void);
        __block int age = 10;
        NSLog(@"1111age  %d  %p", age, &age);
        Block block = ^{
            age = 20;  //无法修改
            NSLog(@"bbbage   %d  %p", age, &age);
        };
        age = 666;
        NSLog(@" qweqweqweage   %d   %p", age, &age);
        block();
}

- (void)age1 {
    typedef void (^Block)(void);
        int age = 10;
        NSLog(@"1111age  %d  %p", age, &age);   //0x16b72527c
        Block block = ^{
    //        age = 20;  //无法修改
            NSLog(@"bbbage   %d  %p", age, &age);  //0x1d4450640
        };
        age = 666;
        NSLog(@" qweqweqweage   %d   %p", age, &age);  //0x16b72527c
        block();

}


typedef void (^Block)(void);
- (void)tttt {
    Block block;
    CXDPerson *person = [[CXDPerson alloc] init];
    person.age = 10;
    
    block = ^{
        NSLog(@"-----block内部%ld",(long)person.age);
    };
    NSLog(@"-----");
}


/*
 在ARC环境下，编译器会根据情况自动将栈上的block进行一次copy操作，将block复制到堆上。
 什么情况下ARC会自动将block进行一次copy操作？
 
 
 block对对象变量的捕获
 
 
 
 
 在MRC环境下block在栈空间，栈空间对外面的person不会进行强引用。
 
 
 总结
 1.一旦block中捕获的变量为对象类型，block结构体中的__main_block_desc_0会出两个参数copy和dispose。因为访问的是个对象，Block希望拥有这个对象，就需要对对象进行引用，也就是进行内存管理的操作。比如说对对象进行retain操作，因此一但block捕获的变量时对象类型就会自动生成copy和dispose来对内部引用的对象进行内存管理。
 2. 当block内部访问了对象类型的auto变量时，如果block是在栈上，block内部不会对person产生强引用。不论block结构体内部的变量是__strong修饰还是__weak修饰，都不会对变量产生强引用。
 3. 如果block被拷贝到堆上，copy函数会调用_Block_objct_assign函数，根据auto变量的修饰符(__strong、__weak、unsafef_unretained)做出相应的操作，形成强引用或弱引用。
 4. 如果block从堆中移除，dispose函数会调用_Block_objct_dispose函数，自动释放引用的auto变量。
 
 
 **/


- (void)test2 {
    void (^block1)(void) = ^{
        NSLog(@"block1-------");
    };
    
    int a = 0;
    void (^block2)(void) = ^{
        NSLog(@"block2 ----- %d", a);
    };
    
    NSLog(@"%@  %@   %@",[block1 class], [block2 class], [^{
        NSLog(@"block3 ----, %d",a);
    } class]);
    
    NSLog(@"%@", [[block2 copy] class]);
    
    /*
    MRC：  __NSGlobalBlock__  __NSStackBlock__   __NSMallocBlock__
    ARC:   __NSGlobalBlock__  __NSMallocBlock__   __NSMallocBlock__
    **/
}

- (void)test1 {
    void (^block1)(void) = ^{
        NSLog(@"block1-------");
    };
    
    int a = 0;
    void (^block2)(void) = ^{
        NSLog(@"block2 ----- %d", a);
    };
    
    NSLog(@"%@  %@",[block1 class], [block2 class]);
    
    NSLog(@"%@", [[block2 copy] class]);
    
    /*
     MRC：  __NSGlobalBlock__  __NSStackBlock__   __NSMallocBlock__
     ARC:   __NSGlobalBlock__  __NSMallocBlock__   __NSMallocBlock__
     **/

}



/*
 1. block的原理是怎样的？本质是什么？
 2. __block的作用是什么？有什么使用注意点？
 3. block的属性修饰词为什么是copy？使用block有什么使用注意？
 4. block在修改NSMutableArray,需不需要添加__block？
 
 
 block本质上也是一个对象。
 
 
 
 
 block内修改变量的值。
 
 typedef void (^Block)(void);
 int main(int argc, const char *argv[]) {
    @autoreleasepool {
    int age = 10;
    Block block = ^{
       // age = 20;  //无法修改
       NSLog(@"%d", age);
    };
    block();
 }
 }
 
 
 默认情况下block不能修改外部的局部变量。
 age是在main函数内部声明的，说明age的内存存在于main函数的栈空间内部，但是block内部的代码在__main_block_func_0函数内部。__main_block_func_0函数内部无法访问age变量的内存空间，两个函数的栈空间不一样，__main_block_func_0内部拿到的age是block结构体内部的age，因此无法在__main_block_func_0函数内部去修改main函数内部的变量。
 
 方式一：age使用static修饰
 static修饰的age变量传递到block内部的是指针，在__main_block_func_0函数内部就可以拿到age变量的内存地址，因此就可以在block内部修改age的值。
 
 方式二：__block
 __blcok用于解决block内部不能修改auto变量值的问题，__block不能修饰静态变量(static)和全局变量
 __block int age = 10;
 
 编译器会将__block修饰的变量包装成一个对象，查看底层C++源码
 
 首先被__block修饰的age变量声明变为名为age的__Block_byref_age_0结构体，也就是说加上__block修饰的话捕获到的block内的变量为__Block_byref_age_0类型的结构体。
 
 __Block_byref_age_0结构体内存储哪些元素
 __isa指针：__Block_byref_age_0结构体类型也有isa指针也就是说__Block_byref_age_0本质也是一个对象。
 __forwarding：__frawarding是__Block_byref_age_0结构体类型的，并且__forwarding存储的值为(__Block_byref_age_0 *)&age，即结构体自己的内存地址。
 __flags：0
 __size：sizeof(__Block_byref_age_0)即__Block_byref_age_0所占用的内存空间。
 age：真正存储变量的地方，这里存储局部变量10
 
 接着将__Block_byref_age_0结构体age存入__main_block_impl_0结构体中，并赋值给__Block_byref_age_0 *age;
 
 之后调用block，首先取出__main_block_impl_0中的age，通过age结构体拿到__forwarding指针，上面提到过__forwarding中保存的就是__Block_byref_age_0结构体本身，这里也就是age(__Block_byref_age_0),在通过__forwarding拿到结构体中的age(10)变量并修改其值。
 
 
 为什么要通过__forwarding获取age变量的值？
 __forwarding是指向自己的指针。这样的做法是为了方便内存管理。
 
 到此为止，__block为什么能修改变量的值已经很清晰了。__block将变量包装成对象，然后在把age封装在结构体里面，block内部存储的变量为结构体指针，也就可以通过指针找到内存地址进而修改变量的值。
 
 __block修饰对象类型
 将对象包装在一个新的结构体中，结构体内部会有一个person对象，不一样的地方是结构体内部添加了内存管理的两个函数__Block_byref_is_objct_copy和__Block_byref_is_objct_dispose
 
 
 
 以下代码是否可以正确执行
 int main(int argc, const char *argv[]) {
 @autoreleasepool {
  NSMutableArray *array = [[NSMutableArray alloc] init];
 Block blcok = ^{
 [array addObject:@"5"];
 [array addObject:@"5"];
 NSLog(@"%@", array);
 };
 block();
 }
 return 0;
 }
  
 答：可以正确执行，因为在block块中仅仅是使用了array的内存地址，往内存地址中添加内容，并没有修改array的内存地址，因此array不需要使用__block修饰也可以正确编译
 
 因此当仅仅是使用局部变量的内存地址，而不是修改的时候，尽量不要添加__block,通过上述分析我们知道一旦添加了__block修饰符，系统会自动创建相应的结构体，占用不必要的内存空间。
 
 
 **/

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CXDPerson *person = [[CXDPerson alloc] init];
//    __weak CXDPerson *weakPerson = person;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%@",weakPerson);
//
//        NSLog(@"%@", person);
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            NSLog(@"%@",weakPerson);
////        });
//    });
//    NSLog(@"touchBegin--------End");
//}

/*
 CXDPerson *person = [[CXDPerson alloc] init];
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     NSLog(@"%@", person);
 });
 NSLog(@"touchBegin--------End");
 
 
 touchBegin--------End
 <CXDPerson: 0x1cc01df90>
 释放了
 
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     CXDPerson *person = [[CXDPerson alloc] init];
     __weak CXDPerson *weakPerson = person;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"%@", weakPerson);
     });
     NSLog(@"touchBegin--------End");
 }
 
 touchBegin--------End
 释放了
 (null)
 
 
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     CXDPerson *person = [[CXDPerson alloc] init];
     __weak CXDPerson *weakPerson = person;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"%@", weakPerson);
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"%@",person);
         });
     });
     NSLog(@"touchBegin--------End");
 }
 
 touchBegin--------End
 <CXDPerson: 0x1c400beb0>
 <CXDPerson: 0x1c400beb0>
 释放了
 
 
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     CXDPerson *person = [[CXDPerson alloc] init];
     __weak CXDPerson *weakPerson = person;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"%@", person);
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"%@",weakPerson);
         });
     });
     NSLog(@"touchBegin--------End");
 }
 
 touchBegin--------End
 <CXDPerson: 0x1c4015b30>
 释放了
 (null)
 **/





@end
