//
//  ChinaNewsShareView.m
//  ChinaNews
//
//  Created by larkersos on 13-8-29.
//  Copyright (c) 2013年 ChinaNews. All rights reserved.
//

#import "LKShareView.h"

#import "UIUtil.h"
#import "ConfigController.h"
#import "UMSocial.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height//获取屏幕高度
#define VIEW_HEIGHT    270   //获取view高度

@implementation LKShareView
{
    NSString *_shareText;
    NSString *_shareUrl;
    
    UIImageView *_bgView;
    UIButton *_cancleBtn;
    
    NSArray *_shareToSns;
    NSArray *_shareToSnsNames;
}

- (id)initWithShareText:(NSString *)shareText shareUrl:(NSString *) shareUrl;{
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, VIEW_HEIGHT)];
    if (self) {
        // Initialization code
        _shareText = [shareText stringByAppendingFormat:@" %@",[UIUtil getFullArticleURL:shareUrl ]];
        _shareUrl = shareUrl;
        
        
        // 可分享的平台
        _shareToSns = [NSArray arrayWithObjects:@"sina",@"tencent",@"wechat_session",@"wechat_timeline",@"email",@"sms",nil];
        _shareToSnsNames = [NSArray arrayWithObjects:@"新浪微博",@"腾讯微博",@"微信",@"微信朋友圈",@"邮件",@"短信",nil];

        [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToEmail,UMShareToSms]];
        
        float scalBg = 0.5;
        // 背景
        if (!_bgView) {
            _bgView = [[UIImageView alloc] init];
        }else{
            [_bgView removeFromSuperview];
        }
        [_bgView setFrame:CGRectMake(0, 0, 320, VIEW_HEIGHT)];
        
        UIImage *bgImg = [UIUtil getImageByName:@"bg_fenx" isNight:NO];
        [UIUtil scaleImage:bgImg toScale:scalBg];
        [_bgView setImage:bgImg];
        [self addSubview:_bgView];
        
        
        // 以下是需要分享的平
        int indexIcon = 0;
        
        //图标菜单位置参数

        int sepHeight = (690-536)/2 -10;
        int sepWidth = (182-44)/2;
        int sepHeightLable = -15; // 微调label和图片的高度位置
        // 图标大小
        int iconHeight = 136/2;
        int iconWidth = 136/2;
        // label大小
        int lableHeight = 15;
        int lableWidth = iconWidth+5;
        // 坐标
        int topX = 22;
        int topY = SCREEN_HEIGHT - (960-536) -5;
        NSLog(@"SCREEN_HEIGHT = %f",SCREEN_HEIGHT);
        for (indexIcon=0; indexIcon<[_shareToSns count]; indexIcon++) {
            NSString *snsName = [@"fenx_" stringByAppendingFormat:@"%@",_shareToSns[indexIcon]];
            NSString *snsName2 = [@"fenx_" stringByAppendingFormat:@"%@2",_shareToSns[indexIcon]];
            UIImage *snsImg = [UIUtil getImageByName:snsName isNight:NO];
            UIImage *snsImg2 = [UIUtil getImageByName:snsName2 isNight:NO];


            //分享按钮
            UIButton *btnShare=[UIButton buttonWithType:UIButtonTypeCustom];
            [btnShare setFrame:CGRectMake(topX, topY, iconWidth, iconHeight)];
            [btnShare setImage:snsImg forState:UIControlStateNormal];
            [btnShare setImage:snsImg2 forState:UIControlStateSelected];
            [btnShare addTarget:self action:@selector(doClickShare:) forControlEvents:UIControlEventTouchUpInside];
            btnShare.tag = indexIcon;
            [self addSubview:btnShare];
            
            UILabel * tempLable= [[UILabel alloc]initWithFrame:CGRectMake(topX, topY+iconHeight+sepHeightLable, lableWidth, lableHeight)];
            [tempLable setText:_shareToSnsNames[indexIcon]];
            [tempLable setTextAlignment:NSTextAlignmentCenter];
            [tempLable setFont:[UIFont systemFontOfSize:Sns_LABLE_SIZE]];
            [tempLable setBackgroundColor:[UIColor clearColor]];
            [tempLable setTextColor:Sns_Title_Color];
            [self addSubview:tempLable];
            
            
            topX = topX+sepWidth;
            if (indexIcon > 0 && ((indexIcon+1) %4 == 0)) {
                // 换行
                topX= 22;
                topY = topY +sepHeight;
            }
        }

        // 以上是需分享的平台
        
        
        // 取消按钮
        if (!_cancleBtn) {
            _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }else{
            [_cancleBtn removeFromSuperview];
        }
        [_cancleBtn setFrame:CGRectMake(22, VIEW_HEIGHT-70, 554*scalBg, 76*scalBg)];

        // 取消按钮背景图
        [_cancleBtn setBackgroundImage:[UIUtil getImageByName:@"btn_fenx_qx" isNight:NO] forState:(UIControlStateNormal)];
        [_cancleBtn setBackgroundImage:[UIUtil getImageByName:@"btn_fenx_qx2" isNight:NO] forState:(UIControlStateHighlighted)];
        
        [_cancleBtn addTarget:self action:@selector(cancleShare:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)doClickShare:(id)sender{
    //分享内嵌文字
    [UMSocialData defaultData].shareText = _shareText;
    //分享内嵌图片
//    [UMSocialData defaultData].shareImage = [UIImage imageNamed:@"UMS_social_demo"];
    
    //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:((UIButton *)sender).tag];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self.delegate,[UMSocialControllerService defaultControllerService],YES);
}

- (void)show{
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT-VIEW_HEIGHT, 320, VIEW_HEIGHT);
    } completion:^(BOOL finished) {

        // 使用友盟分享转发平台组件
        // listView presentSnsController
        // 图标形式presentSnsIconSheetView
//        [UMSocialSnsService presentSnsController:self 
//                                          appKey:APP_KEY_UMENG
//                                       shareText:_shareText
//                                      shareImage:nil
//                                 shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToEmail,UMShareToSms,nil]
//                                        delegate:nil];
        //    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline]];
        //`UMShareToSina`,`UMShareToTencent`,`UMShareToWechatSession`,`UMShareToWechatTimeline`，`UMShareToRenren`,`UMShareToDouban`,`UMShareToQzone`,`UMShareToEmail`,`UMShareToSms`,`UMShareToFacebook`,`UMShareToTwitter`    分别对应新浪微博、腾讯微博、微信好友、微信朋友圈、人人网、豆瓣、QQ空间、邮箱、短信、Facebook、Twitter。 
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, 320, VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


//实现回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


#pragma mark - Button Handler

/*
 * @ 取消
 */
- (void)cancleShare:(id)sender{
    [self hide];
}

@end
