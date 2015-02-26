//
//  GKAddressContainerImpl.m
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import "GKAddressContainerImpl.h"
#import "GKRegionBackendImpl.h"
#import "GKAddressServiceImpl.h"
#import "GKAddressBackendImpl.h"

@implementation GKAddressContainerImpl

- (id<GKRegionBackend>)regionBackend
{
  return [[GKRegionBackendImpl alloc] init];
}

- (id<GKAddressService>)addressService
{
  return [[GKAddressServiceImpl alloc]
          initWithRegionBackend:[self regionBackend]];
}

- (id<GKAddressBackend>)addressBackend
{
  return [[GKAddressBackendImpl alloc] init];
}

- (id<GKAddressRepository>)addressRepository
{
  return nil;
}
@end
