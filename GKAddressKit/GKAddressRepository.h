//
//  GKAddressRepository.h
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GKUser.h"
#import "GKAddress.h"

typedef NS_ENUM(NSInteger, GKAddressQueue) {
  GKAddressQueueNone,
  GKAddressQueueCreate,
  GKAddressQueueUpdate,
  GKAddressQueueDelete
};

#define GKADDRESS_QUEUE_FROM_INT(x) \
  x == GKAddressQueueNone ? GKAddressQueueNone : \
  x == GKAddressCreate ? GKAddressCreate : \
  x == GKAddressUpdate ? GKAddressUpdate : \
  x == GKAddressDelete ? GKAddressDelete : -1;

// 发送队列

@protocol GKAddressRepository <NSObject>

- (RACSignal *)findAddressesWithUser:(GKUser *)user;
- (RACSignal *)findFailureAddressesWithUser:(GKUser *)user;
- (RACSignal *)create:(GKAddress *)address;
- (RACSignal *)update:(GKAddress *)address;
- (RACSignal *)remove:(GKAddress *)address;
- (RACSignal *)setDefault:(GKAddress *)address;
@end
