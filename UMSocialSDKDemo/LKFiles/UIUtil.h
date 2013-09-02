//
//  UIUtil.h
//  LK
//
//  Created by larkersos on 13-8-5.
//  Copyright (c) 2013年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// BackgroundColor
#define  Background_Color           UIColorFromRGB(0xf6f6f6)
#define  Background_Color_Night     [UIColor blackColor]
#define  Text_Color                 UIColorFromRGB(0x434343)
#define  Text_Lab_Color             Text_Color
#define  Detail_Lab_Color           UIColorFromRGB(0x434343)
#define  Title_Color                UIColorFromRGB(0x666666)

//分享转发用
#define  Sns_Title_Color            UIColorFromRGB(0x808080)
//字体
#define  Sns_LABLE_SIZE             14

//字体
#define  LABLE_SIZE                 16
//字体25
#define  LABLE_BIG_SIZE             25
//字体28
#define  LABLE_BIG2_SIZE            28

@interface UIUtil : NSObject <UIAlertViewDelegate>

// 取得格式化时间
+ (NSDate *)getDateWithString:(NSString *)str formate:(NSString *)formate;
+ (NSString *)getStringWithData:(NSDate *)date format:(NSString*)format;

// 图片缩放
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scale;
+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

// 当前是否为夜间模式
+(BOOL)isNightModel;

// 通过模式取得图片(默认取系统是否夜间模式，文件名没有后缀，默认png格式)
+(UIImage *)getImageByName:(NSString *)imageName;
// 通过模式取得图片
+(UIImage *)getImageByName:(NSString *)imageName imageType:(NSString *) imageType;
+(UIImage *)getImageByName:(NSString *)imageName isNight:(BOOL)night;
+(UIImage *)getImageByName:(NSString *)imageName imageType:(NSString *) imageType isNight:(BOOL)night;

//拼接成完整头图xml地址
+(NSString *)getFullArticleURL:(NSString *)url;
@end
