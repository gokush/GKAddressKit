//
//  DistrictEntity.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import Foundation
import CoreData

@objc(DistrictEntity) class DistrictEntity: NSManagedObject {

    @NSManaged var districtId: NSNumber
    @NSManaged var name: String
    @NSManaged var pinyin: String
    @NSManaged var refresh: Bool
    @NSManaged var addresses: NSMutableSet
    @NSManaged var city: CityEntity!
    
    class func insertDistrict(districtId: Int, districtName: String, pinyin: String, managedObjectContext: NSManagedObjectContext) -> DistrictEntity{
        let district = NSEntityDescription.insertNewObjectForEntityForName("DistrictEntity", inManagedObjectContext: managedObjectContext) as DistrictEntity
        district.districtId = districtId
        district.name = districtName
        district.pinyin = pinyin
        return district
    }
    
    class func selectWithId(districtId: Int, managedObjectContext: NSManagedObjectContext) -> DistrictEntity?{
        let predicate = NSPredicate(format: "districtId == \(districtId)")
        let district = fetchItems(predicate!, managedObjectContext: managedObjectContext) as? DistrictEntity
        return district
    }
    
    func updateDistrict(districtId: Int?, name: String?, pinyin: String?){
        if districtId != nil{
            self.districtId = districtId!
        }
        if name != nil{
            self.name = name!
        }
        if pinyin != nil{
            self.pinyin = pinyin!
        }
    }
}

extension DistrictEntity{
    func addCityObject(value: NSManagedObject){
        self.city = value as CityEntity
    }
}

extension DistrictEntity{
    func addAddressesObject(value: AddressEntity){
        self.addresses.addObject(value)
    }
}

