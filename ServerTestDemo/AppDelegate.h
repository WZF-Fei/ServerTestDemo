//
//  AppDelegate.h
//  ServerTestDemo
//
//  Created by macOne on 15/12/21.
//  Copyright © 2015年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shareDelegate;

- (void)setupMainViewController;

@end

