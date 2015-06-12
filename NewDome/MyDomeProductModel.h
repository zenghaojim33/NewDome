//
//  MyDomeProductModel.h
//  NewDome
//
//  Created by Anson on 15/6/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "DMBaseModel.h"

@interface MyDomeProductModel : DMBaseModel

@property(nonatomic,strong)NSString * brandid;
@property(nonatomic,strong)NSString * brandname;
@property(nonatomic,strong)NSString * categoryId;
@property(nonatomic,strong)NSString * categoryName;
@property(nonatomic,strong)NSString * marketPrice;
@property(nonatomic,strong)NSString * price;
@property(nonatomic,strong)NSString * productId;
@property(nonatomic,strong)NSString * productName;
@property(nonatomic,strong)NSString * shopPrice;
@property(nonatomic,strong)NSArray * TitleImages;
@property(nonatomic,copy)NSIndexPath * indexPath;

@property(nonatomic,assign)BOOL isSelected;

@end
