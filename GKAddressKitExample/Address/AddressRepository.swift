//
//  AddressRepository.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/20.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import UIKit
import CoreData

class AddressRepository: NSObject, GKAddressRepository {
    var managedObjectContext: NSManagedObjectContext?
    
    class var sharedInstance: AddressRepository{
        struct Static{
            static let instance: AddressRepository = AddressRepository()
        }
        return Static.instance
    }
  
    /*
     * 方法重写在Objective-C中不可用
  
    func deleteAddress(addressID: Int){
        
    }
    */
    
    func findAddressesWithUser(user: GKUser!) -> RACSignal! {
        let fetchRequest = NSFetchRequest(entityName: "AddressEntity")
        fetchRequest.predicate = NSPredicate(format: "user")
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
    }
    
    func create(address: GKAddress!) -> RACSignal! {
        
    }
    
    func update(address: GKAddress!) -> RACSignal! {
        
    }
    
    func deleteAddress(address: AddressEntity){
        self.managedObjectContext?.deleteObject(address)
        save()
    }
    
    //添加新地址
    func insertAddressWithId(addressId: Int, name: String, cellphone: String, postCode: String, province: ProvinceEntity, city: CityEntity, district: DistrictEntity, address: String, isDefault: Bool){
        let address = NSEntityDescription.insertNewObjectForEntityForName("AddressEntity", inManagedObjectContext: managedObjectContext!) as AddressEntity
        address.addressId = addressId
        address.name = name
        address.cellphone = cellphone
        address.postcode = postCode
        address.addProvinceObject(province)
        province.addAddressesObject(address)
        address.addCityObject(city)
        city.addAddressesObject(address)
        address.addDistrictObject(district)
        district.addAddressesObject(address)
        save()
    }
    //更新地址
    func updateAddress(){
        
    }
    //fetchedresultscontroller
    func fetchedResultsController() -> NSFetchedResultsController{
        let fetchRequest = NSFetchRequest(entityName: "AddressEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addressId", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    //获取所有省份
    func fetchProvinces() -> [ProvinceEntity]{
        let fetchRequest = NSFetchRequest(entityName: "ProvinceEntity")
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
        return results as [ProvinceEntity]
    }
    
    func fetchDistricts() -> [DistrictEntity]?{
        let fetchRequest = NSFetchRequest(entityName: DistrictEntity.entityName())
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [DistrictEntity]
        return results
    }
    //更新省份信息
    func updateProvince(jsonArray: [AnyObject]){
        resetProvinceRefresh()
        resetCityRefresh()
        resetDistrictRefresh()
        for item in jsonArray{
            if let dic = item as? [String: AnyObject]{
                let provinceId = dic["id"] as Int
                let name = dic["name"] as String
                let pinyin = dic["pinyin"] as String
                let cities = dic["cities"] as [AnyObject]
                var province = ProvinceEntity.selectWithId(provinceId, managedObjectContext: managedObjectContext!)
                if  province == nil{
                    province = ProvinceEntity.insertProvince(provinceId, provinceName: name, pinyin: pinyin, managedObjectContext: managedObjectContext!)
                    province?.refresh = true
                }
                else{
                    province?.updateProvince(provinceId, name: name, pinyin: pinyin)
                    province?.refresh = true
                }
                updateCity(cities, province: province!)
            }
        }
        clearNoRefreshProvince()
        clearNoRefreshCity()
        clearNoRefreshDistrict()
        save()
    }
    
    func updateCity(jsonArray: [AnyObject], province: ProvinceEntity){
        for item in jsonArray{
            if let dic = item as? [String: AnyObject]{
                let cityId = dic["id"] as Int
                let name = dic["name"] as String
                let pinyin = dic["pinyin"] as String
                let district = dic["districts"] as [AnyObject]
                var city = CityEntity.selectWithId(cityId, managedObjectContext: managedObjectContext!)
                if  city == nil{
                    city = CityEntity.insertCity(cityId, cityName: name, pinyin: pinyin, managedObjectContext: managedObjectContext!)
                    city?.refresh = true
                    province.addCitiesObject(city!)
                    city!.addProvinceObject(province)
                }
                else{
                    if city?.province.provinceId == province.provinceId{
                        city?.cityId = cityId
                        city?.name = name
                        city?.pinyin = pinyin
                        city?.refresh = true
                    }
                    else{
                        let prov = city?.province
                        prov?.removeCitiesObject(city!)
                        managedObjectContext?.deleteObject(city!)
                        let newCity = CityEntity.insertCity(cityId, cityName: name, pinyin: pinyin, managedObjectContext: managedObjectContext!)
                        city?.refresh = true
                        province.addCitiesObject(newCity)
                        newCity.addProvinceObject(province)
                    }
                }
                updateDistrict(district, city: city!)
            }
        }
        save()
    }
    
    func updateDistrict(jsonArray: [AnyObject], city: CityEntity){
        for item in jsonArray{
            if let dic = item as? [String: AnyObject]{
                let districtId = dic["id"] as Int
                let name = dic["name"] as String
                let pinyin = dic["pinyin"] as String
                var district = DistrictEntity.selectWithId(districtId, managedObjectContext: managedObjectContext!)
                if  district == nil{
                    let newDistrict = DistrictEntity.insertDistrict(districtId, districtName: name, pinyin: pinyin, managedObjectContext: managedObjectContext!)
                    newDistrict.refresh = true
                    city.addDistrictsObject(newDistrict)
                    newDistrict.addCityObject(city)
                }
                else{
                    if district?.city.cityId == city.cityId{
                        district?.districtId = districtId
                        district?.name = name
                        district?.pinyin = pinyin
                        district?.refresh = true
                    }
                    else{
                        let oldCity = district?.city
                        oldCity?.removeDistrictsObject(district!)
                        managedObjectContext?.deleteObject(district!)
                        let newDistrict = DistrictEntity.insertDistrict(districtId, districtName: name, pinyin: pinyin, managedObjectContext: managedObjectContext!)
                        newDistrict.refresh = true
                        city.addDistrictsObject(newDistrict)
                        newDistrict.addCityObject(city)
                    }
                }
            }
        }
        save()
    }
    
    func resetProvinceRefresh(){
        let fetchRequest = NSFetchRequest(entityName: ProvinceEntity.entityName())
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [ProvinceEntity]
        if results != nil{
            for item in results!{
                item.refresh = false
            }
        }
    }
    
    func resetCityRefresh(){
        let fetchRequest = NSFetchRequest(entityName: CityEntity.entityName())
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [CityEntity]
        if results != nil{
            for item in results!{
                item.refresh = false
            }
        }
    }
    
    func resetDistrictRefresh(){
        let fetchRequest = NSFetchRequest(entityName: DistrictEntity.entityName())
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [DistrictEntity]
        if results != nil{
            for item in results!{
                item.refresh = false
            }
        }
    }
    
    func clearNoRefreshProvince(){
        let fetchRequest = NSFetchRequest(entityName: ProvinceEntity.entityName())
        let predicate = NSPredicate(format: "refresh = false")
        fetchRequest.predicate = predicate
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [ProvinceEntity]
        if results != nil{
            for item in results!{
                let cities = item.cities.allObjects as [CityEntity]
                item.removeCities(cities)
                managedObjectContext?.deleteObject(item)
            }
        }
    }
    
    func clearNoRefreshCity(){
        let fetchRequest = NSFetchRequest(entityName: CityEntity.entityName())
        let predicate = NSPredicate(format: "refresh = false")
        fetchRequest.predicate = predicate
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [CityEntity]
        if results != nil{
            for item in results!{
                let districts = item.districts.allObjects as [DistrictEntity]
                item.removeDistricts(districts)
                managedObjectContext?.deleteObject(item)
            }
        }
    }
    
    func clearNoRefreshDistrict(){
        let fetchRequest = NSFetchRequest(entityName: DistrictEntity.entityName())
        let predicate = NSPredicate(format: "refresh = false")
        fetchRequest.predicate = predicate
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [DistrictEntity]
        if results != nil{
            for item in results!{
                managedObjectContext?.deleteObject(item)
            }
        }
    }
    
    func save(){
        if managedObjectContext!.hasChanges{
            var error: NSError?
            managedObjectContext?.save(&error)
        }
    }

}
