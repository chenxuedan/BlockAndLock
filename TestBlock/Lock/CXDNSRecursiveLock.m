//
//  CXDNSRecursiveLock.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDNSRecursiveLock.h"


@interface CXDNSRecursiveLock ()

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation CXDNSRecursiveLock
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)__saveMoney {
    [self.lock lock];
    [super __saveMoney];
    [self.lock unlock];
}

- (void)__drawMoney {
    [self.lock lock];
    [super __drawMoney];
    [self.lock unlock];
}

- (void)dealloc {
    
}



@end
