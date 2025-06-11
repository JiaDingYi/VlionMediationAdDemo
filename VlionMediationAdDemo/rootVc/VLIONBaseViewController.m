//
//  VLIONBaseViewController.m
//  VlionMediationAd_Example
//
//  Created by jdy_office on 2025/6/5.
//  Copyright © 2025 jdy. All rights reserved.
//

#import "VLIONBaseViewController.h"

@interface VLIONBaseViewController ()

@end

@implementation VLIONBaseViewController

- (void)setupLogTextView {
    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat logViewHeight = 200;
    
    self.logTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,
                                                                    self.view.bounds.size.height - safeAreaInsets.bottom - logViewHeight - 10,
                                                                    screenWidth - 20,
                                                                    logViewHeight)];
    self.logTextView.editable = NO;
    self.logTextView.font = [UIFont systemFontOfSize:14];
    self.logTextView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.logTextView.layer.cornerRadius = 5;
    self.logTextView.layer.borderWidth = 0.5;
    self.logTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.logTextView];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    clearButton.frame = CGRectMake(CGRectGetMaxX(self.logTextView.frame) - 60,
                                  CGRectGetMinY(self.logTextView.frame) - 30,
                                  50,
                                  25);
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
}

- (void)appendLog:(NSString *)log {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *timeStamp = [self currentTimeString];
        NSString *logWithTime = [NSString stringWithFormat:@"[%@] %@\n", timeStamp, log];
        self.logTextView.text = [self.logTextView.text stringByAppendingString:logWithTime];
        [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.text.length, 0)];
    });
}

- (void)clearLog {
    self.logTextView.text = @"";
}

- (NSString *)currentTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    return [formatter stringFromDate:[NSDate date]];
}

@end
