//
//  GKRegionBackend.m
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/19/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import "GKRegionBackendImpl.h"
#import "GKAddress.h"

@implementation GKRegionBackendImpl

- (id)init
{
  self = [super init];
  if (self) {
    self.manager = [AFHTTPRequestOperationManager manager];
  }
  return self;
}

- (RACSignal *)fetchProvinces
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [self.manager
     GET:@"http://cnregion.sinaapp.com/json/provinces/" parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSMutableArray *provinces = [[NSMutableArray alloc] init];
       GKProvince *province;
       for (NSDictionary *provinceJSON in (NSArray *)responseObject) {
         province = [[GKProvince alloc] init];
         province.provinceID = [[provinceJSON objectForKey:@"id"] integerValue];
         province.name = [provinceJSON objectForKey:@"name"];
         [provinces addObject:province];
       }
       
       [subscriber sendNext:provinces];
       [subscriber sendCompleted];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [subscriber sendError:error];
       [subscriber sendCompleted];
     }];
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)fetchCitiesWithProvinceID:(NSInteger)provinceID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSString *formatURL = @"http://cnregion.sinaapp.com/json/cities/%d/";
    [self.manager
     GET:[NSString stringWithFormat:formatURL, (int)provinceID] parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSMutableArray *provinces = [[NSMutableArray alloc] init];
       GKProvince *province;
       for (NSDictionary *provinceJSON in (NSArray *)responseObject) {
         province = [[GKProvince alloc] init];
         province.provinceID = [[provinceJSON objectForKey:@"id"] integerValue];
         province.name = [provinceJSON objectForKey:@"name"];
         [provinces addObject:province];
       }
       
       [subscriber sendNext:provinces];
       [subscriber sendCompleted];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [subscriber sendError:error];
       [subscriber sendCompleted];
     }];
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)fetchCountiesWithCityID:(NSInteger)cityID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSString *formatURL = @"http://cnregion.sinaapp.com/json/counties/%d/";
    [self.manager
     GET:[NSString stringWithFormat:formatURL, (int)cityID] parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSMutableArray *provinces = [[NSMutableArray alloc] init];
       GKProvince *province;
       for (NSDictionary *provinceJSON in (NSArray *)responseObject) {
         province = [[GKProvince alloc] init];
         province.provinceID = [[provinceJSON objectForKey:@"id"] integerValue];
         province.name = [provinceJSON objectForKey:@"name"];
         [provinces addObject:province];
       }
       
       [subscriber sendNext:provinces];
       [subscriber sendCompleted];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [subscriber sendError:error];
       [subscriber sendCompleted];
     }];
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)fetchTownsWithCountyID:(NSInteger)countyID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSString *formatURL = @"http://cnregion.sinaapp.com/json/towns/%d/";
    [self.manager
     GET:[NSString stringWithFormat:formatURL, (int)countyID] parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSMutableArray *provinces = [[NSMutableArray alloc] init];
       GKProvince *province;
       for (NSDictionary *provinceJSON in (NSArray *)responseObject) {
         province = [[GKProvince alloc] init];
         province.provinceID = [[provinceJSON objectForKey:@"id"] integerValue];
         province.name = [provinceJSON objectForKey:@"name"];
         [provinces addObject:province];
       }
       
       [subscriber sendNext:provinces];
       [subscriber sendCompleted];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [subscriber sendError:error];
       [subscriber sendCompleted];
     }];
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (RACSignal *)fetchVillagesWithTownID:(NSInteger)TownID
{
  return
  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSString *formatURL = @"http://cnregion.sinaapp.com/json/villages/%d/";
    [self.manager
     GET:[NSString stringWithFormat:formatURL, (int)TownID] parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSMutableArray *provinces = [[NSMutableArray alloc] init];
       GKProvince *province;
       for (NSDictionary *provinceJSON in (NSArray *)responseObject) {
         province = [[GKProvince alloc] init];
         province.provinceID = [[provinceJSON objectForKey:@"id"] integerValue];
         province.name = [provinceJSON objectForKey:@"name"];
         [provinces addObject:province];
       }
       
       [subscriber sendNext:provinces];
       [subscriber sendCompleted];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [subscriber sendError:error];
       [subscriber sendCompleted];
     }];
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}
@end
