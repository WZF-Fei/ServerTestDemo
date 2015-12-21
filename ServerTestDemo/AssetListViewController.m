//
//  AssetListViewController.m
//  ServerTestDemo
//
//  Created by macOne on 15/12/21.
//  Copyright © 2015年 WZF. All rights reserved.
//

#import "AssetListViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AssetCell.h"

@interface AssetListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (copy, nonatomic) NSArray *assetArray;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation AssetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"资产列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _assetArray = [[NSArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //请求数据
    [self requestAssetList];
    
}


//服务器数据更改后，可以手动刷新
-(void)refresh{
    
    [self requestAssetList];
}

-(void)requestAssetList
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url=@"http://localhost:12306/assetApp/assetList";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //带有headers参数
    [manager.requestSerializer setValue:@"e566288ba77de98d" forHTTPHeaderField:@"sessionid"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        _assetArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        //做一个处理,1秒后刷新。模拟请求数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //刷新界面
            [_tableView reloadData];
            //隐藏hub
            [hud hide:YES];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请求资产列表失败";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }];
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_assetArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  70;
}

-(AssetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellReusable";
    
    AssetCell *cell = (AssetCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AssetCell" owner:nil options:nil] lastObject];
    }

    cell.nameLabel.text = _assetArray[indexPath.row][@"assetname"];
    cell.codeLabel.text = _assetArray[indexPath.row][@"assetcode"];
    cell.amountLabel.text = [NSString stringWithFormat:@"%ld%@",[_assetArray[indexPath.row][@"amount"] integerValue],_assetArray[indexPath.row][@"unit"]];
    
    cell.costLabel.text = [NSString stringWithFormat:@"￥%ld",[_assetArray[indexPath.row][@"cost"] integerValue] * [_assetArray[indexPath.row][@"amount"] integerValue]];
    return cell;
}

@end
