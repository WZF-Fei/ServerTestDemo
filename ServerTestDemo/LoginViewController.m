//
//  LoginViewController.m
//  ServerTestDemo
//
//  Created by macOne on 15/12/21.
//  Copyright © 2015年 WZF. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *pwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIn:(id)sender {

    _name = _userName.text;
    _pwd = _password.text;
    [self requestLogin];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
}

-(void)requestLogin
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url=@"http://localhost:12306/assetApp/login";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; 
    
    NSDictionary *dic = @{@"username":_name,
                          @"password":_pwd
                          };
    

    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
  
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录成功";
        hud.removeFromSuperViewOnHide = YES;
  
        NSLog(@"result:%@",jsonDict);
        //做一个处理,1秒后刷新。也可以不用加
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //隐藏hub
            [hud hide:YES];
            //转到下一界面
            [[AppDelegate shareDelegate] setupMainViewController];


        });

        

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录失败";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
        NSLog(@"登录失败");
    }];
}

@end
