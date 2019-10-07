//
//  LoginInfoView.h
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginInfoView : UIView

@property (nonatomic, copy) void (^infoTapped)(void);
@property (nonatomic, copy) void (^loginTapped)(NSString *username, NSString *password);
@property (nonatomic, copy) void (^tokenChanged)(NSString *username, NSString *password);

@end

NS_ASSUME_NONNULL_END
