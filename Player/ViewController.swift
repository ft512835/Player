//
//  ViewController.swift
//  Player
//
//  Created by kung on 16/8/19.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // 主界面点击手势，用于在菜单划出状态下点击主页后自动关闭菜单
    var tapGesture: UITapGestureRecognizer!
    
    // 首页的 Navigation Bar 的提供者，是首页的容器
    var homeNavigationController: UINavigationController!
    // 首页中间的主要视图的来源
    var homeViewController: viewTVC!
    // 侧滑菜单视图的来源
    var leftViewController: LeftVC!
    
    // 构造主视图，实现 UINavigationController.view 和 HomeViewController.view 一起缩放
    var mainView: UIView!
    
    // 侧滑所需参数
    var distance: CGFloat = 0
    let FullDistance: CGFloat = 0.67
    let Proportion: CGFloat = 1
    var centerOfLeftViewAtBeginning: CGPoint!
    var proportionOfLeftView: CGFloat = 1
    var distanceOfLeftView: CGFloat = 50
    
    // 侧滑菜单黑色半透明遮罩层
    var blackCover: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named: "bg.png")?.CGImage
        
        self.setupView();
        
    }
    
    func setupView(){
        
        // 通过 StoryBoard 取出左侧侧滑菜单视图
        leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as! LeftVC
        leftViewController.view.center = CGPoint(x: leftViewController.view.center.x - 50, y: leftViewController.view.center.y)
        
        //leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        
        centerOfLeftViewAtBeginning = leftViewController.view.center
        // 把侧滑菜单视图加入根容器
        self.view.addSubview(leftViewController.view)
        
        // 在侧滑菜单之上增加黑色遮罩层，目的是实现视差特效
        blackCover = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: 0))
        blackCover.backgroundColor = UIColor.blackColor()
        self.view.addSubview(blackCover)
        
        mainView = UIView(frame: self.view.frame)
        
        // 从 StoryBoard 取出首页的 Navigation Controller
        homeNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
        homeNavigationController.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        homeViewController = homeNavigationController.viewControllers.first as! viewTVC
        
        // 分别将 Navigation Bar 和 homeViewController 的视图加入视图
        mainView.addSubview(homeViewController.view)
        mainView.addSubview(homeViewController.navigationController!.view)
        
        // 将主视图加入容器
        self.view.addSubview(mainView)
        
        // 分别指定 Navigation Bar 左右两侧按钮的事件
        homeViewController.navigationItem.leftBarButtonItem?.action = #selector(ViewController.showLeft)
        //homeViewController.navigationItem.rightBarButtonItem?.action = #selector(ViewController.addVideo)
        
        // 生成单击收起菜单手势
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.showHome))
        
    }
    
   
    
    func showLeft() {
        // 给首页 加入点击自动关闭侧滑菜单功能
        mainView.addGestureRecognizer(tapGesture)
        // 计算距离，执行菜单自动滑动动画
        distance = self.view.center.x * (FullDistance*2 + Proportion - 1)
        doTheAnimate(self.Proportion, showWhat: "left")
        homeNavigationController.popToRootViewControllerAnimated(true)
    }

    func showHome() {
        // 从首页 删除 点击自动关闭侧滑菜单功能
        mainView.removeGestureRecognizer(tapGesture)
        // 计算距离，执行菜单自动滑动动画
        distance = 0
        doTheAnimate(1, showWhat: "home")
    }

    
    func doTheAnimate(proportion: CGFloat, showWhat: String) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            // 移动首页中心
            self.mainView.center = CGPoint(x: self.view.center.x + self.distance, y: self.view.center.y)
            // 缩放首页
            self.mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
            if showWhat == "left" {
                // 移动左侧菜单的中心
                self.leftViewController.view.center = CGPoint(x: self.centerOfLeftViewAtBeginning.x + self.distanceOfLeftView, y: self.leftViewController.view.center.y)
                // 缩放左侧菜单
                self.leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.proportionOfLeftView, self.proportionOfLeftView)
            }
            // 改变黑色遮罩层的透明度，实现视差效果
            self.blackCover.alpha = showWhat == "home" ? 1 : 0
            
            }, completion: nil)
    }

}
