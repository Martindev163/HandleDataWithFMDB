//
//  UserModel.h
//  HandleDataWithFMDB
//
//  Created by 马浩哲 on 16/11/18.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSData *avatarData;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *phone;

@end
