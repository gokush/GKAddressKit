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
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let controller:GKAddressListController =
        GKAddressListController()
      controller.service = GKAddressContainerMock().addressService()
      self.navigationController?.pushViewController(controller, animated: true)
      
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addAddressButtonClick:")
//        self.tableView.tableFooterView = UIView()
//        
//        refreshDate()
//        setupFetchedResultsControllerDataSource()
//        
//        let provinces = AddressRepository.sharedInstance.fetchProvinces()
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
        var tpstart = timeval(tv_sec: 0, tv_usec: 0)
        var tpend = timeval(tv_sec: 0, tv_usec: 0)
        gettimeofday(&tpstart, nil)
        AddressRepository.sharedInstance.updateProvince(jsonArray)
        gettimeofday(&tpend, nil)
        println(tpend.tv_usec - tpstart.tv_usec)
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
        AddressRepository.sharedInstance.deleteAddress(address)
    }

}

