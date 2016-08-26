//
//  viewTVC.swift
//  Player
//
//  Created by kung on 16/8/8.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit
import CoreData


class viewTVC: UITableViewController,PlayerViewControllerDelegate,addDelegate{
    
    var URLToPass:String?
    
    var LinksArr = [NSManagedObject]()
    var rightbar:UIBarButtonItem?
    
    override func awakeFromNib() {

        self.navigationItem.title = "List"
                
        self.dataFromCoreData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(viewTVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        
        rightbar = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(viewTVC.intoEdit))
        self.navigationItem.rightBarButtonItem = rightbar

    }
    
    func refresh() {
        self.dataFromCoreData()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func dataFromCoreData(){
        //1
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest   = NSFetchRequest(entityName: "Links")
        
        //3
        do {
            let results    = try managedContext.executeFetchRequest(fetchRequest)
            LinksArr       = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return  LinksArr.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  150
        }else{
            return 50
        }

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        if indexPath.section == 1 {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let row = UITableViewRowAction.init(style: UITableViewRowActionStyle.Default, title: "Del") { (action, indexPath) in
            
            print("此处写删除业务逻辑")
            
            let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            managedContext.deleteObject(self.LinksArr[indexPath.row])
            
            do {
                try managedContext.save()
                
                self.LinksArr.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }            
        }
        let rowsec = UITableViewRowAction.init(style: UITableViewRowActionStyle.Default, title: "Mark") { (action, indexPath) in
            print("此处写标记业务逻辑")
        }
        
        let arr:Array          = [rowsec,row]
        rowsec.backgroundColor = UIColor.orangeColor()
        
        return arr
    }
    

    // MARK: Constants
    private struct Storyboard {
        static let CellIdentifier1 = "viewCell"
        static let CellIdentifier2 = "viewAddCell"
    }
    
    //MARK: delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier1, forIndexPath: indexPath) as! viewTVCell
            
            cell.name.text      = LinksArr[indexPath.row].valueForKey("name") as? String
            cell.created.text   = LinksArr[indexPath.row].valueForKey("created") as? String
            cell.discribe.text  = LinksArr[indexPath.row].valueForKey("describe") as? String
            cell.url            = LinksArr[indexPath.row].valueForKey("url") as? String
            cell.icon.image     = UIImage(named: "background.jpg")
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier2, forIndexPath: indexPath)
            cell.backgroundColor = UIColor.clearColor()
            cell.accessoryType   = .None
            let label = UILabel.init(frame: CGRectMake(cell.frame.size.width/2 - 50, 0, 100, 50))
            label.text = "------  ADD +  ------"
            label.font = UIFont.boldSystemFontOfSize(8)
            label.textColor = UIColor.lightGrayColor()
            label.textAlignment = .Center
            //label.center = cell.center
            cell.addSubview(label)
            //cell.layer = shape
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    
        if indexPath.section == 0 {
            
            let cell:viewTVCell = self.tableView.cellForRowAtIndexPath(indexPath) as! viewTVCell
            self.URLToPass      = cell.url
            
            let player:playerViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("playerVC") as! playerViewController
            
            player.delegate = self
            
            //避免Warning :-Presenting view controllers on detached view controllers is discouraged
            self.view.window?.rootViewController!.presentViewController(player, animated: true) {
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == 1 {
            return false
        }
        return true
    }
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath,
                   toIndexPath: NSIndexPath) {
        
        if fromIndexPath != toIndexPath{
            
            let itemValue = LinksArr[fromIndexPath.row]
            
            LinksArr.removeAtIndex(fromIndexPath.row)
            
            if toIndexPath.row > LinksArr.count{
                
                LinksArr.append(itemValue)
            }else{
                
                LinksArr.insert(itemValue, atIndex:toIndexPath.row)
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare")
        
        if segue.identifier == "addSegue" {
            
            let addView      = segue.destinationViewController as! addViewController
            
            addView.delegate = self
        }
    }
    
    
    //MARK: other
    func toGetCurrMediaURL() -> String {
        
        print("send url successfully")
        
        return self.URLToPass!
    }
    
    func updateView() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.dataFromCoreData()
            self.tableView.reloadData()
        })
    }
   
    func intoEdit() {
        
        if(self.tableView.editing == true){
            
            self.tableView.setEditing(false, animated:true)
            rightbar?.title = "Edit"
            
        }else{
            self.tableView.setEditing(true, animated:true)
            rightbar?.title = "Done"
        }
        
    }
    
    
}
