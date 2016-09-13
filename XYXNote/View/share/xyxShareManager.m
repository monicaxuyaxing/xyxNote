//
//  xyxShareManager.m
//  玩记
//
//  Created by monica on 16/7/20.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "xyxShareManager.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "xyxShareManager+shareManager.h"
#import "Constants.h"
#import "UMSocialData.h"
#import "UMSocialSnsPlatformManager.h"
#import "NotepadViewController.h"
#import "UMSocialDataService.h"
#import "SVProgressHUD.h"




@interface xyxShareManager() {
    NotepadViewController *_shareVC;
    NSString *_content;
    UIImage *_image;
    NSString *_url;
}

@end



@implementation xyxShareManager

+ (void)setShareAppKey{
    [UMSocialData setAppKey:kUMAppId];
    //微信
    [UMSocialWechatHandler setWXAppId:kWeixinAppID appSecret:kWeixinAppSecret url:Url];
    //朋友圈
    [UMSocialWechatHandler setWXAppId:kWeixinAppID appSecret:kWeixinAppSecret url:Url];
    // 新浪
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppID secret:kSinaAppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    // QQ
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:Url];
    // QQ控件
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:Url];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatShareView];
    }
    return self;
}

- (void)setShareVC:(NotepadViewController *)vc content:(NSString *)content image:(UIImage *)image url:(NSString *)url{
    _shareVC = vc;
    _content = content;
    _image = image;
    _url = url;
}

- (void)show{
    self.shareBgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.shareView.frame = CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hiddenShareView{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.shareView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
    } completion:^(BOOL finished) {
        self.shareBgView.hidden = YES;
    }];
}

- (void)shareAction:(UIButton *)sender{
    [self hiddenShareView];
    NSString * titleStr = _content;
    NSString * urlStr = _url;
    UIImage  * image = _image;
    NSArray *shareType;
    if (sender.tag == 0) {
        // 微信
        shareType = @[UMShareToWechatSession];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = titleStr;
    }else if (sender.tag == 1) {
        // 朋友圈
        shareType = @[UMShareToWechatTimeline];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleStr;
    }else if (sender.tag == 2) {
        // 新浪
        titleStr = [NSString stringWithFormat:@"%@ %@(分享来自应用:玩记)",titleStr,urlStr];
        shareType = @[UMShareToSina];
    }else{
        if ([TencentOAuth iphoneQQInstalled]) {
            if (sender.tag == 3) {
                // QQ
                shareType = @[UMShareToQQ];
                [UMSocialData defaultData].extConfig.qqData.url = urlStr;
                [UMSocialData defaultData].extConfig.qqData.title = titleStr;
            }else if (sender.tag == 4) {
                // QQ空间
                shareType = @[UMShareToQzone];
                [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;
                [UMSocialData defaultData].extConfig.qzoneData.title = titleStr;
            }
        } else {
            NSLog(@"程序未安装,请到App Store下载");
            [SVProgressHUD showErrorWithStatus:@"程序未安装,请到App Store下载"];
            
            return;
        }
    }
    [self postShareWith:shareType content:titleStr image:image];
}

- (void)postShareWith:(NSArray *)type content:(NSString *)content image:(id)image{
    [[UMSocialDataService defaultDataService] postSNSWithTypes:type content:content image:image location:nil urlResource:nil presentedController:_shareVC completion:^(UMSocialResponseEntity *response){
        [self shareFinishWith:response];
    }];
}

// 分享完成
- (void)shareFinishWith:(UMSocialResponseEntity *)response{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
    }else if (response.responseCode == UMSResponseCodeCancel) {
        NSLog(@"取消");
    }else {
        NSLog(@"失败");
    }
}


@end
