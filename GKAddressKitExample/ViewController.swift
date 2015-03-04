//
//  ViewController.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FetchedResultsControllerDataSourceDelegate {

    @IBOutlet weak var tableView: UITableView!
    var fetchedResultControllerDataSource: FetchedResultsControllerDataSource?
  
  var provinces:NSArray?;
  let service:GKAddressService = GKAddressContainerImpl().addressService()
    let addressRepository = AddressRepository.sharedInstance
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let controller:GKAddressListController =
        GKAddressListController()
      controller.service = GKAddressContainerMock().addressService()
      self.navigationController?.pushViewController(controller, animated: true)
      
//        let province = addressRepository.findProvinceWithId(2)
//        println(province?.name)
//        
//        let city = addressRepository.findCityWithId(21, province: province!)
//        println(city?.name)
//        
//        let district = addressRepository.findDistrict(212, city: city!)
//        println(district?.name)
        
        refreshDate()
        
        let address = GKAddress()
        let province = GKProvince()
        province.provinceID = 2
        let city = GKCity()
        city.cityID = 21
        let county = GKCounty()
        county.countyID = 212
        address.userID = 1
        address.addressID = 1
        address.localID = 101
        address.name = "tong"
        address.cellPhone = "1312099999999"
        address.postcode = "321300"
        address.address = "昌平路700号"
        address.isDefault = true
        address.province = province
        address.city = city
        address.county = county
        address.synchronization = GKAddressSynchronizationSending()
        addressRepository.create(address).subscribeNext({ (success) -> Void in
            
            println(success)
            
        }, error: { (error) -> Void in
            
            println("error")
            
        })
        
        let user = GKUser()
        user.userID = 1
        addressRepository.findAddressesWithUser(user).subscribeNext({ (addresses) -> Void in
            
            let aAddresses = addresses as [GKAddress]
            for item in aAddresses{
                print("\(item.localID)  \(item.synchronization.code)")
                println(item.address)
            }
            
        }, error: { (error) -> Void in
            
        })
        
        address.synchronization = GKAddressSynchronizationSuccess()
        address.addressID = 1010
        
        addressRepository.updatePrimary(address)
        
        println("***************")
        
//        addressRepository.findAddressesWithUser(user).subscribeNext({ (addresses) -> Void in
//            
//            let aAddresses = addresses as [GKAddress]
//            for item in aAddresses{
//                print("\(item.localID)  \(item.synchronization.code)")
//                println(item.address)
//            }
//            
//            }, error: { (error) -> Void in
//                
//        })
        
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addAddressButtonClick:")
//        self.tableView.tableFooterView = UIView()
//        
//        refreshDate()
//        setupFetchedResultsControllerDataSource()
//        
//        let provinces = AddressRepository.sharedInstance.fetchProvinces()
//        let province = AddressRepository.sharedInstance.findProvinceWithId(1)
        
//        println(province?.name)
        
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
//        println("************************")
//        let districts = AddressRepository.sharedInstance.fetchDistricts()
//        if districts != nil{
//            for item in districts!{
//                println(item.name)
//            }
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAddressButtonClick(sender: UIBarButtonItem){
        let addressEditViewController = AddressEditViewController()
        self.performSegueWithIdentifier("editAddress", sender: self)
    }

    func refreshDate(){
        let jsonPath = NSBundle.mainBundle().pathForResource("province", ofType: "json")
        let jsonData = NSData(contentsOfFile: jsonPath!)
        let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as [AnyObject]
        //测试更新时间
//        var tpstart = timeval(tv_sec: 0, tv_usec: 0)
//        var tpend = timeval(tv_sec: 0, tv_usec: 0)
//        gettimeofday(&tpstart, nil)
        AddressRepository.sharedInstance.updateProvince(jsonArray)
//        gettimeofday(&tpend, nil)
//        println(tpend.tv_usec - tpstart.tv_usec)
    }
    
    func setupFetchedResultsControllerDataSource(){
        self.fetchedResultControllerDataSource = FetchedResultsControllerDataSource(tableView: self.tableView)
        self.fetchedResultControllerDataSource?.fetchedResultsController = AddressRepository.sharedInstance.fetchedResultsController()
        self.fetchedResultControllerDataSource?.delegate = self
        self.fetchedResultControllerDataSource?.reuseIdentifier = "AddressCellIdentity"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func configureCell(cell: AnyObject, withObject: AnyObject)
    {
        let addressCell = cell as AddressCell
        let address = withObject as AddressEntity
        addressCell.textLabel?.numberOfLines = 3
        addressCell.textLabel?.text = "\(address.name) \(address.cellphone)\n\(address.province.name)\(address.city.name)\(address.district.name)"
    }
    
    func deleteObject(object: AnyObject)
    {
        let address = object as AddressEntity
//        AddressRepository.sharedInstance.deleteAddress(address)
    }

}

