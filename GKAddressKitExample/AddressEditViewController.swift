//
//  AddressEditViewController.swift
//  bajibaji
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 bajibaji. All rights reserved.
//

import UIKit

class AddressEditViewController: UIViewController, AddressEditCellDelegate, AreaPickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var nameStr: String!
    var addressStr: String!
    var cellphoneStr: String!
    var province: ProvinceEntity!
    var city: CityEntity!
    var district: DistrictEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.edgesForExtendedLayout = UIRectEdge.Bottom
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonClick")
        
        self.setupTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView(){
        let headView = UIView(frame: CGRectMake(0, 0, BOUND.width, 20.0))
        tableView.tableHeaderView = headView
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }

    func rightBarButtonClick(){
        if checkInfo(){
            nameStr = "tong"
            cellphoneStr = "13120960978"
            addressStr = "西藏南路"
            AddressRepository.sharedInstance.insertAddressWithId(0, name: nameStr, cellphone: cellphoneStr, postCode: "1234", province: province, city: city, district: district, address: addressStr, isDefault: true)
        }
    }
    
    func checkInfo() -> Bool{
        return true
    }
    
    func configCell(cell: UITableViewCell, indexPath: NSIndexPath){
        let editCell = cell as AddressEditCell
        editCell.delegate = self
        switch indexPath.row{
        case 0:
            editCell.keyLabel.text = "收货人"
            editCell.allowEdit = true
            break
        case 1:
            editCell.keyLabel.text = "区域选择"
            editCell.allowEdit = false
            break
        case 2:
            editCell.keyLabel.text = "详细地址"
            editCell.allowEdit = true
            break
        case 3:
            editCell.keyLabel.text = "联系方式"
            editCell.allowEdit = true
            break
        default:
            break
        }
    }
    
    //MARK:- AddressEditCellDelegate
    func addressEditCellDidEndEditing(text: String, indexPath: NSIndexPath){
        switch indexPath.row{
        case 0:
            nameStr = text
            break
        case 2:
            addressStr = text
            break
        case 3:
            cellphoneStr = text
            break
        default:
            break
        }
    }
    
    func addressEditCellDidBeginEditing(textField: UITextField, indexPath: NSIndexPath) {
        if indexPath.row == 1{
            self.view.endEditing(true)
            AreaPicker.showAreaPickerAt(self.view, delegate: self)
        }
        else{
            AreaPicker.dismissAreaPicker()
        }
    }
    
    //MARK:- AreaPickerDelegate
    func areaPickerEndPick(province: ProvinceEntity, city: CityEntity, district: DistrictEntity) {
        self.province = province
        self.city = city
        self.district = district
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as AddressEditCell
        cell.valueLabel.text = province.name + city.name + district.name
    }
    
    // MARK:- tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("AddressEditCell") as UITableViewCell
        configCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 40
    }

}
