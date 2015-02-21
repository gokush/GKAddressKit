//
//  GKAdressServiceImpl.h
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKAddressService.h"
#import "GKRegionBackend.h"

@interface GKAddressServiceImpl : NSObject <GKAddressService>

@property (strong, nonatomic) id<GKRegionBackend> regionBackend;

- (id)initWithRegionBackend:(id<GKRegionBackend>)regionBackend;
- (RACSignal *)provinces;
- (RACSignal *)citiesWithProvinceID:(NSInteger)provinceID;
- (RACSignal *)countiesWithCityID:(NSInteger)cityID;
- (RACSignal *)townsWithCountyID:(NSInteger)countyID;
- (RACSignal *)villagesWithTownID:(NSInteger)TownID;
@end
