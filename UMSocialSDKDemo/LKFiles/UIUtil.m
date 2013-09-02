//
//  UIUtil.m
//  LK
//
//  Created by larkersos on 13-8-5.
//  Copyright (c) 2013年 LK. All rights reserved.
//

#import "UIUtil.h"
#import "ConfigController.h"


@implementation UIUtil

// Return the formated string by a given date and seperator.
+ (NSDate *)getDateWithString:(NSString *)str formate:(NSString *)formate{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:str];
	return date;
}

+ (NSString *)getStringWithData:(NSDate *)date format:(NSString*)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:date];
	return string;
}

// 图片缩放
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scale
{
    // 新的大小
    CGSize size =[image size];
    size.height = size.height *scale;
    size.width =  size.width *scale;

    return [self scaleImage:image toSize:size];
}
+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 当前是否为夜间模式
+(BOOL)isNightModel{
//    LKAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
//    return appDelegate.isNight;
    return NO;
}

// 通过模式取得图片(默认取系统是否夜间模式，文件名没有后缀，默认png格式)
+(UIImage *)getImageByName:(NSString *)imageName{
    BOOL isNight = [UIUtil isNightModel];
    // 根据是否夜间模式取得图片
     return [UIUtil getImageByName:imageName imageType:@"png" isNight:isNight];
}
// 通过模式取得图片
+(UIImage *)getImageByName:(NSString *)imageName imageType:(NSString *) imageType{
    BOOL isNight = [UIUtil isNightModel];
    // 根据是否夜间模式取得图片
    return [UIUtil getImageByName:imageName imageType:imageType isNight:isNight];
}

// 通过模式取得图片(默认png格式)
+(UIImage *)getImageByName:(NSString *)imageName isNight:(BOOL)isNight{
    return [UIUtil getImageByName:imageName imageType:@"png" isNight:isNight];
}
+(UIImage *)getImageByName:(NSString *)imageName imageType:(NSString *) imageType isNight:(BOOL)night{
    if (night) {
        imageName = [imageName stringByAppendingFormat:@"-night"];
    }
    imageName = [imageName stringByAppendingFormat:@".%@",imageType];
    NSLog(@"imageName = %@", imageName);
    return [UIImage imageNamed:imageName];
}


//拼接成完整头图xml地址
+(NSString *)getFullArticleURL:(NSString *)url{
    NSString *fullArticleURL=url;
    if (![[url substringToIndex:7] isEqualToString:@"http://"]) {
        fullArticleURL=[NSString stringWithFormat:@"%@%@",NEWSDOMAIN,url];
    }
    return fullArticleURL;
}

@end
