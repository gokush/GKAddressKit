//
//  GKAddressRepositoryImplTests.swift
//  GKAddressKitExample
//
//  Created by 小悟空 on 3/1/15.
//  Copyright (c) 2015 Goku. All rights reserved.
//

import UIKit
import XCTest
/*
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
*/
class GKAddressRepositoryImplTests: XCTestCase {
    
//    let repository:GKAddressRepositoryMock = GKAddressRepositoryMock()
//    var addressRepository: GKAddressRepository!
//    var addressRepository: AddressRespository!
    var addressRepository: AddressRepository!
    
    override func setUp() {
        super.setUp()
        
        let persistenStack = PersistenStack(storeURL: storeURL(), modelURL: modelURL())
        addressRepository = AddressRepository.sharedInstance
        addressRepository.managedObjectContext = persistenStack.managedObjectContext
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// [GKAddressRepositoryImpl updatePrimary]的单元测试
    ///
    /// @TODO: 请@tongxiaobo 实现方法
    func testFindAddressesWithUser(){
        let user = GKUser()
        user.userID = 1
        
        let semaphore:dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        addressRepository.findAddressesWithUser(user).subscribeNext({ (address) -> Void in
            
            println(address)
            
            dispatch_semaphore_signal(semaphore)
            
        }, error: { (error) -> Void in
            
            dispatch_semaphore_signal(semaphore)
            return
            
        })
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func testFindProvinceWithId(){
        let province = addressRepository.findProvinceWithId(1)
        if province != nil{
            println(province?.name)
        }
    }
    
    func testFindFailureAddressesWithUser(){
    
    }
    
    func testCreate(){
    
    }
    
    func testUpdate(){
    
    }
    
    func testRemove(){
    
    }
    
    func testSetDefault(){
        
    }
    
    func testUpdateProvince(){
        let jsonPath = NSBundle.mainBundle().pathForResource("province", ofType: "json")
        let jsonData = NSData(contentsOfFile: jsonPath!)
        let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as [AnyObject]
        
        addressRepository.updateProvince(jsonArray)
        
        println("end")
        
    }
    
//    func testFetchProvinces(){
//        let provinces = addressRepository.fetchProvinces()
//        for item in provinces{
//            print("\(item.name)    ")
//            println(item.addresses.count)
//            let cities = item.cities.allObjects as [CityEntity]
//            for item in cities{
//                print("    ")
//                println(item.name)
//                let districts = item.districts.allObjects as [DistrictEntity]
//                for item in districts{
//                    print("          ")
//                    println(item.name)
//                }
//            }
//        }
//    }
    
    func testUpdatePrimary() {
//        let semaphore:dispatch_semaphore_t = dispatch_semaphore_create(0)
//        
//        let address:GKAddress = GKAddress()
//        address.localID = 1
//        
//        self.addressRepository.updatePrimary(address) .subscribeNext {
//            let blockAddress = $0 as GKAddress
//            XCTAssertNotEqual(blockAddress.updateAt, NSNull())
//            XCTAssertGreaterThan(blockAddress.addressID, 0)
//            
//            dispatch_semaphore_signal(semaphore)
//        }
//        dispatch_semaphore_wait(semaphore,
//            dispatch_time(DISPATCH_TIME_NOW, 1000))
    }
    
    func storeURL() -> NSURL{
        let url = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        return url!.URLByAppendingPathComponent("addressmodel.sql")
    }
    
    func modelURL() -> NSURL{
        return NSBundle.mainBundle().URLForResource("GKAddressModel", withExtension: "momd")!
    }
}
