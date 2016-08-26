//
//  loginViewController.swift
//  Player
//
//  Created by kung on 16/8/20.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit

class loginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var account: UITextField!
    
    @IBOutlet weak var password: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named: "login.jpg")?.CGImage
        avatar.layer.cornerRadius = 20
        avatar.layer.borderWidth = 5
        avatar.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        avatar.layer.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        
        self.readFromUserDefaults()
    }

    func saveToUserDefaults() {
        
        NSUserDefaults.standardUserDefaults().setObject(account.text, forKey: "myAccount")
        NSUserDefaults.standardUserDefaults().setObject(password.text, forKey: "myPassword")
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    

    func readFromUserDefaults() {
        
        account.text = NSUserDefaults.standardUserDefaults().valueForKey("myAccount") as! String!
        password.text = NSUserDefaults.standardUserDefaults().valueForKey("myPassword") as! String!
        
    }
    
    
    @IBAction func popover() {
        
        self.dismissViewControllerAnimated(true) {    
        }
        
    }
    
    @IBAction func login() {
        
        print("login")
        self.saveToUserDefaults()
        
    }
    
    //MARK UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.becomeFirstResponder()
    }
    
    
    func textFieldBeginEditing(textField: UITextField) -> Bool {
        
        return true
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
   
}
