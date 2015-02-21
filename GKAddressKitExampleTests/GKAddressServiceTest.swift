//
//  GKAddressServiceTest.swift
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

import UIKit
import XCTest

class GKAddressServiceTest: XCTestCase {
  
  var service:GKAddressService!;
  
  override func setUp() {
    super.setUp()
    self.service = GKAddressContainerMock().addressService()
    self.service.backend = GKAddressContainerMock().addressBackend()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testAddresses() {
    service.addressesWithUser(nil).subscribeNext {
      let addresses:NSArray = $0 as NSArray
    }
  }
}
