//
//  ManagedObject+Extensions.swift
//  GKAddressKit
//
//  Created by 童小波 on 15/1/19.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject{
    
    class func entityName() -> String{
        let classString = NSStringFromClass(self)
        let components = split(classString, { $0 == "." })
        return components.last ?? classString
    }
    
    class func insertItem(predicate: NSPredicate, managedObjectContext: NSManagedObjectContext, setObject: (object: NSManagedObject) -> Void) -> NSManagedObject?{
        println(entityName())
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.predicate = predicate
        var error: NSError?
        let results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        if error != nil{
            println(error?.localizedDescription)
        }
        if let item = results?.last as? NSManagedObject{
            return nil
        }
        let object = NSEntityDescription.insertNewObjectForEntityForName(self.entityName(), inManagedObjectContext: managedObjectContext) as NSManagedObject
        setObject(object: object)
        return object
    }
    
    class func fetchItems(predicate: NSPredicate, managedObjectContext: NSManagedObjectContext) -> NSManagedObject?{
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.predicate = predicate
        var error: NSError?
        let results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        if error != nil{
            println(error?.localizedDescription)
        }
        if let item = results?.last as? NSManagedObject{
            return item
        }
        return nil
    }
}