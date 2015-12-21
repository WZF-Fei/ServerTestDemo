//
//  AppDelegate.m
//  ServerTestDemo
//
//  Created by macOne on 15/12/21.
//  Copyright © 2015年 WZF. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AssetListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate *)shareDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupLoginViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupLoginViewController{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.window setRootViewController:loginVC];
    
}

- (void)setupMainViewController{
    
    AssetListViewController *rootVC = [[AssetListViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    [self.window setRootViewController:navigation];
    [self.window makeKeyAndVisible];
    
    //    [self.window setRootViewController:rootVC];
}

@end
