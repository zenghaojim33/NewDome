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

-(void)updateModelWithDict:(NSDictionary *)dict
{
    
    
    self.shopname=[dict objectForKey:@"shopname"];
    self.shopinfo=[dict objectForKey:@"shopinfo"];
    self.acountname = dict[@"acountname"];
    self.address = dict[@"address"];
    self.area = dict[@"area"];
    self.bank = dict[@"bank"];
    self.bankno = dict[@"bankno"];
    self.certificate = dict[@"certificate"];
    self.city = dict[@"city"];
    self.email = dict[@"email"];
    self.provinces = dict[@"provinces"];
    
    
}


@end
