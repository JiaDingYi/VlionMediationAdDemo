//
//  VLIONBaseViewController.h
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/5.
//  Copyright © 2025 jdy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VLIONBaseViewController : UIViewController

@property (nonatomic, strong) UITextView *logTextView;

- (void)setupLogTextView;
- (void)appendLog:(NSString *)log;
- (void)clearLog;

@end

NS_ASSUME_NONNULL_END
