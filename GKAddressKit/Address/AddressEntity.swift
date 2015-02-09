//
//  AddressEntity.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import Foundation
import CoreData

@objc(AddressEntity) class AddressEntity: NSManagedObject {

    @NSManaged var addressId: NSNumber
    @NSManaged var name: String
    @NSManaged var cellphone: String
    @NSManaged var postcode: String
    @NSManaged var address: String
    @NSManaged var isDefault: NSNumber
    @NSManaged var province: ProvinceEntity
    @NSManaged var city: CityEntity
    @NSManaged var district: DistrictEntity

    class func insertAddress(addressId: Int, name: String, cellphone: String, postcode: String, address: String, isdefault: Bool, province: ProvinceEntity, city: CityEntity, district: DistrictEntity, managedObjectContext: NSManagedObjectContext) -> AddressEntity?{
        let predicate = NSPredicate(format: "addressId == \(addressId)")
        let addressEntity = insertItem(predicate!, managedObjectContext: managedObjectContext) { (object) -> Void in
            let address = object as AddressEntity
            
        }
        return addressEntity as? AddressEntity
    }
    
    class func selectWithId(addressId: Int, managedObjectContext: NSManagedObjectContext) -> AddressEntity?{
        let predicate = NSPredicate(format: "addressId == \(addressId)")
        let addressEntity = fetchItems(predicate!, managedObjectContext: managedObjectContext) as? AddressEntity
        return addressEntity
    }
    
    func updateAddress(name: String?, cellphone: String?, postcode: String?, address: String?, isDefault: Bool?, province: ProvinceEntity?, city: CityEntity?, district: DistrictEntity?){
        
    }
    
}

extension AddressEntity{
    func addProvinceObject(value: ProvinceEntity){
        self.province = value
    }
    func addCityObject(value: CityEntity){
        self.city = value
    }
    func addDistrictObject(value: DistrictEntity){
        self.district = value
    }
}
