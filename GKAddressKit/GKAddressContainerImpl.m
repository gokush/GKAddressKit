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
@end