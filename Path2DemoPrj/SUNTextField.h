//
//  SUNTextField.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-8-21.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUNTextField : UITextField
{
    UILabel *_customerLeftView;
    UIColor *_placeHolderColor;
    CGFloat _cornerRadius;
    UIColor *_backgroundColor;
}

@property (nonatomic, strong) IBOutlet UILabel *customerLeftView;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;

@end
