//
//  AreaPicker.swift
//  bajibaji
//
//  Created by 童小波 on 15/2/4.
//  Copyright (c) 2015年 bajibaji. All rights reserved.
//

import UIKit
import CoreData

var areaPicker: AreaPicker?

class AreaPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var picker: UIPickerView?
    var confirmButton: UIButton!
    var delegate: AreaPickerDelegate!
    var text: String!
    var selectRows: [Int]!
    var provinces: [ProvinceEntity]!
    var cities: [CityEntity]!
    var district: [DistrictEntity]!
    
    class func showAreaPickerAt(dependView: UIView, delegate: AreaPickerDelegate){
        if areaPicker == nil{
            areaPicker = AreaPicker(frame: CGRectMake(0, BOUND.height - 280, BOUND.width, 280))
        }
        if areaPicker?.superview != nil{
            areaPicker?.removeFromSuperview()
        }
        areaPicker?.delegate = delegate
        dependView.addSubview(areaPicker!)
        areaPicker?.layer.transform = CATransform3DTranslate(areaPicker!.layer.transform, 0, areaPicker!.bounds.height, 0)
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            areaPicker?.layer.transform = CATransform3DIdentity
            return
            
        }, completion: nil)
        
    }
    
    class func dismissAreaPicker(){
        if areaPicker?.superview != nil{
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                areaPicker?.layer.transform = CATransform3DTranslate(areaPicker!.layer.transform, 0, areaPicker!.bounds.height, 0)
                return
                
                }) { (finished) -> Void in
                    areaPicker?.removeFromSuperview()
                    areaPicker = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        picker = UIPickerView(frame: CGRectMake(0, 40, frame.width, frame.height - 40))
        self.addSubview(picker!)
        picker?.backgroundColor = UIColor.whiteColor()
        picker?.dataSource = self
        picker?.delegate = self
        self.backgroundColor = UIColor.lightGrayColor()
        confirmButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        confirmButton.frame = CGRectMake(BOUND.width - 60, 5, 40, 30)
        confirmButton.setTitle("完成", forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        confirmButton.addTarget(self, action: "confirmButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(confirmButton)
        setupData()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(){
        selectRows = [0, 0, 0]
        self.provinces = AddressRepository.sharedInstance.fetchProvinces()
        self.cities = provinces[0].cities.allObjects as [CityEntity]
        self.district = cities[0].districts.allObjects as [DistrictEntity]

    }
    
    func confirmButtonClick(button: UIButton){
        self.delegate.areaPickerEndPick?(provinces[selectRows[0]], city: cities[selectRows[1]], district: district[selectRows[2]])
        AreaPicker.dismissAreaPicker()
    }
    
    //MARK:- UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0{
            return provinces.count
        }
        else if component == 1{
            return cities.count
        }
        else if component == 2{
            return district.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        if component == 0{
            return provinces[row].name
        }
        else if component == 1{
            return cities[row].name
        }
        else if component == 2{
            return district[row].name
        }
        else{
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0{
            cities = provinces[row].cities.allObjects as [CityEntity]
            district = cities[0].districts.allObjects as [DistrictEntity]
            pickerView
            pickerView.reloadAllComponents()
            selectRows[0] = row
        }
        else if component == 1{
            district = cities[row].districts.allObjects as [DistrictEntity]
            pickerView.reloadAllComponents()
            selectRows[1] = row
        }
        else if component == 2{
            selectRows[2] = row
        }
        
    }
    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
//        
//    }

}

@objc protocol AreaPickerDelegate{
    optional func areaPickerEndPick(province: ProvinceEntity, city: CityEntity, district: DistrictEntity)
}

