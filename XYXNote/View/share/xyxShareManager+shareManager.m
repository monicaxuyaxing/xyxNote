//
//  xyxShareManager+shareManager.m
//  玩记
//
//  Created by monica on 16/7/20.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "xyxShareManager+shareManager.h"
#import "xyxShareButton.h"

@implementation xyxShareManager (shareManager)
- (void)creatShareView{
    
    self.shareBgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.shareBgView];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.shareBgView];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 200)];
    topView.userInteractionEnabled = YES;
    [self.shareBgView addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareView)];
    [topView addGestureRecognizer:tap];
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self.shareBgView addSubview:self.shareView];
    
    UILabel * shareLeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, 15)];
    shareLeLabel.text = NSLocalizedString(@"分享到", nil);
    shareLeLabel.textColor = [UIColor grayColor];
    shareLeLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:shareLeLabel];
    
    CGFloat itemWidth = 75.0f;
    UIScrollView * shareScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareLeLabel.frame)+20, ScreenWidth, 80)];
    shareScrollView.contentSize = CGSizeMake(itemWidth*shareNameArray.count, 0);
    shareScrollView.showsVerticalScrollIndicator = NO;
    shareScrollView.bounces = NO;
    shareScrollView.showsHorizontalScrollIndicator = NO;
    [self.shareView addSubview:shareScrollView];
    
    for (int i = 0; i < shareNameArray.count; i++) {
        xyxShareButton * shareBtn = [[xyxShareButton alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, 80)];
        [shareBtn setImage:[UIImage imageNamed:shareImageArray[i]] forState:UIControlStateNormal];
        [shareBtn setTitle:shareNameArray[i] forState:UIControlStateNormal];
        shareBtn.tag = i;
        [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [shareScrollView addSubview:shareBtn];
    }
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(10, self.shareView.frame.size.height - 50, self.shareView.frame.size.width - 20, 40);
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 6.0f;
    cancelBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    cancelBtn.layer.borderWidth = 0.8f;
    cancelBtn.tintColor = [UIColor grayColor];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:cancelBtn];
    self.shareBgView.hidden = YES;
}


@end
