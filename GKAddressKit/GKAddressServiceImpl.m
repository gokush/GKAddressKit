//
//  GKAdressServiceImpl.m
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import "GKAddressServiceImpl.h"
#import "GKAddressCommon.h"

#import "GKAddressKitExample-Swift.h"

@implementation GKAddressServiceImpl

- (id)initWithRegionBackend:(id<GKRegionBackend>)regionBackend
{
  self = [super init];
  if (self) {
    self.regionBackend = regionBackend;
  }
  return self;
}

- (RACSignal *)provinces
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
    [[self.regionBackend fetchProvinces] subscribeNext:^(id x) {
      [subscriber sendNext:x];
      [subscriber sendCompleted];
    } error:^(NSError *error) {
      [subscriber sendError:error];
      [subscriber sendCompleted];
    }];
    
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)citiesWithProvinceID:(NSInteger)provinceID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)countiesWithCityID:(NSInteger)cityID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)townsWithCountyID:(NSInteger)countyID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)villagesWithTownID:(NSInteger)TownID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)addressesWithUser:(GKUser *)user
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
    [[self.repository findAddressesWithUser:user]
     subscribeNext:^(NSArray *addresses) {
      [subscriber sendNext:addresses];
    }];
     
    [[self.backend fetchAddresses] subscribeNext:^(id x) {
      [subscriber sendNext:x];
      [subscriber sendCompleted];
    } error:^(NSError *error) {
      [subscriber sendError:error];
      [subscriber sendCompleted];
    }];
    
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

@end
