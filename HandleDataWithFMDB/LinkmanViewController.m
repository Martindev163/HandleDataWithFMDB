//
//  LinkmanViewController.m
//  HandleDataWithFMDB
//
//  Created by 马浩哲 on 16/11/17.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "LinkmanViewController.h"

#define LinkmanViewMargin 20
#define LinkmanViewAvatarWidth 100

@interface LinkmanViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *avatarImgV;

@property (nonatomic, strong) UIButton *avatarBtn;

@property (nonatomic, strong) UITextField *nameTF,*ageTF,*phonheNumTF;

@property (nonatomic, strong) FMDatabase *userDB;

@end

@implementation LinkmanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRightBtn];
    [self loadSubviews];
    [self createDataBase];
    [self createLinkmanTab];
}

#pragma mark - 添加右按钮
-(void)addRightBtn
{
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [saveBtn addTarget:self action:@selector(savePersonData) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击保存
-(void)savePersonData
{
    if ([_nameTF.text isEqualToString:@""]||[_ageTF.text isEqualToString:@""]||[_phonheNumTF.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelBtn];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self saveUserData];
    }
}

#pragma mark - 创建视图  (简单设置若干信息)
-(void)loadSubviews
{
    _avatarImgV = [[UIImageView alloc] initWithFrame:CGRectMake( (kDeviceWidth - LinkmanViewAvatarWidth)/2.0, LinkmanViewMargin+64, LinkmanViewAvatarWidth, LinkmanViewAvatarWidth)];
    
    _avatarImgV.layer.cornerRadius = LinkmanViewAvatarWidth/2.0;
    _avatarImgV.layer.masksToBounds = YES;
    _avatarImgV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:_avatarImgV];
    
    _avatarBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - LinkmanViewAvatarWidth)/2.0, LinkmanViewMargin+64, LinkmanViewAvatarWidth, LinkmanViewAvatarWidth)];
    [_avatarBtn addTarget:self action:@selector(tapAvatarAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_avatarBtn];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(LinkmanViewMargin, CGRectGetMaxY(_avatarBtn.frame)+LinkmanViewMargin, kDeviceWidth - 2*LinkmanViewMargin, 44)];
    _nameTF.textAlignment = NSTextAlignmentLeft;
    _nameTF.placeholder = @"姓名";
    _nameTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_nameTF];
    
    _ageTF = [[UITextField alloc] initWithFrame:CGRectMake(LinkmanViewMargin, CGRectGetMaxY(_nameTF.frame)+LinkmanViewMargin, kDeviceWidth - 2*LinkmanViewMargin, 44)];
    _ageTF.textAlignment = NSTextAlignmentLeft;
    _ageTF.placeholder = @"年龄";
    _ageTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_ageTF];
    
    _phonheNumTF = [[UITextField alloc] initWithFrame:CGRectMake(LinkmanViewMargin, CGRectGetMaxY(_ageTF.frame)+LinkmanViewMargin, kDeviceWidth - 2*LinkmanViewMargin, 44)];
    _phonheNumTF.textAlignment = NSTextAlignmentLeft;
    _phonheNumTF.placeholder = @"电话号码";
    _phonheNumTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_phonheNumTF];
}

#pragma mark - 点击头像
-(void)tapAvatarAction
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (isCameraSupport) {
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagepicker.allowsEditing = YES;
            imagepicker.delegate = self;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        if (isCameraSupport) {
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.allowsEditing = YES;
            imagepicker.delegate = self;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 照片选取代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        self.avatarImgV.image = image;
    }];
}

#pragma mark - 创建数据库
-(void)createDataBase
{
    _userDB = [[FMDatabase alloc] initWithPath:kUserDataBasePath];
    if ([_userDB open]) {
        NSLog(@"创建数据库成功");
    }
    else
    {
        NSLog(@"创建数据库失败");
    }
    [_userDB close];
}

#pragma mark - 创建联系人表
-(void)createLinkmanTab
{
    if ([_userDB open]) {
        //先检查联系人表是否存在，不存在的话在创建
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'",@"userTab"];
        
        FMResultSet *rs = [_userDB executeQuery:existsSql];
        
        NSInteger count = 0;
        while ([rs next]) {
            count = [rs intForColumn:@"countNum"];
            if (count == 1) {
                NSLog(@"存在");
                return;
            }
        }
        if(count < 1)
        {
            NSLog(@"不存在");
            //创建联系人表（包括头像、名字、年龄、手机号码）
            BOOL succeed = [_userDB executeUpdate:@"create table userTab (avatar blob,name text,age integer,phone integer)"];
            if (succeed) {
                NSLog(@"创建表成功");
            }
            else
            {
                NSLog(@"创建表失败");
            }
        }
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
    [_userDB close];
}

#pragma mark - 存储数据
-(void)saveUserData
{
    NSString *addNewPersonSql = @"insert into userTab (avatar,name,age,phone) values (?,?,?,?)";
    BOOL succeed = [_userDB executeUpdate:addNewPersonSql,(NSData *)UIImagePNGRepresentation(self.avatarImgV.image),self.nameTF.text,[NSNumber numberWithInteger:self.ageTF.text.integerValue],[NSNumber numberWithInteger:self.phonheNumTF.text.integerValue]];
    
    if (succeed) {
        NSLog(@"添加成功");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"添加失败");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"联系人添加失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
