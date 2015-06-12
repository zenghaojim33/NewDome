//
//  CategoryModel.h
//  NewDome
//
//  Created by Anson on 15/6/12.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject



@property(nonatomic,strong)NSString * categoryId;
@property(nonatomic,strong)NSString * categoryName;
@property(nonatomic,strong)NSString * path;
@property(nonatomic)BOOL isSelect;

@end
