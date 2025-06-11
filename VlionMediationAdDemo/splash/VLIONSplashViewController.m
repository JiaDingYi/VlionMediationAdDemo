//
//  VLIONSplashViewController.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/5.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VLIONSplashViewController.h"
#import <VlionMediationAd/VlionMediationSplashAd.h>

@interface VLIONSplashViewController () <VlionSplashAdDelegate, VlionSplashCardDelegate>
@property (nonatomic, strong) VlionMediationSplashAd *splashAd;
@property (nonatomic, assign) BOOL isLoded;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation VLIONSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btn.frame = CGRectMake(100, 100, 100, 30);
    [self.btn setTitle:@"加载广告" forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor blackColor];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.layer.cornerRadius = 10;
    self.btn.layer.masksToBounds = YES;
    [self.btn addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    [self setupLogTextView];
}

- (void)loadAd {
    [self appendLog:@"开始加载开屏广告"];
    if (self.splashAd) {
        self.splashAd.delegate = nil;
        self.splashAd = nil;
    }
    self.splashAd = [[VlionMediationSplashAd alloc] initWithSlotID:@"103513801" adSize:[UIScreen mainScreen].bounds.size];
    // // 配置：回调代理对象。不支持中途更改代理，中途更改代理会导致接收不到广告相关回调，如若存在中途更改代理场景，需自行处理相关逻辑，确保广告相关回调正常执行。
    self.splashAd.delegate = self;
    self.splashAd.cardDelegate = self;
    // [可选]配置：是否展示卡片视图，默认不开启，仅支持穿山甲广告
    self.splashAd.supportCardView = YES;
    self.splashAd.customBottomView = [self returnBottomView];
    self.splashAd.tolerateTimeout = 3;
    [self.splashAd loadAdData];
}

- (UIView *)returnBottomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    view.backgroundColor = [UIColor blueColor];

    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, 200, 50);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"底部logo自定义区域";
    lab.center = CGPointMake(CGRectGetWidth(view.frame) / 2.f, CGRectGetHeight(view.frame) / 2.f);
    lab.textColor = [UIColor whiteColor];
    [view addSubview:lab];

    return view;
}

#pragma mark - VlionSplashAdDelegate

/// This method is called when material load successful
- (void)splashAdLoadSuccess:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
    [self.splashAd showSplashViewInRootViewController:[[[UIApplication sharedApplication] delegate] window].rootViewController];
}

/// This method is called when material load failed
- (void)splashAdLoadFail:(VlionMediationSplashAd *)splashAd error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s, error: %@", __FUNCTION__, error];
    [self appendLog:function];
}

/// This method is called when splash view render successful
- (void)splashAdRenderSuccess:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method is called when splash view render failed
- (void)splashAdRenderFail:(VlionMediationSplashAd *)splashAd error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s, error: %@", __FUNCTION__, error];
    [self appendLog:function];
}

/// This method is called when splash view will show
- (void)splashAdWillShow:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method is called when splash view did show
- (void)splashAdDidShow:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method is called when splash view is clicked.
- (void)splashAdDidClick:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method is called when splash view is closed.
- (void)splashAdDidClose:(VlionMediationSplashAd *)splashAd closeType:(VlionSplashAdCloseType)closeType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method is called when splash viewControllr is closed.
// Mediation:/// @Note : 当加载聚合维度广告，最终展示的广告关闭时，
// Mediation:///         如该adn未提供“控制器关闭”回调，为保持逻辑完整，聚合逻辑内部在DidClose后补齐该回调，
// Mediation:///         如该adn提供“控制器关闭”回调，则以对应adn为准。
- (void)splashAdViewControllerDidClose:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashDidCloseOtherController:(VlionMediationSplashAd *)splashAd interactionType:(VlionInteractionType)interactionType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method is called when when video ad play completed or an error occurred.
- (void)splashVideoAdDidPlayFinish:(VlionMediationSplashAd *)splashAd didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

#pragma mark - VlionSplashCardDelegate
/// This method is called when splash card is ready to show.
- (void)splashCardReadyToShow:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
    [splashAd showCardViewInRootViewController:[[[UIApplication sharedApplication] delegate] window].rootViewController];
}

/// This method is called when splash card is clicked.
- (void)splashCardViewDidClick:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method is called when splash card is closed.
- (void)splashCardViewDidClose:(VlionMediationSplashAd *)splashAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

@end
