//
//  AddressListController.m
//  GKCommerce
//
//  Created by 小悟空 on 11/15/14.
//  Copyright (c) 2014 GKCommerce. All rights reserved.
//

#import "AddressListController.h"
#import "AddressListTableViewCell.h"

@interface AddressListController ()

@end

@implementation AddressListController

- (id)init
{
    self = [self initWithNibName:@"AddressListView" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithUser:(GKUser *)user
{
    self = [self init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (id)initWithAddress:(NSArray *)addresses
{
    self = [self init];
    self.addresses = addresses;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  UIBarButtonItem *rightButton;
  rightButton = [[UIBarButtonItem alloc]
                 initWithTitle:@"新增" style:UIBarButtonItemStylePlain
                 target:self action:@selector(didTapAddAddress:)];
  self.navigationItem.rightBarButtonItem = rightButton;
    
    for (NSString *identifier in @[@"AddressListTableViewCell"])
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil]
             forCellReuseIdentifier:identifier];
}

- (void)didTapAddAddress:(id)sender
{
//  AddressEditController *controller;
//  controller = [[AddressEditController alloc] initWithAddress:nil
//                                                         user:self.user];
//  [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.addresses.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressListTableViewCell *cell;
    GKAddress *address;
    cell = [tableView
            dequeueReusableCellWithIdentifier:@"AddressListTableViewCell"];
    address = [self.addresses objectAtIndex:indexPath.row];
    cell.address = address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  Address *address;
//  AddressEditController *controller;
//  address = self.addresses[indexPath.row];
//  controller = [[AddressEditController alloc] initWithAddress:address
//                                                         user:self.user];
//  [self.navigationController pushViewController:controller animated:YES];
}

+ (instancetype)addressListControllerWithMock
{
    GKAddress *address = [[GKAddress alloc] init];
    address.name = @"小悟空";
    address.cellPhone = @"15202171763";
    address.postcode = @"900032";
    address.address = @"上海市浦东新区张杨北路 距离市中心约15500米";
    
  GKProvince *province = [[GKProvince alloc] init];
  province.name = @"上海市";
  
  GKCity *city = [[GKCity alloc] init];
  city.name = @"上海市";
  
  GKCounty *county = [[GKCounty alloc] init];
  county.name = @"虹口区";
  
  address.province = province;
  address.city = city;
  address.county = county;
  address.isDefault = YES;
    
    AddressListController *controller;
    controller = [[AddressListController alloc]
                  initWithAddress:@[address]];
    
    return controller;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
