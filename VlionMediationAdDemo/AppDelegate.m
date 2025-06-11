//
//  AppDelegate.m
//  VlionMediationAdDemo
//
//  Created by jdy_office on 2025/6/11.
//

#import "AppDelegate.h"
#import "VLIONAdViewController.h"
#import "VlionPrivacyProvider.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import <VlionMediationAd/VlionMediationConfiguration.h>
#import <VlionMediationAd/VlionMediationAdSDKManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VLIONAdViewController *vc = [[VLIONAdViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
    NSLog(@"name: %@", [UIDevice currentDevice].name);
    [self setUpVlionMediationSDK];
    
    return YES;
}

- (void)setUpVlionMediationSDK {
    VlionMediationConfiguration *configuration = [VlionMediationConfiguration configuration];
    configuration.appID = @"5576816";
    configuration.privacyProvider = [[VlionPrivacyProvider alloc] init];
//    configuration.appLogoImage = [UIImage imageNamed:@"AppIcon"];
    configuration.debugLog = @(1);
    
    // 如果使用聚合维度功能，则务必将以下字段设置为YES
    // 并检查工程有引用CSJMediation.framework，这样SDK初始化时将启动聚合相关必要组件
    configuration.useMediation = YES;
    
    [VlionMediationAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"vlion mediation start success");
        } else {
            NSLog(@"vlion mediation start failure. \nerror: %@", error);
        }
    }];
    
//    [self playerCoustomAudio];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestIDFATracking];
    });
}

- (void)requestIDFATracking {
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"%@",idfa);
            } else {
                NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
            }
        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"%@",idfa);
        } else {
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
}

@end
