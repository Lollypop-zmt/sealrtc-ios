//
//  SettingViewController.h
//  RongCloud
//
//  Created by LiuLinhong on 16/11/11.
//  Copyright © 2016年 Beijing Rongcloud Network Technology Co. , Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingViewBuilder.h"
#import "SettingTableViewDelegateSourceImpl.h"
#import "SettingPickViewDelegateImpl.h"
#import "UINavigationController+returnBack.h"
#import "LoginManager.h"

#define Key_Min @"min"
#define Key_Max @"max"
#define Key_Default @"default"
#define Key_Step @"step"
@class LoginViewController;
@interface SettingViewController : UIViewController

@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) SettingViewBuilder *settingViewBuilder;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSUInteger sectionNumber;
@property (nonatomic, strong) NSArray *resolutionRatioArray, *frameRateArray, *codeRateArray, *codingStyleArray;
@property (nonatomic, strong) SettingTableViewDelegateSourceImpl *settingTableViewDelegateSourceImpl;
@property (nonatomic, strong) SettingPickViewDelegateImpl *settingPickViewDelegateImpl;
@property (nonatomic, strong) UIAlertController *alertController;


+ (NSUserDefaults *)shareSettingUserDefaults;
- (void)gpuSwitchAction;
- (void)tinyStreamSwitchAction;
- (void)autoTestAction;
- (void)waterMarkAction;

@end
