//
//  VLIONRewardVideoViewController.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/5.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VLIONRewardVideoViewController.h"
#import <VlionMediationAd/VlionMediationRewardVideoAd.h>

@interface VLIONRewardVideoViewController () <VlionNativeExpressRewardedVideoAdDelegate>

@property (nonatomic, strong) VlionMediationRewardVideoAd *rewardVideoAd;
@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;
@property (nonatomic, strong) UIButton *btnBidSuccess;
@property (nonatomic, strong) UIButton *btnBidFail;
@property (nonatomic, assign) BOOL  isLoded;

@end

@implementation VLIONRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLoad.frame = CGRectMake(100, 100, 100, 30);
    [self.btnLoad setTitle:@"加载广告" forState:UIControlStateNormal];
    self.btnLoad.backgroundColor = [UIColor blackColor];
    [self.btnLoad setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnLoad.layer.cornerRadius = 10;
    self.btnLoad.layer.masksToBounds = YES;
    [self.btnLoad addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLoad];
    
    self.btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnShow.frame = CGRectMake(100, 140, 100, 30);
    [self.btnShow setTitle:@"展现广告" forState:UIControlStateNormal];
    self.btnShow.backgroundColor = [UIColor blackColor];
    [self.btnShow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnShow.layer.cornerRadius = 10;
    self.btnShow.layer.masksToBounds = YES;
    [self.btnShow addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnShow];
    
    self.btnBidSuccess = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnBidSuccess.frame = CGRectMake(100, 180, 100, 30);
    [self.btnBidSuccess setTitle:@"bid success" forState:UIControlStateNormal];
    self.btnBidSuccess.backgroundColor = [UIColor blackColor];
    [self.btnBidSuccess setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnBidSuccess.layer.cornerRadius = 10;
    self.btnBidSuccess.layer.masksToBounds = YES;
    [self.btnBidSuccess addTarget:self action:@selector(sendWinNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnBidSuccess];
    
    self.btnBidFail = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnBidFail.frame = CGRectMake(100, 220, 100, 30);
    [self.btnBidFail setTitle:@"bid fail" forState:UIControlStateNormal];
    self.btnBidFail.backgroundColor = [UIColor blackColor];
    [self.btnBidFail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnBidFail.layer.cornerRadius = 10;
    self.btnBidFail.layer.masksToBounds = YES;
    [self.btnBidFail addTarget:self action:@selector(sendLossNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnBidFail];

    [self setupLogTextView];
}

- (void)loadAd {
    [self appendLog:@"开始加载激励视频广告"];
    if (self.rewardVideoAd) {
        self.rewardVideoAd.delegate = nil;
        self.rewardVideoAd = nil;
    }
    self.rewardVideoAd = [[VlionMediationRewardVideoAd alloc] initWithSlotID:@"103011517"];
    self.rewardVideoAd.delegate = self;
    [self.rewardVideoAd loadAdData];
}

- (void)showAd {
    [self.rewardVideoAd showAdFromRootViewController:self];
}

- (void)sendWinNotification {
    [self.rewardVideoAd win:@1];
}

- (void)sendLossNotification {
    [self.rewardVideoAd loss:@1 lossReason:@"" winBidder:@""];
}

#pragma mark - VlionNativeExpressRewardedVideoAdDelegate
/**
 This method is called when video ad material loaded successfully.
 */
- (void)nativeExpressRewardedVideoAdDidLoad:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAd:(VlionMediationRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}
/**
  this methods is to tell delegate the type of native express rewarded video Ad
 */
// Mediation:/// @Note :  当加载聚合维度广告时，不支持该回调。
- (void)nativeExpressRewardedVideoAdCallback:(VlionMediationRewardVideoAd *)rewardedVideoAd withType:(VlionNativeExpressRewardedVideoAdType)nativeExpressVideoType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when cached successfully.
 For a better user experience, it is recommended to display video ads at this time.
 And you can call [VlionMediationRewardVideoAd showAdFromRootViewController:].
 */
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when rendering a nativeExpressAdView successed.
 It will happen when ad is show.
 */
// Mediation:/// @Note :  (针对聚合维度广告)<6300版本不会回调该方法，>=6300开始会回调该方法，但不代表最终展示广告的渲染结果。
- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
// Mediation:/// @Note :  (针对聚合维度广告)<6300版本不会回调该方法，>=6300开始会回调该方法，但不代表最终展示广告的渲染结果。
- (void)nativeExpressRewardedVideoAdViewRenderFail:(VlionMediationRewardVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad slot will be showing.
 */
// Mediation:/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)nativeExpressRewardedVideoAdWillVisible:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad slot has been shown.
 */
- (void)nativeExpressRewardedVideoAdDidVisible:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad is about to close.
 */
// Mediation:/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)nativeExpressRewardedVideoAdWillClose:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad is closed.
 */
- (void)nativeExpressRewardedVideoAdDidClose:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad is clicked.
 */
- (void)nativeExpressRewardedVideoAdDidClick:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when the user clicked skip button.
 */
- (void)nativeExpressRewardedVideoAdDidClickSkip:(VlionMediationRewardVideoAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(VlionMediationRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 Server verification which is requested asynchronously is succeeded. now include two v erify methods:
      1. C2C need  server verify  2. S2S don't need server verify
 @param verify :return YES when return value is 2000.
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(VlionMediationRewardVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
  Server verification which is requested asynchronously is failed.
  @param rewardedVideoAd express rewardVideo Ad
  @param error request error info
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(VlionMediationRewardVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressRewardedVideoAdDidCloseOtherController:(VlionMediationRewardVideoAd *)rewardedVideoAd interactionType:(VlionInteractionType)interactionType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

@end
