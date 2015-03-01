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
  
  func testCreate() {
    let address:GKAddress = GKAddress()
    let semaphore:dispatch_semaphore_t = dispatch_semaphore_create(0)
    
    service.create(address).subscribeNext({
      let parameters:RACTuple = $0 as  RACTuple
      let address:GKAddress = parameters.first as GKAddress
      XCTAssertEqual(false, (address == NSNull()))
      dispatch_semaphore_signal(semaphore)
    },
    error: {
      let error:NSError = $0 as NSError;
      XCTAssert(false);
      dispatch_semaphore_signal(semaphore)
    })
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
  }
}
