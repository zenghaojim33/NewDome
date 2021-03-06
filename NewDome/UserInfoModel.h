//
//  UserInfoModel.h
//  NewDome
//
//  Created by Anson on 15/6/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserInfoModel : NSObject

@property(nonatomic,strong)NSString * userID;//用户id
@property(nonatomic,strong)NSString * phone;//手机号码
@property(nonatomic,strong)NSString * shopid;//店铺id
@property(nonatomic,strong)NSString * shopname;//店铺名
@property(nonatomic,strong)NSString * shopinfo;
@property(nonatomic,strong)NSString * address;
@property(nonatomic,strong)NSString * area;
@property(nonatomic,strong)NSString * bank;
@property(nonatomic,strong)NSString * bankno;
@property(nonatomic,strong)NSString * certificate;
@property(nonatomic,strong)NSString * city;
@property(nonatomic,strong)NSString * email;
@property(nonatomic,strong)NSString * provinces;
@property(nonatomic,strong)NSString * acountname;


+(UserInfoModel *)shareUserInfo;

@end
