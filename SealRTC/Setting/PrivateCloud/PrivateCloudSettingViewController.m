//
//  PrivateCloudSettingViewController.m
//  SealRTC
//
//  Created by jfdreamyang on 2019/8/22.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import "PrivateCloudSettingViewController.h"
#import "PrivateSettingCell.h"
#import "LoginManager.h"

@interface PrivateCloudSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *placeholders;
@property (nonatomic,strong)NSArray *dataSource;
@end

@implementation PrivateCloudSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"setting_private_environment_title", nil);
    
    self.placeholders = @[NSLocalizedString(@"setting_private_environment_placeholder0",nil),NSLocalizedString(@"setting_private_environment_placeholder1",nil),NSLocalizedString(@"setting_private_environment_placeholder2",nil),NSLocalizedString(@"setting_private_environment_placeholder3",nil),NSLocalizedString(@"setting_private_environment_placeholder4",nil)];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PrivateSettingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PrivateSettingCell"];
    
    if (kLoginManager.isPrivateEnvironment) {
        self.dataSource = @[kLoginManager.privateAppKey,kLoginManager.privateAppSecret,kLoginManager.privateNavi,kLoginManager.privateIMServer];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSArray <PrivateSettingCell *>*cells = self.tableView.visibleCells;
    
    NSString *appKey = cells[0].textField.text;
    NSString *appSecret = cells[1].textField.text;
    NSString *naviServer = cells[2].textField.text;
    NSString *serverApi = cells[3].textField.text;
    if (appKey.length > 5 && appSecret.length > 5 && naviServer.length > 5 && serverApi.length > 5) {
        kLoginManager.isPrivateEnvironment = YES;
        kLoginManager.privateAppKey = appKey;
        kLoginManager.privateNavi = naviServer;
        kLoginManager.privateAppSecret = appSecret;
        kLoginManager.privateIMServer = serverApi;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 30.f : 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PrivateSettingCell"];
    cell.textField.placeholder = self.placeholders[indexPath.section];
    if (self.dataSource) {
        cell.textField.text = self.dataSource[indexPath.section];
    }
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"setting_private_environment_appkey", nil);
        case 1:
            return NSLocalizedString(@"setting_private_environment_appsecret", nil);
        case 2:
            return NSLocalizedString(@"setting_private_environment_naviserver", nil);
        case 3:
            return NSLocalizedString(@"setting_private_environment_serverapi", nil);
        case 4:
            return NSLocalizedString(@"setting_private_environment_appserver", nil);
        default:
            break;
    }
    return @"";
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
