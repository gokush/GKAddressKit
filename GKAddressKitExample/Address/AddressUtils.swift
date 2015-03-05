//
//  AddressUtils.swift
//  GKAddressKitExample
//
//  Created by 童小波 on 15/3/3.
//  Copyright (c) 2015年 Goku. All rights reserved.
//

import UIKit

class AddressUtils: NSObject {
   
    class func gkAddresses(addressEntitys: [AddressEntity]) -> [GKAddress]{
        var gkArray = [GKAddress]()
        for item in addressEntitys{
            let gkaddress = gkAddress(item)
            gkArray.append(gkaddress)
        }
        return gkArray
    }
    
    class func gkAddress(addressEntity: AddressEntity) -> GKAddress{
        let gkAddress = GKAddress()
        gkAddress.userID = addressEntity.userId.integerValue
        gkAddress.addressID = addressEntity.addressId.integerValue
        gkAddress.localID = addressEntity.localId.integerValue
        gkAddress.name = addressEntity.name
        gkAddress.cellPhone = addressEntity.cellphone
        gkAddress.postcode = addressEntity.postcode
        gkAddress.address = addressEntity.address
        gkAddress.isDefault = addressEntity.isDefault.boolValue
        gkAddress.province = gkProvince(addressEntity.province)
        gkAddress.city = gkCity(addressEntity.city)
        gkAddress.county = gkCounty(addressEntity.district)
        gkAddress.synchronization = GKAddressSynchronization(integer: addressEntity.sync.integerValue)
        return gkAddress
    }
    
    class func gkProvince(provinceEntity: ProvinceEntity) -> GKProvince{
        let gkProvince = GKProvince()
        gkProvince.provinceID = provinceEntity.provinceId.integerValue
        gkProvince.name = provinceEntity.name
        return gkProvince
    }
    
    class func gkCity(cityEntity: CityEntity) -> GKCity{
        let gkCity = GKCity()
        gkCity.cityID = cityEntity.cityId.integerValue
        gkCity.name = cityEntity.name
        return gkCity
    }
    
    class func gkCounty(districtEntity: DistrictEntity) -> GKCounty{
        let gkCounty = GKCounty()
        gkCounty.countyID = districtEntity.districtId.integerValue
        gkCounty.name = districtEntity.name
        return gkCounty
    }
    
}
