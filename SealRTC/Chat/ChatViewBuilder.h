//
//  ChatViewBuilder.h
//  RongCloud
//
//  Created by LiuLinhong on 2016/11/18.
//  Copyright © 2016年 Beijing Rongcloud Network Technology Co. , Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatBubbleMenuViewDelegateImpl.h"
#import "BlinkExcelView.h"

#define kUnableButtonColor [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]


@interface ChatViewBuilder : NSObject

@property (nonatomic, strong) UILabel *infoLabel, *snifferLabel, *masterLabel;
@property (nonatomic, strong) BlinkExcelView *excelView;
@property (nonatomic, strong) UIButton *hungUpButton, *openCameraButton, *speakerOnOffButton, *microphoneOnOffButton, *switchCameraButton, *whiteboardButton,*customVideoButton,*customAudioButton;
@property (nonatomic, strong) DWBubbleMenuButton *upMenuView;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer, *rightSwipeGestureRecognizer;

- (instancetype)initWithViewController:(UIViewController *)vc;

@end
