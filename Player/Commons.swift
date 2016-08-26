//
//  Commons.swift
//  V2EX
//
//  Created by kung on 16/8/11.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit

struct Commons {
    // Swift 中， static let 才是真正可靠好用的单例模式

    static let screenWidth = UIScreen.mainScreen().bounds.maxX
    static let screenHeight = UIScreen.mainScreen().bounds.maxY
    static let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! ViewController
        
    static let defaultImageURL = "http://img0.bdstatic.com/img/image/shouye/xinshouye/sheji202.jpg"
    
    static var linksAndInfo:[Dictionary<String,String>]=[
        
        ["name":"iqiyi","created":"recent","discribe":"Commercial video of iqiyi","icon":"http://www.madisonboom.com/wp-content/uploads/2013/09/iQIYI-inside-logo-tiny.jpg","url":"http://metal.video.qiyi.com/20131104/dbb56b29ef709ba4c9e17621c0e5c2a5.m3u8"],
        ["name":"LOL","created":"recent","discribe":"LOL's record","icon":"http://realip.gameres.com/data/attachment/forum/201311/11/1801017z8bl55cr58bkbrb.jpg","url":"http://17173.tv.sohu.com/api/2752061.m3u8"],
        ["name":"实验室测试视频","created":"recent","discribe":"测试视频","icon":defaultImageURL,"url":"http://10.33.28.181/mov/index.m3u8"],
        
        ]

    
}


