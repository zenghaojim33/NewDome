//
//  UserInfoModel.m
//  NewDome
//
//  Created by Anson on 15/6/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel



+ (UserInfoModel *) shareUserInfo
{
    static UserInfoModel * userInfoModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoModel = [[self alloc] init];
    });
    
    return userInfoModel;
}




@end
