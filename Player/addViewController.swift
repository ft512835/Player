//
//  addViewController.swift
//  Player
//
//  Created by kung on 16/8/24.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit

protocol addDelegate {
    func updateView()
}

class addViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var inputLink: UITextField!
    
    @IBOutlet weak var describe: UITextView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var titleOfLink: UITextField!

    var delegate:addDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        describe.layer.cornerRadius = 5
        describe.layer.borderWidth = 0.5
        describe.layer.borderColor = UIColor.lightGrayColor().CGColor

    }

    @IBAction func addClicked(sender: UIButton) {
        
        self.saveLink()
        self.delegate?.updateView()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func saveLink() {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Links",
                                                        inManagedObjectContext:managedContext)
        
        let link = NSManagedObject(entity: entity!,
                                   insertIntoManagedObjectContext: managedContext)
        
        //3
        link.setValue(inputLink.text, forKey: "url")
        link.setValue("", forKey: "icon")
        link.setValue(titleOfLink.text, forKey: "name")
        link.setValue(describe.text, forKey: "describe")
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        print("time  time   time   \(formatter.stringFromDate(NSDate()))")
        
        link.setValue("", forKey: "created")

        //4
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
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
