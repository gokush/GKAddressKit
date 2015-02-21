//
//  GKAddressContainerMock.m
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import "GKAddressContainerMock.h"
#import "GKRegionBackendImpl.h"
#import "GKAddressServiceImpl.h"
#import "GKAddressBackendMock.h"

@implementation GKAddressContainerMock

- (id<GKRegionBackend>)regionBackend
{
  return [[GKRegionBackendImpl alloc] init];
}

- (id<GKAddressService>)addressService
{
  GKAddressServiceImpl *service = [[GKAddressServiceImpl alloc]
          initWithRegionBackend:[self regionBackend]];
  service.backend = [self addressBackend];
  return service;
}

- (id<GKAddressBackend>)addressBackend
{
  return [[GKAddressBackendMock alloc] init];
}

@end
