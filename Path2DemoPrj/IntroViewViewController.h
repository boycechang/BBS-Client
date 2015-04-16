//
//  IFTTTJazzHandsViewController.h
//  JazzHandsDemo
//
//  Created by Devin Foley on 9/27/13.
//  Copyright (c) 2013 IFTTT Inc. All rights reserved.
//

#import "IFTTTJazzHands.h"

@protocol IntroViewViewControllerDelegate <NSObject>
-(void)enterButtonClicked;
@end

@interface IntroViewViewController : IFTTTAnimatedScrollViewController <UIScrollViewDelegate>

@property(nonatomic, unsafe_unretained)id mDelegate;
@end
