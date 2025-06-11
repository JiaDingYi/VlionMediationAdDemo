//
//  VLIONInterstitialViewController.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/5.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VLIONInterstitialViewController.h"
#import <VlionMediationAd/VlionMediationInterstitialAd.h>

@interface VLIONInterstitialViewController () <VlionNativeExpressFullscreenVideoAdDelegate>
@property (nonatomic, strong) VlionMediationInterstitialAd *interstitialAd;
@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;
@property (nonatomic, strong) UIButton *btnBidSuccess;
@property (nonatomic, strong) UIButton *btnBidFail;
@property (nonatomic, assign) BOOL  isLoded;

@property (nonatomic, strong) UITextField *placementIDField;
@property (nonatomic, strong) UITextField *countdownField;

@end

@implementation VLIONInterstitialViewController

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
    [self appendLog:@"开始加载插屏广告"];
    if (self.interstitialAd) {
        self.interstitialAd = nil;
        self.interstitialAd.delegate = nil;
    }
    self.interstitialAd = [[VlionMediationInterstitialAd alloc] initWithSlotID:@"103010227"];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdData];
}

- (void)showAd {
    [self.interstitialAd showAdFromRootViewController:self];
}

- (void)sendWinNotification {
    [self.interstitialAd win:@1];
}

- (void)sendLossNotification {
    [self.interstitialAd loss:@1 lossReason:@"1" winBidder:@"11"];
}

#pragma mark - VlionNativeExpressFullscreenVideoAdDelegate

/**
 This method is called when video ad material loaded successfully.
 */
- (void)nativeExpressFullscreenVideoAdDidLoad:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressFullscreenVideoAd:(VlionMediationInterstitialAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when rendering a nativeExpressAdView successed.
 It will happen when ad is show.
 */
// Mediation:/// @Note :  (针对聚合维度广告)<6300版本不会回调该方法，>=6300开始会回调该方法，但不代表最终展示广告的渲染结果。
- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(VlionMediationInterstitialAd *)rewardedVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
// Mediation:/// @Note :  (针对聚合维度广告)<6300版本不会回调该方法，>=6300开始会回调该方法，但不代表最终展示广告的渲染结果。
- (void)nativeExpressFullscreenVideoAdViewRenderFail:(VlionMediationInterstitialAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video cached successfully.
 For a better user experience, it is recommended to display video ads at this time.
 And you can call [BUNativeExpressFullscreenVideoAd showAdFromRootViewController:].
 */
- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad slot will be showing.
 */
// Mediation:/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)nativeExpressFullscreenVideoAdWillVisible:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad slot has been shown.
 */
- (void)nativeExpressFullscreenVideoAdDidVisible:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad is clicked.
 */
- (void)nativeExpressFullscreenVideoAdDidClick:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when the user clicked skip button.
 */
- (void)nativeExpressFullscreenVideoAdDidClickSkip:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad is about to close.
 */
// Mediation:/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)nativeExpressFullscreenVideoAdWillClose:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad is closed.
 */
- (void)nativeExpressFullscreenVideoAdDidClose:(VlionMediationInterstitialAd *)fullscreenVideoAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(VlionMediationInterstitialAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
This method is used to get the type of nativeExpressFullScreenVideo ad
 */
// Mediation:/// @Note :  当加载聚合维度广告时，不支持该回调。
- (void)nativeExpressFullscreenVideoAdCallback:(VlionMediationInterstitialAd *)fullscreenVideoAd withType:(VlionNativeExpressFullScreenAdType) nativeExpressVideoAdType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressFullscreenVideoAdDidCloseOtherController:(VlionMediationInterstitialAd *)fullscreenVideoAd interactionType:(VlionInteractionType)interactionType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

@end
