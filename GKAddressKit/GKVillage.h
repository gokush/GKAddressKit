//
//  GKVillage.h
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/19/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKVillage : NSObject

@property (assign, nonatomic) NSInteger villageID;
@property (strong, nonatomic) NSString  *code;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *pinyin;
@property (assign, nonatomic) NSInteger category;
@end
