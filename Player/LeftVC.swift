//
//  LeftVC.swift
//  Player
//
//  Created by kung on 16/8/19.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit


let IDOfLeft = "leftCell"

struct cellInSection {
    
    static let One:Array<String> = ["个人中心","关注","收藏"]
    static let Two:Array<String> = ["注册","登录"]
}

class LeftVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var userInfoTableView: UITableView!
    
    @IBOutlet weak var userIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor().colorWithAlphaComponent(0.2)
        
        self.setupView()
    }
    
    func setupView(){
        
        userInfoTableView.backgroundColor = UIColor.clearColor()
        userInfoTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        userInfoTableView.separatorInset = UIEdgeInsetsZero;
        //userInfoTV.cellLayoutMarginsFollowReadableWidth = false
        
        userIcon.layer.cornerRadius = userIcon.bounds.width/2.0
        userIcon.layer.borderWidth = 3
        userIcon.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        userIcon.layer.backgroundColor = UIColor.orangeColor().CGColor
    
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 3
        }else{
            return 2
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(IDOfLeft, forIndexPath: indexPath) as! leftTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        //        let tap:UITapGestureRecognizer = UITapGestureRecognizer()
        //        tap.addTarget(self, action: #selector(LeftVC.tapLabel(_:)))
        //        cell.labelView.addGestureRecognizer(tap)
        //        cell.labelView.userInteractionEnabled = true
        
        if (indexPath.section == 0) {
            
            cell.labelName.text = cellInSection.One[indexPath.row]
            
        }else{
            
            cell.labelName.text = cellInSection.Two[indexPath.row]
            
        }
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let w = Int(userInfoTableView.bounds.width*0.67 - 20)
        
        let h = 60
        
        let tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: w,height: h))
        tableFooterView.backgroundColor = UIColor.clearColor()
        
        return tableFooterView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 60
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select")
        let cell = self.userInfoTableView.cellForRowAtIndexPath(indexPath) as! leftTableViewCell
        
        UIView.animateWithDuration(0.5, delay: 1, options: .BeginFromCurrentState, animations: {
            cell.labelName.highlighted = true
            cell.labelName.backgroundColor =  UIColor.darkGrayColor().colorWithAlphaComponent(0.3)
        }) { (bool) in
            cell.labelName.highlighted = false
            cell.labelName.backgroundColor =  UIColor.whiteColor().colorWithAlphaComponent(0.5)
            
            if (indexPath.section == 1&&indexPath.row==1){
            
            let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
            
            self.view.window?.rootViewController!.presentViewController(view, animated: true) {
                
                }
                
            }
            
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
