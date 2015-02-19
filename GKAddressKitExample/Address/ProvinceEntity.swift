//
//  ProvinceEntity.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import Foundation
import CoreData

@objc(ProvinceEntity) class ProvinceEntity: NSManagedObject {

    @NSManaged var provinceId: NSNumber
    @NSManaged var name: String
    @NSManaged var pinyin: String
    @NSManaged var refresh: Bool
    @NSManaged var addresses: NSMutableSet
    @NSManaged var cities: NSMutableSet
    
    class func insertProvince(provinceId: Int, provinceName: String, pinyin: String, managedObjectContext: NSManagedObjectContext) -> ProvinceEntity{
        let province = NSEntityDescription.insertNewObjectForEntityForName("ProvinceEntity", inManagedObjectContext: managedObjectContext) as ProvinceEntity
        province.provinceId = provinceId
        province.name = provinceName
        province.pinyin = pinyin
        return province
    }
    
    class func selectWithId(provinceId: Int, managedObjectContext: NSManagedObjectContext) -> ProvinceEntity?{
        let predicate = NSPredicate(format: "provinceId == \(provinceId)")
        let province = fetchItems(predicate!, managedObjectContext: managedObjectContext) as? ProvinceEntity
        return province
    }
    
    func updateProvince(provinceId: Int?, name: String?, pinyin: String?){
        if provinceId != nil{
            self.provinceId = provinceId!
        }
        if name != nil{
            self.name = name!
        }
        if pinyin != nil{
            self.pinyin = pinyin!
        }
    }
}

extension ProvinceEntity{
    func addCitiesObject(value: NSManagedObject){
        self.cities.addObject(value)
    }
    func removeCitiesObject(value: NSManagedObject){
        self.cities.removeObject(value)
    }
    func removeCities(values: [NSManagedObject]){
        for item in values{
            self.removeCitiesObject(item)
        }
    }
}

extension ProvinceEntity{
    func addAddressesObject(value: AddressEntity){
        self.addresses.addObject(value)
    }
    func removeAddressesObject(value: AddressEntity){
        self.addresses.removeObject(value)
    }
}
