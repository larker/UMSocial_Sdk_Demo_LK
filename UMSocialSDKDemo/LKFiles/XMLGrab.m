//
//  XMLGrab.m
//  ChinaNews
//
//  Created by apple on 13-7-23.
//  Copyright (c) 2013年 ChinaNews. All rights reserved.
//

#import "XMLGrab.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

#import "ChinaNewsAppDelegate.h"

#import "ConfigController.h"
#import "UIUtil.h"

@implementation XMLGrab

//拼接成完整头图xml地址
+(NSString *)getFullArticleURL:(NSString *)url{
    NSString *fullArticleURL=url;
    if (![[url substringToIndex:7] isEqualToString:@"http://"]) {
        fullArticleURL=[NSString stringWithFormat:@"%@%@",NEWSDOMAIN,url];
    }
    return fullArticleURL;
}

// 判断是不是有网络
+(BOOL)connectedToNetwork {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection) ? YES : NO;
}

// 根据URL获取网络数据（get）
+(NSString *)grabXMLContent:(NSString *)xmlURL{
    // 默认不使用缓存
    return [XMLGrab grabXMLContent:xmlURL useCache:YES];
}
// 根据URL获取网络数据（get）判断是否使用缓存
+(NSString *)grabXMLContent:(NSString *)xmlURL useCache:(BOOL)useCache{
    BOOL iscon=[XMLGrab connectedToNetwork];
    // 检查网络状态
//    if ([XMLGrab connectedToNetwork]==NO){
//        [UIUtil showAlertView:nil message:NETERROR_MESSAGE];
//        return nil;
//    }

    NSLog(@"xmlURL:%@",xmlURL);
    if (xmlURL==nil||[xmlURL isEqualToString:@""]) {
        return nil;
    }
    NSURL *url=[NSURL URLWithString:xmlURL];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    
    // 判断是否使用缓存
    if (useCache) {
        ChinaNewsAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
        [request setDownloadCache:appDelegate.myCache];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    // 请求
    [request startSynchronous];
    NSError *error=[request error];
    if (!error) {
        NSString *result=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        //NSLog(@"[XMLGrab grabXMLContent]:%@",result);
        return result;
    }
    else
    {
        if (iscon==NO) {
            [UIUtil showAlertView:@"网络连接错误" message:NETERROR_MESSAGE];
            return nil;
        }
        else
        {
            [UIUtil showAlertView:@"通讯错误" message:[error localizedDescription]];
            return nil;
        }
    }
    return nil;
}

//  post 请求
+(NSString *)grabPostXMLContent:(NSString *)url sendValueArray:(NSMutableArray *)value keyArray:(NSMutableArray *)key
{
    // 检查网络状态
    if ([XMLGrab connectedToNetwork]==NO){
        [UIUtil showAlertView:@"网络连接错误" message:NETERROR_MESSAGE];
        return nil;
    }
    
    NSURL *currUrl=[NSURL URLWithString:url];                          
    ASIFormDataRequest *postRequest = [ASIFormDataRequest requestWithURL:currUrl];
     NSLog(@"[XMLGrab grabXMLContent] url:%@",url);
    //发起POST请求
    [postRequest setRequestMethod:@"POST"];
    [postRequest setPostValue:@"chinanews" forKey:@"source"];  //客户端来源
//    [postRequest setPostValue:UDID forKey:@"hwId"];          //硬件ID
    
    if (0<[key count] && 0<[value count]){
        NSMutableArray *keyArray=key;
        NSMutableArray *valueArray=value;
        
        for (int i=0; i<[key count]; i++)
        {
            [postRequest setPostValue:[key objectAtIndex:i] forKey:[keyArray objectAtIndex:i]];
            NSLog(@"[%@:%@]", [keyArray objectAtIndex:i], [valueArray objectAtIndex:i]);
        }
        [self seeRequestUrl:valueArray keyArray:keyArray];
    }
    
    [postRequest setTimeOutSeconds:10];
    ChinaNewsAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    [postRequest setDelegate:appDelegate];
    
   [postRequest startAsynchronous];  //开始异步请求
    NSError *error=[postRequest error];
    if (!error) {
        NSString *result=[[NSString alloc]initWithData:postRequest.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"[XMLGrab grabXMLContent]:%@",result);
        return result;
    }
    return nil;
}
// 测试时用，看post 请求 的 url
+(void)seeRequestUrl:(NSMutableArray *)value keyArray:(NSMutableArray *)key
{
    NSMutableString *urlPinJie=[NSMutableString stringWithFormat:@"post请求参数",nil];
    for (int i=0; i<[key count]; i++)
    {
        [urlPinJie appendString:@"&"];
        [urlPinJie appendString:[key objectAtIndex:i]];
        [urlPinJie appendString:@"="];
        [urlPinJie appendString:[value objectAtIndex:i]];
    }
    NSLog(@"Request param: %@",urlPinJie);
}

//检查网络连接类型
+(NSString *)checkNetworktype{
    NSString *connectionKind;
    if ([self connectedToNetwork]) {
        Reachability * hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        switch ([hostReach currentReachabilityStatus]) {
            case NotReachable:
                connectionKind = @"没有网络链接";
                break;
            case ReachableViaWiFi:
                connectionKind = @"WIFI";
                break;
            case kReachableViaWWAN:
                connectionKind = @"WWAN";
                break;
            default:
                break;
        }
    }else {
        connectionKind = @"没有网络链接";
    }
    return connectionKind;
}

@end
