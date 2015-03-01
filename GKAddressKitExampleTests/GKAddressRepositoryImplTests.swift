//
//  GKAddressRepositoryImplTests.swift
//  GKAddressKitExample
//
//  Created by 小悟空 on 3/1/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

import UIKit
import XCTest

class GKAddressRepositoryMock : NSObject, GKAddressRepository {
    func updatePrimary(address: GKAddress!) -> RACSignal! {
        return RACSignal.createSignal({
        (let subscriber:RACSubscriber!) -> RACDisposable! in
            address.updateAt = NSDate()
            address.addressID = 1
            
            subscriber.sendNext(address)
            subscriber.sendCompleted()
            return nil
        })
    }
    
    func findAddressesWithUser(user: GKUser!) -> RACSignal! {
        return nil
    }
    
    func findFailureAddressesWithUser(user: GKUser!) -> RACSignal! {
        return nil
    }
    
    func create(address: GKAddress!) -> RACSignal! {
        return nil
    }
    
    func update(address: GKAddress!) -> RACSignal! {
        return nil
    }
    
    func remove(address: GKAddress!) -> RACSignal! {
        return nil
    }
    
    func setDefault(address: GKAddress!) -> RACSignal! {
        return nil
    }
}

class GKAddressRepositoryImplTests: XCTestCase {
    
    let repository:GKAddressRepositoryMock = GKAddressRepositoryMock()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// [GKAddressRepositoryImpl updatePrimary]的单元测试
    ///
    /// @TODO: 请@tongxiaobo 实现方法
    func testUpdatePrimary() {
        let semaphore:dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        let address:GKAddress = GKAddress()
        address.localID = 1
        
        self.repository.updatePrimary(address) .subscribeNext {
            let blockAddress = $0 as GKAddress
            XCTAssertNotEqual(blockAddress.updateAt, NSNull())
            XCTAssertGreaterThan(blockAddress.addressID, 0)
            
            dispatch_semaphore_signal(semaphore)
        }
        dispatch_semaphore_wait(semaphore,
            dispatch_time(DISPATCH_TIME_NOW, 1000))
    }
}
