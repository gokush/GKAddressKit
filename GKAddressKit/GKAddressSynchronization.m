//
//  GKAddressSynchronization.m
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/26/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import "GKAddressSynchronization.h"

@implementation GKAddressSynchronization
- (id)init
{
    self = [super init];
    if (self) {
        self.code = 0;
    }
    return self;
}

- (NSString *)description
{
    return @"";
}
@end

@implementation GKAddressSynchronizationSuccess
- (id)init
{
    self = [super init];
    if (self) {
        self.code = 1;
    }
    return self;
}

- (NSString *)description
{
    return @"提交成功";
}
@end

@implementation GKAddressSynchronizationFailure
- (id)init
{
    self = [super init];
    if (self) {
        self.code = 2;
    }
    return self;
}

- (NSString *)description
{
    return @"提交失败";
}
@end

@implementation GKAddressSynchronizationMissingNetwork
- (id)init
{
    self = [super init];
    if (self) {
        self.code = 3;
    }
    return self;
}

- (NSString *)description
{
    return @"没有网络链接";
}
@end

@implementation GKAddressSynchronizationSending
- (id)init
{
    self = [super init];
    if (self) {
        self.code = 4;
    }
    return self;
}

- (NSString *)description
{
    return @"发送中";
}
@end

@implementation GKAddressSynchronizationAgain
- (id)init
{
    self = [super init];
    if (self) {
        self.code = 5;
    }
    return self;
}

- (NSString *)description
{
    return @"再次重试提交";
}
@end