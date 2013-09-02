//
//  XMLGrab.h
//  ChinaNews
//
//  Created by apple on 13-7-23.
//  Copyright (c) 2013年 ChinaNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLGrab : NSObject
//拼接成完整头图xml地址
+(NSString *)getFullArticleURL:(NSString *)url;
// 判断网络实力否链接
+ (BOOL)connectedToNetwork;
// 根据URL获取网络数据（get）
+(NSString *)grabXMLContent:(NSString *)xmlURL;
// 是否使用缓存，获取网络数据（get）
+(NSString *)grabXMLContent:(NSString *)xmlURL useCache :(BOOL)cache;
// 根据URL获取网络数据（post 请求 传递 url，value，key)
+(NSString *)grabPostXMLContent:(NSString *)url sendValueArray:(NSMutableArray *)value keyArray:(NSMutableArray *)key;

//检查网络连接类型
+(NSString *)checkNetworktype;
@end
