//
//  GKAddressKitBackendTest.swift
//  GKAddressKitExample
//
//  Created by 小悟空 on 2/21/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

import UIKit
import XCTest

class GKAddressKitBackendTest: XCTestCase {
  
  let backend:GKAddressBackend = GKAddressContainerMock().addressBackend()
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    XCTAssert(true, "Pass")
  }
  
  func testFetchAddresses() {
    backend.fetchAddresses().subscribeNext {
      let addresses:NSArray = $0 as NSArray
      XCTAssertEqual(1, addresses.count)
    }
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
