//
//  CXDBaseLock.h
//  TestBlock
//
//  Created by xiao zude on 2019/9/27.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXDBaseLock : NSObject

/// 存钱、取钱演示
- (void)moneyTest;

/// 存钱
- (void)__saveMoney;

/// 取钱
- (void)__drawMoney;

@end

NS_ASSUME_NONNULL_END
