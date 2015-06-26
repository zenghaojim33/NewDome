//
//  DSUserInfoModel.h
//  DoShop
//
//  Created by Anson on 15/2/4.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//



@interface DMBaseModel : MTLModel<MTLJSONSerializing>





/**
 *  JSON转对象
 *
 *  @param dict JSON解析的字典
 *
 *  @return 对象
 */
+(id)initWithDict:(NSDictionary*)dict;

+(id)initWithArray:(NSArray *)dict;


/**
 *  对象转回字典
 *
 *  @return 字典
 */

-(NSDictionary*)JSONDictionary;


/**
 *  保存单个对象
 *
 *  @param model 单个对象
 *  @param key   对应的Key
 */

+(void)saveObjectToCache:(DMBaseModel*)model andKey:(NSString*)key;



/**
 *  保存对象数组
 *
 *  @param cacheList 对象数组
 *  @param key       对应的key
 */

+(void)saveObjectListToCache:(NSArray*)cacheList andKey:(NSString*)key;


/**
 *  获取已缓存的对象数组
 *
 *  @param key 对应的key
 *
 *  @return 对象数组
 */
+(NSArray*)cacheListBykey:(NSString*)key;



/**
 *  获取已缓存的单个对象
 *
 *  @param key 对应的key
 *
 *  @return 对象
 */
+(id)cacheObjectByKey:(NSString*)key;




/**
 *  生成缓存对象
 *
 *  @return Tmcache
 */






//- (void)updateFrom:(NSDictionary *)parameters;


@end
