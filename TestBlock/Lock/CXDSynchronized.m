//
//  CXDSynchronized.m
//  TestBlock
//
//  Created by xiao zude on 2019/9/29.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDSynchronized.h"

@interface CXDSynchronized ()



@end

@implementation CXDSynchronized


- (void)__saveMoney {
    @synchronized (self) {
        [super __saveMoney];
    }
}

- (void)__drawMoney {
    @synchronized (self) {
        [super __drawMoney];
    }
}


/*
 @synchronized是对mutex递归锁的封装
 源码查看：objc4中的objc-sync.mm文件
 @synchronized(obj)内部会生成obj对应的递归锁，然后进行加锁解锁操作
 
 
 
 int objc_sync_enter(id obj)
 {
     int result = OBJC_SYNC_SUCCESS;

     if (obj) {
         SyncData* data = id2data(obj, ACQUIRE);
         assert(data);
         data->mutex.lock();
     } else {
         // @synchronized(nil) does nothing
         if (DebugNilSync) {
             _objc_inform("NIL SYNC DEBUG: @synchronized(nil); set a breakpoint on objc_sync_nil to debug");
         }
         objc_sync_nil();
     }

     return result;
 }

 // End synchronizing on 'obj'.
 // Returns OBJC_SYNC_SUCCESS or OBJC_SYNC_NOT_OWNING_THREAD_ERROR
 int objc_sync_exit(id obj)
 {
     int result = OBJC_SYNC_SUCCESS;

     if (obj) {
         SyncData* data = id2data(obj, RELEASE);
         if (!data) {
             result = OBJC_SYNC_NOT_OWNING_THREAD_ERROR;
         } else {
             bool okay = data->mutex.tryUnlock();
             if (!okay) {
                 result = OBJC_SYNC_NOT_OWNING_THREAD_ERROR;
             }
         }
     } else {
         // @synchronized(nil) does nothing
     }

     return result;
 }
 
 
 typedef struct alignas(CacheLineSize) SyncData {
     struct SyncData* nextData;
     DisguisedPtr<objc_object> object;
     int32_t threadCount;  // number of THREADS using this block
     recursive_mutex_t mutex;
 } SyncData;
 
 
 using recursive_mutex_t = recursive_mutex_tt<LOCKDEBUG>;
 **/


@end
