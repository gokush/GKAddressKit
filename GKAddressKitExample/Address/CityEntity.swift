//
//  CityEntity.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import Foundation
import CoreData

@objc(CityEntity) class CityEntity: NSManagedObject {

    @NSManaged var cityId: NSNumber
    @NSManaged var name: String
    @NSManaged var pinyin: String
    @NSManaged var refresh: Bool
    @NSManaged var addresses: NSMutableSet
    @NSManaged var province: ProvinceEntity!
    @NSManaged var districts: NSMutableSet
    
    class func insertCity(cityId: Int, cityName: String, pinyin: String, managedObjectContext: NSManagedObjectContext) -> CityEntity{
        let city = NSEntityDescription.insertNewObjectForEntityForName("CityEntity", inManagedObjectContext: managedObjectContext) as CityEntity
        city.cityId = cityId
        city.name = cityName
        city.pinyin = pinyin
        return city
    }
    
    class func selectWithId(cityId: Int, managedObjectContext: NSManagedObjectContext) -> CityEntity?{
        let predicate = NSPredicate(format: "cityId == \(cityId)")
        let city = fetchItems(predicate!, managedObjectContext: managedObjectContext) as? CityEntity
        return city
    }
    
    func updateCity(cityId: Int?, name: String?, pinyin: String?){
        if cityId != nil{
            self.cityId = cityId!
        }
        if name != nil{
            self.name = name!
        }
        if pinyin != nil{
            self.pinyin = pinyin!
        }
    }
}

extension CityEntity{
    func addProvinceObject(value: NSManagedObject){
        self.province = value as ProvinceEntity
    }
}

extension CityEntity{
    func addDistrictsObject(value: NSManagedObject){
        self.districts.addObject(value)
    }
    func removeDistrictsObject(value: NSManagedObject){
        self.districts.removeObject(value)
    }
    func removeDistricts(values: [NSManagedObject]){
        for item in values{
            self.removeDistrictsObject(item)
        }
    }
}

extension CityEntity{
    func addAddressesObject(value: AddressEntity){
        self.addresses.addObject(value)
    }
}
