//
//  AddressEditInputTableViewCell.h
//  GKCommerce
//
//  Created by 小悟空 on 14/11/7.
//  Copyright (c) 2014年 GKCommerce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKAddressCommon.h"

@interface AddressEditInputTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) GKAddress *address;
@end
