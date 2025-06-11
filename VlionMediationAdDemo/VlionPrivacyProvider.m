//
//  VlionPrivacyProvider.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/4.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VlionPrivacyProvider.h"

@implementation VlionPrivacyProvider

- (BOOL)canUseLocation {
    return YES;
}

- (CLLocationDegrees)latitude {
    return 40;
}

- (CLLocationDegrees)longitude {
    return 120;
}

- (BOOL)canUseWiFiBSSID {
    return YES;
}

- (NSDictionary *)privacyConfig {
    NSMutableDictionary *privacy = [NSMutableDictionary dictionary];
    // motion_info表示是否允许传感器采集数据，默认不传时允许采集
    // "0": 不允许
    // "1": 允许
    // 其他值或不实现该协议方法认为允许采集
    [privacy setObject:@"1" forKey:@"motion_info"];
    return [privacy copy];
}

@end
