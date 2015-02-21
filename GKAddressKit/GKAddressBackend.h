//
//  GKAddressBackend.h
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol GKAddressBackend <NSObject>

- (RACSignal *)fetchAddresses;
@end
