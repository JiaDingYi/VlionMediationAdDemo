//
//  VLIONNativeExpressViewController.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/6.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VLIONNativeExpressViewController.h"
#import <VlionMediationAd/VlionMediationNativeAd.h>

@interface VLIONNativeExpressViewController () <VlionNativeAdsManagerDelegate, VlionMNativeAdDelegate, VlionNativeExpressAdViewDelegate>
@property (nonatomic, strong) VlionMediationNativeAd *nativeExpressAd;
@property (nonatomic, strong) NSArray<VlionNativeAd *> *nativeAdDataArray;
@property (nonatomic, strong) VlionNativeAd *nativeAd;
@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;
@property (nonatomic, strong) UIButton *btnBidSuccess;
@property (nonatomic, strong) UIButton *btnBidFail;
@property (nonatomic, assign) BOOL  isLoded;
@property (nonatomic) CGSize adSize;

@end

@implementation VLIONNativeExpressViewController

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
    [self appendLog:@"开始加载模板广告"];
    if (self.nativeExpressAd) {
        [self.nativeExpressAd destory];
        self.nativeExpressAd.delegate = nil;
        self.nativeExpressAd = nil;
        self.isLoded = NO;
    }
    if (self.nativeAd.canvasView.superview) {
        [self.nativeAd.canvasView removeFromSuperview];
    }
    VlionAdSlot *slot1 = [[VlionAdSlot alloc] init];
    CGSize imageSize = CGSizeMake(1080, 1920);
    slot1.imgSize = imageSize;
    slot1.ID = @"103010783";
    // 如果是模板广告，返回高度将不一定是300，而是按照414和对应代码位在平台的配置计算出的高度
    slot1.adSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
    // [可选]配置：静音
    slot1.mutedIfCan = YES;
    
    self.nativeExpressAd = [[VlionMediationNativeAd alloc] initWithSlot:slot1];
    // 配置：跳转控制器
    self.nativeExpressAd.rootViewController = self;
    // 配置：回调代理对象
    self.nativeExpressAd.delegate = self;
    self.nativeExpressAd.nativeExpressAdViewDelegate = self;
    // 开始加载广告
    [self.nativeExpressAd loadAdDataWithCount:3];
}

- (void)showAd {
    if (self.nativeAd.isExpressAd) {
        [self appendLog:@"isExpressAd"];
        [self.view addSubview:self.nativeAd.canvasView];
        CGFloat scale = 1080.0 / 1920.0;
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat height = width / scale;
        NSLog(@"wzy - test %f, %f, %f", width, height, scale);
        self.nativeAd.canvasView.frame = CGRectMake(10, 300, width, height);
    }
}

- (void)sendWinNotification {
    [self.nativeExpressAd win:@1];
}

- (void)sendLossNotification {
    [self.nativeExpressAd loss:@1 lossReason:@"" winBidder:@""];
}

#pragma mark - VlionNativeAdsManagerDelegate

- (void)nativeAdsManagerSuccessToLoad:(VlionMediationNativeAd *)adsManager nativeAds:(NSArray<VlionNativeAd *> *_Nullable)nativeAdDataArray {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
    
    self.nativeAdDataArray = nativeAdDataArray;
    for (VlionNativeAd *model in nativeAdDataArray) {
        model.rootViewController = self;
        model.delegate = self;
        
        if (model.isExpressAd) {
            [model mediationRender];
            self.nativeAd = model;
            [self appendLog:@"is express ad"];
        } else {
            [self appendLog:@"not express ad"];
        }
    }
}

- (void)nativeAdsManager:(VlionMediationNativeAd *)adsManager didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

#pragma mark -

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

#pragma mark - VlionNativeAdDelegate
/**
 This method is called when native ad material loaded successfully. This method will be deprecated. Use nativeAdDidLoad:view: instead
// Mediation:@Note :  Mediation dimension does not support this interface.
 */
- (void)nativeAdDidLoad:(VlionNativeAd *)nativeAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}


/**
 This method is called when native ad material loaded successfully.
// Mediation:@Note :  Mediation dimension does not support this interface.
 */
