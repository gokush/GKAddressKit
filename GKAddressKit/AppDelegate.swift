//
//  AppDelegate.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import UIKit

let BOUND = UIScreen.mainScreen().bounds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let persistenStack = PersistenStack(storeURL: self.storeURL(), modelURL: self.modelURL())
        AddressRepository.sharedInstance.managedObjectContext = persistenStack.managedObjectContext
        println(self.storeURL().path)
        
//        ProvinceEntity.insertProvince(1, provinceName: "上海", pinyin: "shanghai", managedObjectContext: persistenStack.managedObjectContext!)
//        persistenStack.managedObjectContext?.save(nil)
//        println(self.storeURL())
//        
//        let province = ProvinceEntity.selectWithId(1, managedObjectContext: persistenStack.managedObjectContext!)
//        province?.provinceId = 2
//        persistenStack.managedObjectContext?.save(nil)
//        println(province?.name)
        
        
//        DistrictEntity.insertDistrict(10, districtName: "黄浦区", pinyin: "huanpuqu", managedObjectContext: persistenStack.managedObjectContext!)
//        persistenStack.managedObjectContext?.save(nil)
//        
//        let district = DistrictEntity.selectWithId(9, managedObjectContext: persistenStack.managedObjectContext!)
//        println(district?.name)
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func storeURL() -> NSURL{
        let url = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        return url!.URLByAppendingPathComponent("addressmodel.sql")
    }
    
    func modelURL() -> NSURL{
        return NSBundle.mainBundle().URLForResource("GKAddressModel", withExtension: "momd")!
    }
}

