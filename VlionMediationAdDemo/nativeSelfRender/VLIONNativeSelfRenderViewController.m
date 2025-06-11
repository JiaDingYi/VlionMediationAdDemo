//
//  VLIONNativeSelfRenderViewController.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/9.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VLIONNativeSelfRenderViewController.h"
#import <VlionMediationAd/VlionMediationNativeAd.h>
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface VLIONNativeSelfRenderViewController () <VlionNativeAdsManagerDelegate, VlionMNativeAdDelegate>

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnBidSuccess;
@property (nonatomic, strong) UIButton *btnBidFail;
@property (nonatomic, strong) VlionMediationNativeAd *nativeMediationAd;
@property (nonatomic, strong) VlionNativeAd *nativeAd;
@property (nonatomic, strong) VlionMCanvasView *nativeView;

@end

@implementation VLIONNativeSelfRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLoad.frame = CGRectMake(100, 100, 200, 30);
    [self.btnLoad setTitle:@"加载广告" forState:UIControlStateNormal];
    self.btnLoad.backgroundColor = [UIColor blackColor];
    [self.btnLoad setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnLoad.layer.cornerRadius = 10;
    self.btnLoad.layer.masksToBounds = YES;
    [self.btnLoad addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLoad];
    
    UIButton * btnShowInView = [UIButton buttonWithType:UIButtonTypeSystem];
    btnShowInView.frame = CGRectMake(100, 150, 200, 30);
    [btnShowInView setTitle:@"展现广告在self.view中" forState:UIControlStateNormal];
    btnShowInView.backgroundColor = [UIColor blackColor];
    [btnShowInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShowInView.layer.cornerRadius = 10;
    btnShowInView.layer.masksToBounds = YES;
    [btnShowInView addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowInView];
    
    self.btnBidSuccess = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnBidSuccess.frame = CGRectMake(100, 200, 200, 30);
    [self.btnBidSuccess setTitle:@"bid success" forState:UIControlStateNormal];
    self.btnBidSuccess.backgroundColor = [UIColor blackColor];
    [self.btnBidSuccess setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnBidSuccess.layer.cornerRadius = 10;
    self.btnBidSuccess.layer.masksToBounds = YES;
    [self.btnBidSuccess addTarget:self action:@selector(sendWinNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnBidSuccess];
    
    self.btnBidFail = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnBidFail.frame = CGRectMake(100, 250, 200, 30);
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
    [self appendLog:@"开始加载自渲染广告"];
    if (self.nativeAd) {
        self.nativeAd.delegate = nil;
        self.nativeAd = nil;
    }
    VlionAdSlot *slot1 = [[VlionAdSlot alloc] init];
    CGSize imageSize = CGSizeMake(1080, 1920);
    slot1.imgSize = imageSize;
    slot1.ID = @"103010783";
    // 如果是模板广告，返回高度将不一定是300，而是按照414和对应代码位在平台的配置计算出的高度
    slot1.adSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);
    // [可选]配置：静音
    slot1.mutedIfCan = YES;
    
    self.nativeMediationAd = [[VlionMediationNativeAd alloc] initWithSlot:slot1];
    // 配置：跳转控制器
    self.nativeMediationAd.rootViewController = self;
    // 配置：回调代理对象
    self.nativeMediationAd.delegate = self;
    // 开始加载广告
    [self.nativeMediationAd loadAdDataWithCount:3];
}

- (void)showAd {
    if (self.nativeAd.isExpressAd) {
        return;
    }
    self.nativeView = self.nativeAd.canvasView;
    CGFloat margin = 5;
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - (2 * margin);
    CGFloat height = 300;
    static UIEdgeInsets const padding = { 10, 15, 10, 15 };
    CGFloat y = padding.top;
    self.nativeView.frame = CGRectMake(5, 300, contentWidth , height);
    self.nativeView.titleLabel.frame = CGRectMake(padding.left, y, contentWidth, 30);
    self.nativeView.titleLabel.text = self.nativeAd.data.AdTitle;
    
    y += 30 + margin;
    self.nativeView.descLabel.frame = CGRectMake(padding.left, y, contentWidth, 30);;
    self.nativeView.descLabel.text = self.nativeAd.data.AdDescription;
    
    y += 70;
    if ([self isVideoWith:self.nativeAd]) {
        [self appendLog:@"video ad"];
        CGFloat videoHeight = self.nativeView.mediaView.frame.size.height ? : 200;
        self.nativeView.mediaView.frame = CGRectMake(padding.left, y, contentWidth, videoHeight);
        [self.nativeAd reSizeMediaView];
        y += videoHeight;
    } else {
        [self appendLog:@"image ad"];
        VlionImage *image = self.nativeAd.data.imageAry.firstObject;
        NSLog(@"%@", image);
        NSLog(@"%f", image.width);
        NSLog(@"%f", image.height);
        CGFloat imageHeight = 150;
        CGFloat imageWidth = 100;
        if (image) {
            imageWidth = (image.width / image.height) * 100;
            NSLog(@"%@", image.imageURL);
            [self.nativeView.imageView sd_setImageWithURL:[NSURL URLWithString:image.imageURL]];
        }
        self.nativeView.imageView.backgroundColor = [UIColor blackColor];
        self.nativeView.imageView.frame = CGRectMake(padding.left, y, imageWidth, imageHeight);
        y += imageHeight;
    }
    if (self.nativeView) {
        [self.nativeAd registerContainer:self.nativeView withClickableViews:@[self.nativeView]];
    }
    [self.view addSubview:self.nativeView];
}

- (void)sendWinNotification {
    [self.nativeMediationAd win:@1];
}

- (void)sendLossNotification {
    [self.nativeAd loss:@1 lossReason:@"" winBidder:@""];
}

- (BOOL)isVideoWith:(VlionNativeAd *)object {
    VlionFeedADMode mode = object.data.imageMode;
    return (mode == VlionFeedVideoAdModeImage) || (mode == VlionFeedVideoAdModePortrait);
}

#pragma mark - VlionNativeAdsManagerDelegate

- (void)nativeAdsManagerSuccessToLoad:(VlionMediationNativeAd *)adsManager nativeAds:(NSArray<VlionNativeAd *> *_Nullable)nativeAdDataArray {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
    
    for (VlionNativeAd *native in nativeAdDataArray) {
        if (native.isExpressAd) {
            [self appendLog:@"isExpressAd"];
        } else {
            self.nativeAd = native;
            self.nativeAd.delegate = self;
            [self appendLog:@"not ExpressAd"];
        }
    }
}

- (void)nativeAdsManager:(VlionMediationNativeAd *)adsManager didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

#pragma mark - VlionMNativeAdDelegate

/// 广告即将展示全屏页面/商店时触发
/// @param nativeAd 广告视图
- (void)nativeAdWillPresentFullScreenModal:(VlionNativeAd *_Nonnull)nativeAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 聚合维度混出模板广告时渲染成功回调，可能不会回调
/// @param nativeAd 模板广告对象
- (void)nativeAdExpressViewRenderSuccess:(VlionNativeAd *_Nonnull)nativeAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 聚合维度混出模板广告时渲染失败回调，可能不会回调
/// @param nativeAd 模板广告对象
/// @param error 渲染出错原因
- (void)nativeAdExpressViewRenderFail:(VlionNativeAd *_Nonnull)nativeAd error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 当视频播放状态改变之后触发
/// @param nativeAd 广告视图
/// @param playerState 变更后的播放状态
- (void)nativeAdVideo:(VlionNativeAd *_Nullable)nativeAd stateDidChanged:(VlionPlayerPlayState)playerState {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 广告视图中视频视图被点击时触发
/// @param nativeAd 广告视图
- (void)nativeAdVideoDidClick:(VlionNativeAd *_Nullable)nativeAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 广告视图中视频播放完成时触发
/// @param nativeAd 广告视图
- (void)nativeAdVideoDidPlayFinish:(VlionNativeAd *_Nullable)nativeAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 广告摇一摇提示view消除时调用该方法
/// @param nativeAd 广告视图
- (void)nativeAdShakeViewDidDismiss:(VlionNativeAd *_Nullable)nativeAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 激励信息流视频进入倒计时状态时调用
/// @param nativeAdView 广告视图
/// @param countDown : 倒计时
/// @Note : 当前该回调仅适用于CSJ广告 - v4200
- (void)nativeAdVideo:(VlionNativeAd *_Nullable)nativeAdView rewardDidCountDown:(NSInteger)countDown {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

@end