- (void)nativeAdDidLoad:(VlionNativeAd *)nativeAd view:(UIView *_Nullable)view {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when native ad materia failed to load.
 @param error : the reason of error
// Mediation:@Note :  Mediation dimension does not support this interface.
 */
- (void)nativeAd:(VlionNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when native ad slot has been shown.
 */
- (void)nativeAdDidBecomeVisible:(VlionNativeAd *)nativeAd {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeAdDidCloseOtherController:(VlionNativeAd *)nativeAd interactionType:(VlionInteractionType)interactionType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when native ad is clicked.
 */
- (void)nativeAdDidClick:(VlionNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when the user clicked dislike reasons.
 Only used for dislikeButton in BUNativeAdRelatedView.h
 @param filterWords : reasons for dislike
 */
- (void)nativeAd:(VlionNativeAd *_Nullable)nativeAd dislikeWithReason:(NSArray<VlionDislikeWords *> *_Nullable)filterWords {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
    [nativeAd.canvasView removeFromSuperview];
}

/**
 This method is called when the Ad view container is forced to be removed.
 @param nativeAd : Ad material
 @param adContainerView : Ad view container
 */
- (void)nativeAd:(VlionNativeAd *_Nullable)nativeAd adContainerViewDidRemoved:(UIView *)adContainerView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/// This method will call when special ad event raised;
/// @param nativeAd ad
/// @param code eventCode
/// @param info event Info
- (void)nativeAd:(VlionNativeAd *_Nullable)nativeAd onEventCode:(VlionNativeAdEventCode)code info:(NSDictionary *)info {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

#pragma mark - VlionNativeExpressAdViewDelegate

/**
 * Sent when views successfully load ad
 */
- (void)nativeExpressAdSuccessToLoad:(VlionMediationNativeAd *)nativeExpressAdManager views:(NSArray<__kindof VlionNativeExpressAdView *> *)views {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 * Sent when views fail to load ad
 */
- (void)nativeExpressAdFailToLoad:(VlionMediationNativeAd *)nativeExpressAdManager error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 * This method is called when rendering a nativeExpressAdView successed, and nativeExpressAdView.size.height has been updated
 */
- (void)nativeExpressAdViewRenderSuccess:(VlionNativeExpressAdView *)nativeExpressAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 * This method is called when a nativeExpressAdView failed to render
 */
- (void)nativeExpressAdViewRenderFail:(VlionNativeExpressAdView *)nativeExpressAdView error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 * Sent when an ad view is about to present modal content
 */
- (void)nativeExpressAdViewWillShow:(VlionNativeExpressAdView *)nativeExpressAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 * Sent when an ad view is clicked
 */
- (void)nativeExpressAdViewDidClick:(VlionNativeExpressAdView *)nativeExpressAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
Sent when a playerw playback status changed.
@param playerState : player state after changed
*/
- (void)nativeExpressAdView:(VlionNativeExpressAdView *)nativeExpressAdView stateDidChanged:(VlionPlayerPlayState)playerState {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 * Sent when a player finished
 * @param error : error of player
 */
- (void)nativeExpressAdViewPlayerDidPlayFinish:(VlionNativeExpressAdView *)nativeExpressAdView error:(NSError *_Nullable)error {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 * Sent when a user clicked dislike reasons.
 * @param filterWords : the array of reasons why the user dislikes the ad
 */
- (void)nativeExpressAdView:(VlionNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<VlionDislikeWords *> *)filterWords {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
    [nativeExpressAdView removeFromSuperview];
}

/**
 * Sent after an ad view is clicked, a ad landscape view will present modal content
 */
- (void)nativeExpressAdViewWillPresentScreen:(VlionNativeExpressAdView *)nativeExpressAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressAdViewDidCloseOtherController:(VlionNativeExpressAdView *)nativeExpressAdView interactionType:(VlionInteractionType)interactionType {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}


/**
 This method is called when the Ad view container is forced to be removed.
 @param nativeExpressAdView : Ad view container
 */
- (void)nativeExpressAdViewDidRemoved:(VlionNativeExpressAdView *)nativeExpressAdView {
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [self appendLog:function];
}

@end
