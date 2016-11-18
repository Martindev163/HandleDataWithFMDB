//
//  ViewController.m
//  HandleDataWithFMDB
//
//  Created by 马浩哲 on 16/11/17.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "ViewController.h"
#import "LinkmanViewController.h"
#import "UserModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UserModel *UModel;

@property (nonatomic, strong) NSMutableArray *userListArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    self.userListArray = [[NSMutableArray alloc] init];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addBtn.frame = CGRectMake(0, 0, 40, 40);
    [addBtn addTarget:self action:@selector(addNewFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self readUsersData];
}

#pragma mark - 添加联系人
-(void)addNewFriend
{
    NSLog(@"添加联系人");
    LinkmanViewController *LMVC = [[LinkmanViewController alloc] init];
    [self.navigationController pushViewController:LMVC animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userListArray.count>0?self.userListArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    CGSize imgSize;
    imgSize = CGSizeMake(30, 30);
    CGRect tempRect = cell.imageView.frame;
    tempRect.size = imgSize;
//    cell.imageView.frame = tempRect;
    UserModel *model = self.userListArray[indexPath.row];
    cell.imageView.image = [UIImage imageWithData:model.avatarData];
    cell.textLabel.text = model.userName;
    cell.detailTextLabel.text = model.phone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - 读取数据
-(void)readUsersData
{
    FMDatabase *db = [FMDatabase databaseWithPath:kUserDataBasePath];
    NSLog(@"%@",kUserDataBasePath);
    if ([db open]) {
        NSString *getUserDataSql = @"select * from userTab";
        
        FMResultSet *rs = [db executeQuery:getUserDataSql];
        
        while ([rs next]) {
            UserModel *model = [[UserModel alloc] init];
            model.avatarData = [rs dataForColumn:@"avatar"];
            model.userName = [rs stringForColumn:@"name"];
            model.age = [rs stringForColumn:@"age"];
            model.phone = [rs stringForColumn:@"phone"];
            [self.userListArray addObject:model];
        }
        [self.tableview reloadData];
    }
    [db close];
}

@end
