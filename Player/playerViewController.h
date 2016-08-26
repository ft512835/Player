//
//  playerViewController.h
//  Player
//
//  Created by kung on 16/8/8.
//  Copyright © 2016年 kung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"


@protocol PlayerViewControllerDelegate <NSObject>

- (NSString *)toGetCurrMediaURL;

@end


@interface playerViewController : UIViewController<VMediaPlayerDelegate>

@property (nonatomic, weak) id<PlayerViewControllerDelegate> delegate;


@end
