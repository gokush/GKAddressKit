//
//  GKAddressService.h
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/20/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GKUser.h"

@protocol GKAddressService <NSObject>

- (RACSignal *)provinces;
- (RACSignal *)citiesWithProvinceID:(NSInteger)provinceID;
- (RACSignal *)countiesWithCityID:(NSInteger)cityID;
- (RACSignal *)townsWithCountyID:(NSInteger)countyID;
- (RACSignal *)villagesWithTownID:(NSInteger)TownID;
- (RACSignal *)addressesWithUser:(GKUser *)user;
@end
