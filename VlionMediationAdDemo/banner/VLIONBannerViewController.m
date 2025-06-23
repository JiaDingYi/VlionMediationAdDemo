//
//  VLIONBannerViewController.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/16.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VLIONBannerViewController.h"
#import <VlionMediationAd/VlionMediationBannerView.h>

@interface VLIONBannerViewController () <VlionNativeExpressBannerViewDelegate>
@property (nonatomic, strong) VlionMediationBannerView *bannerAd;

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;
@property (nonatomic, strong) UIButton *btnBidSuccess;
@property (nonatomic, strong) UIButton *btnBidFail;
@property (nonatomic, assign) BOOL  isLoded;
@property (nonatomic) CGSize  adSize;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation VLIONBannerViewController

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
    
    // 添加日志输出控件
    [self setupLogTextView];
}

- (void)loadAd {
    [self appendLog:@"开始加载广告"];
    if (self.bannerAd) {
        [self.containerView removeFromSuperview];
        self.bannerAd.delegate = nil;
        self.bannerAd = nil;
    }
    
    // 模版比例
    CGFloat scale = 320.f / 50.f;
    CGFloat containerW = self.view.frame.size.width;
    CGFloat containerH = containerW / scale;
    self.adSize = CGSizeMake(containerW, containerH);
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.adSize.width, self.adSize.height)];
    self.containerView.backgroundColor = [UIColor blueColor];
    
    VlionAdSlot *solt = [[VlionAdSlot alloc] init];
    solt.ID = @"103010581";
    solt.mutedIfCan = YES;
    self.bannerAd = [[VlionMediationBannerView alloc] initWithSlot:solt rootViewController:self adSize:self.adSize];
    self.bannerAd.frame = CGRectMake(0, 0, self.adSize.width, self.adSize.height);
    self.bannerAd.delegate = self;
    [self.bannerAd loadAdData];
}

- (void)sendWinNotification {
    [self appendLog:@"发送竞价成功通知"];
    [self.bannerAd win:@1];
}

- (void)sendLossNotification {
    [self appendLog:@"发送竞价失败通知"];
    [self.bannerAd loss:@1 lossReason:@"" winBidder:@""];
}

- (void)showAd {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.bannerAd];
}

#pragma mark - VlionNativeExpressBannerViewDelegate
/**
 This method is called when bannerAdView ad slot loaded successfully.
 @param bannerAdView : view for bannerAdView
 */
- (void)nativeExpressBannerAdViewDidLoad:(VlionMediationBannerView *)bannerAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when bannerAdView ad slot failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdView:(VlionMediationBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when rendering a nativeExpressAdView successed.
 */
// Mediation:/// @Note :  (针对聚合维度广告)<6400版本不会回调该方法，>=6400开始会回调该方法，但不代表最终展示广告的渲染结果。
- (void)nativeExpressBannerAdViewRenderSuccess:(VlionMediationBannerView *)bannerAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdViewRenderFail:(VlionMediationBannerView *)bannerAdView error:(NSError * __nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when bannerAdView ad slot showed new ad.
// Mediation:@Note :  Mediation dimension does not support this callBack.
 */
- (void)nativeExpressBannerAdViewWillBecomVisible:(VlionMediationBannerView *)bannerAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when bannerAdView is clicked.
 */
- (void)nativeExpressBannerAdViewDidClick:(VlionMediationBannerView *)bannerAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when the user clicked dislike button and chose dislike reasons.
 @param filterwords : the array of reasons for dislike.
 */
- (void)nativeExpressBannerAdView:(VlionMediationBannerView *)bannerAdView dislikeWithReason:(NSArray<VlionDislikeWords *> *_Nullable)filterwords {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressBannerAdViewDidCloseOtherController:(VlionMediationBannerView *)bannerAdView interactionType:(VlionInteractionType)interactionType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when the Ad view container is forced to be removed.
 @param bannerAdView : Express Banner Ad view container
 */
- (void)nativeExpressBannerAdViewDidRemoved:(VlionMediationBannerView *)bannerAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// 广告展示回调
- (void)nativeExpressBannerAdViewDidBecomeVisible:(VlionMediationBannerView *)bannerAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}


@end
