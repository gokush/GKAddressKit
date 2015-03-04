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
        fetchRequest.predicate = NSPredicate(format: "userId = \(user.userID)")
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [AddressEntity]
        var addrArray = [GKAddress]()
        if results != nil{
            addrArray = AddressUtils.gkAddresses(results!)
        }
        return
            RACSignal.createSignal({ (subscriber) -> RACDisposable! in
                
                subscriber.sendNext(addrArray)
                subscriber.sendCompleted()
        
                return RACDisposable(block: { () -> Void in
                    
                })
                
            })
    }
    
    func findFailureAddressesWithUser(user: GKUser!) -> RACSignal! {
        let fetchRequest = NSFetchRequest(entityName: "AddressEntity")
        fetchRequest.predicate = NSPredicate(format: "userId = \(user.userID) AND sync = \(GKAddressSynchronizationFailure().code)")
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [AddressEntity]
        var addrArray = [GKAddress]()
        if results != nil{
            addrArray = AddressUtils.gkAddresses(results!)
        }
        return
            RACSignal.createSignal({ (subscriber) -> RACDisposable! in
                
                subscriber.sendNext(addrArray)
                subscriber.sendCompleted()
                
                return RACDisposable(block: { () -> Void in
                    
                })
                
            })
    }
    
    func create(address: GKAddress!) -> RACSignal! {
        var success = true
        let addressEntity = NSEntityDescription.insertNewObjectForEntityForName("AddressEntity", inManagedObjectContext: managedObjectContext!) as? AddressEntity
        if addressEntity == nil{
            success = false
        }
        addressEntity?.userId = address.userID
        addressEntity?.addressId = address.addressID
        addressEntity?.localId = getLocalId()
        addressEntity?.name = address.name
        addressEntity?.cellphone = address.cellPhone
        addressEntity?.postcode = address.postcode
        addressEntity?.address = address.address
        addressEntity?.isDefault = address.isDefault
        addressEntity?.sync = address.synchronization.code
        addressEntity?.createAt = NSDate()
        addressEntity?.updateAt = NSDate()
        let province = findProvinceWithId(address.province.provinceID)
        if province == nil{
            success = false
        }
        else{
            addressEntity?.addProvinceObject(province!)
            province?.addAddressesObject(addressEntity!)
            let city = findCityWithId(address.city.cityID, province: province!)
            if city == nil{
                success = false
            }
            else{
                addressEntity?.addCityObject(city!)
                city?.addAddressesObject(addressEntity!)
                let district = findDistrict(address.county.countyID, city: city!)
                if district == nil{
                    success = false
                }
                else{
                    addressEntity?.addDistrictObject(district!)
                    district?.addAddressesObject(addressEntity!)
                    save()
                }
            }
        }
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            if success{
                subscriber.sendNext("success")
            }
            else{
                let error = NSError()
                subscriber.sendError(error)
            }
            subscriber.sendCompleted()
            return nil
        })
    }
    
    func update(address: GKAddress!) -> RACSignal! {
        let fetchRequest = NSFetchRequest(entityName: "AddressEntity")
        fetchRequest.predicate = NSPredicate(format: "userId = \(address.userID)")
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [AddressEntity]
        let addressEntity = results?.last
        if addressEntity != nil{
            addressEntity?.name = address.name
            addressEntity?.cellphone = address.cellPhone
            addressEntity?.postcode = address.postcode
            addressEntity?.address = address.address
            addressEntity?.updateAt = NSDate()
            let province = findProvinceWithId(address.province.provinceID)
            if province != nil{
                addressEntity?.addProvinceObject(province!)
                province?.addAddressesObject(addressEntity!)
                let city = findCityWithId(address.city.cityID, province: province!)
                if city != nil{
                    addressEntity?.addCityObject(city!)
                    city?.addAddressesObject(addressEntity!)
                    let district = findDistrict(address.county.countyID, city: city!)
                    if district == nil{
                        addressEntity?.addDistrictObject(district!)
                        district?.addAddressesObject(addressEntity!)
                    }
                }
            }
            save()
        }
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            subscriber.sendNext(address)
            subscriber.sendCompleted()
            return nil
        })
    }
    
    func updatePrimary(address: GKAddress!) -> RACSignal! {
        var success = true
        let fetchRequest = NSFetchRequest(entityName: "AddressEntity")
        fetchRequest.predicate = NSPredicate(format: "userId = \(address.userID) AND localId = \(address.localID)")
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [AddressEntity]
        let addressEntity = results?.last
        if addressEntity != nil{
            addressEntity?.addressId = address.addressID
            println(address.synchronization.description)
            addressEntity?.sync = address.synchronization.code
            addressEntity?.updateAt = NSDate()
            save()
        }
        else{
            success = false
        }
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            if success{
                subscriber.sendNext(address)
            }
            else{
                let error = NSError(domain: "update addressId fail!!", code: 0, userInfo: nil)
                subscriber.sendError(error)
            }
            subscriber.sendCompleted()
            return nil
        })
    }
    
    func remove(address: GKAddress!) -> RACSignal! {
        return nil
    }
    
    func setDefault(address: GKAddress!) -> RACSignal! {
        return nil
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
    //查找某个省份
    func findProvinceWithId(provinceId: Int) -> ProvinceEntity?{
        let fetchRequest = NSFetchRequest(entityName: "ProvinceEntity")
        fetchRequest.predicate = NSPredicate(format: "provinceId = \(provinceId)")
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
        let province = results?.last as? ProvinceEntity
        return province
    }
    //查找某给城市
    func findCityWithId(cityId: Int, province: ProvinceEntity) -> CityEntity?{
        let cities = province.cities.allObjects as [CityEntity]
        var city: CityEntity?
        for item in cities{
            if item.cityId.integerValue == cityId{
                city = item
                break
            }
        }
        return city
    }
    //查找区域
    func findDistrict(districtId: Int, city: CityEntity) -> DistrictEntity?{
        let districts = city.districts.allObjects as [DistrictEntity]
        var district: DistrictEntity?
        for item in districts{
            if item.districtId.integerValue == districtId{
                district = item
            }
        }
        return district
    }
    //取得一个Address的localId
    func getLocalId() -> Int{
        let fetchRequest = NSFetchRequest(entityName: "AddressEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "localId", ascending: false)]
        fetchRequest.fetchLimit = 1
        var error: NSError?
        let results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [AddressEntity]
        if results == nil{
            return 1
        }
        else{
            let address = results!.last
            return address!.localId.integerValue + 1
        }
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
