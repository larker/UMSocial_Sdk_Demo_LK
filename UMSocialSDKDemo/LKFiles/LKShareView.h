//
//  LKShareView.h
//  LK
//
//  Created by larkersos on 13-8-29.
//  Copyright (c) 2013年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKShareView : UIView

@property (nonatomic, strong) id delegate;

- (id)initWithShareText:(NSString *)shareText shareUrl:(NSString *) shareUrl;
- (void)show;
- (void)hide;
@end
