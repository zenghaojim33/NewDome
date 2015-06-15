//
//  MyIncomeModel.h
//  NewDome
//
//  Created by Anson on 15/6/13.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "DMBaseModel.h"


@interface MyIncomeModel : DMBaseModel


@property(nonatomic,copy)NSString * text;
@property(nonatomic,strong)NSArray * incomeArray;
@property(nonatomic)BOOL status;


@end


