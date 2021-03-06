//
//  BlinkExcelView.h
//  RongCloud
//
//  Created by Vicky on 2018/2/7.
//  Copyright © 2018年 Beijing Rongcloud Network Technology Co. , Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHExcelView.h"

@interface BlinkExcelView : UIView

@property (nonatomic, copy) NSArray<NSArray *> *array;
@property (strong, nonatomic) YHExcelView *excelView;//表内容

- (instancetype)initWithFrame:(CGRect)frame;

@end
