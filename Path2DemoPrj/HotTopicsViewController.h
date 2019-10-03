//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "TopTenViewController.h"

@interface HotTopicsViewController : UIViewController
{
    QCSlideSwitchView *_slideSwitchView;
    UINavigationController *_vc1;
    UINavigationController *_vc2;
    UINavigationController *_vc3;
}

@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) UINavigationController *vc1;
@property (nonatomic, strong) UINavigationController *vc2;
@property (nonatomic, strong) UINavigationController *vc3;

@end
