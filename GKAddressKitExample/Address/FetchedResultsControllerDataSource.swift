//
//  FetchedResultsControllerDataSource.swift
//  CoreDataDemo
//
//  Created by 童小波 on 15/1/16.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsControllerDataSource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
   
    var fetchedResultsController: NSFetchedResultsController?{
        didSet{
            fetchedResultsController?.delegate = self
            fetchedResultsController?.performFetch(nil)
        }
    }
    var delegate: FetchedResultsControllerDataSourceDelegate?
    var reuseIdentifier: String?
    var paused: Bool?{
        willSet{
            assert(paused == nil, "TODO: you can currently only assign this property once")
        }
        didSet{
            if paused!{
                self.fetchedResultsController?.delegate = nil
            }
            else{
                self.fetchedResultsController?.delegate = self
                self.fetchedResultsController?.performFetch(nil)
                self.tableView.reloadData()
            }
        }
    }
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    // MARK:- tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if let count = fetchedResultsController?.sections?.count{
            println("sections: \(count)")
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let aSection: AnyObject? = fetchedResultsController?.sections![section]
        println("rows: \(aSection!.numberOfObjects)")
        return aSection!.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let object: AnyObject? = fetchedResultsController?.objectAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier!, forIndexPath: indexPath) as UITableViewCell
        self.delegate?.configureCell?(cell, withObject: object!)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            self.delegate?.deleteObject?(fetchedResultsController!.objectAtIndexPath(indexPath))
        }
    }
    
    //MARK:- FetchedResultsControllerDataSourceDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController){
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController){
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?){
        if type == NSFetchedResultsChangeType.Insert{
            println((indexPath, newIndexPath))
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        else if type == NSFetchedResultsChangeType.Move{
            self.tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
        else if type == NSFetchedResultsChangeType.Delete{
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        else if type == NSFetchedResultsChangeType.Update{
//            let array = self.tableView.visibleCells() as NSArray
            let array = self.tableView.indexPathsForVisibleRows()! as NSArray
            if array.containsObject(indexPath!){
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        else{
            assert(false, "")
        }
    }
    
    func selectItem() -> AnyObject?{
        let indexPath = self.tableView.indexPathForSelectedRow()
        if let aIndexPath = indexPath{
            return self.fetchedResultsController?.objectAtIndexPath(aIndexPath)
        }
        return nil
    }
    
    func objectForIndexPath(indexPath: NSIndexPath) -> AnyObject?{
        return self.fetchedResultsController?.objectAtIndexPath(indexPath)
    }
}

@objc protocol FetchedResultsControllerDataSourceDelegate{
    optional func configureCell(cell: AnyObject, withObject: AnyObject);
    optional func deleteObject(object: AnyObject);
}
