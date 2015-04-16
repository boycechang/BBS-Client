//
//  IFTTTJazzHandsViewController.m
//  JazzHandsDemo
//
//  Created by Devin Foley on 9/27/13.
//  Copyright (c) 2013 IFTTT Inc. All rights reserved.
//

#import "IntroViewViewController.h"
#define NAVBARCOLORBLUE [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1]

#define NUMBER_OF_PAGES 4

#define timeForPage(page) (self.view.frame.size.width * (page - 1))
#define xForPage(page) timeForPage(page)

@interface IntroViewViewController ()

@property (strong, nonatomic) UIImageView *wordmark;
@property (strong, nonatomic) UIImageView *unicorn;
@end

@implementation IntroViewViewController
{

}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.scrollView.contentSize = CGSizeMake(
            NUMBER_OF_PAGES * self.view.frame.size.width,
            self.view.frame.size.height
        );
        
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.backgroundColor = NAVBARCOLORBLUE;
        
        [self placeViews];
        [self configureAnimation];
    }
    
    return self;
}

- (void)placeViews
{
    // put a unicorn in the middle of page two, hidden

    self.unicorn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intromap"]];
    self.unicorn.center = self.view.center;
    self.unicorn.frame = CGRectOffset(
        self.unicorn.frame,
        self.view.frame.size.width,
        -100
    );
    self.unicorn.alpha = 0.0f;
    [self.scrollView addSubview:self.unicorn];

    // put a logo on top of it
    self.wordmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intromap"]];
    self.wordmark.center = self.view.center;
    self.wordmark.frame = CGRectOffset(
        self.wordmark.frame,
        self.view.frame.size.width,
        -100
    );
    [self.scrollView addSubview:self.wordmark];
    
    UITextView *firstPageText = [[UITextView alloc] init];
    firstPageText.backgroundColor = [UIColor clearColor];
    firstPageText.textColor = [UIColor whiteColor];
    firstPageText.userInteractionEnabled = NO;
    
    firstPageText.font = [UIFont systemFontOfSize:20];
    firstPageText.text = @"Only the Paranoid Survive\n\n\t\t\t\t- Andy Grove";
    [firstPageText sizeToFit];
    firstPageText.center = self.view.center;

    [self.scrollView addSubview:firstPageText];
    
    
    UITextView *secondPageText = [[UITextView alloc] init];
    secondPageText.backgroundColor = [UIColor clearColor];
    secondPageText.textColor = [UIColor whiteColor];
    secondPageText.userInteractionEnabled = NO;
    secondPageText.textAlignment = NSTextAlignmentCenter;
    secondPageText.font = [UIFont systemFontOfSize:20];
    secondPageText.text = @"全新模块\n记录北邮人们的身边事儿";
    [secondPageText sizeToFit];
    secondPageText.center = self.view.center;
    secondPageText.frame = CGRectOffset(secondPageText.frame, xForPage(2), 100);
    
    [self.scrollView addSubview:secondPageText];
    
    UITextView *thirdPageText = [[UITextView alloc] init];
    thirdPageText.backgroundColor = [UIColor clearColor];
    thirdPageText.textColor = [UIColor whiteColor];
    thirdPageText.userInteractionEnabled = NO;
    thirdPageText.textAlignment = NSTextAlignmentCenter;
    thirdPageText.font = [UIFont systemFontOfSize:20];
    thirdPageText.text = @"\n发布摄影作品\n发布社团活动公告\n发布校园地点的介绍\n... ...\n\n只能看身边两公里的内容\n让你专注于此时此地 ";
    [thirdPageText sizeToFit];
    thirdPageText.center = self.view.center;
    thirdPageText.frame = CGRectOffset(thirdPageText.frame, xForPage(3), -100);
    [self.scrollView addSubview:thirdPageText];
    
    UITextView *fourthPageText = [[UITextView alloc] init];
    fourthPageText.backgroundColor = [UIColor clearColor];
    fourthPageText.textColor = [UIColor whiteColor];
    fourthPageText.userInteractionEnabled = YES;
    fourthPageText.selectable = NO;
    fourthPageText.font = [UIFont systemFontOfSize:20];
    fourthPageText.textAlignment = NSTextAlignmentCenter;
    fourthPageText.text = @"更多精彩等你发现\n\n 点击进入";
    [fourthPageText sizeToFit];
    fourthPageText.center = self.view.center;
    fourthPageText.frame = CGRectOffset(fourthPageText.frame, xForPage(4), 0);
    [self.scrollView addSubview:fourthPageText];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [fourthPageText addGestureRecognizer:tap];
    
    /*
    UIButton *fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fourthButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    fourthButton.frame = CGRectMake(0, 0, 200, 44);
    fourthButton.backgroundColor = [UIColor clearColor];
    fourthButton.titleLabel.textColor = [UIColor whiteColor];
    fourthButton.titleLabel.font = [UIFont systemFontOfSize:20];
    fourthButton.titleLabel.text = @"点击进入";
    fourthButton.center = self.view.center;
    fourthButton.frame = CGRectOffset(fourthButton.frame, xForPage(4), 100);
    [self.scrollView addSubview:fourthButton];
     */
}

- (void)configureAnimation
{
    CGFloat dy = 240;

    IFTTTFrameAnimation *wordmarkFrameAnimation = [IFTTTFrameAnimation new];
    wordmarkFrameAnimation.view = self.wordmark;
    [self.animator addAnimation:wordmarkFrameAnimation];
    
    // move 200 pixels to the right for parallax effect
    [wordmarkFrameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:timeForPage(1)
                                                                            andFrame:CGRectOffset(self.wordmark.frame, 200, 0)]];
    
    // move to initial frame on page 2 for parallax effect
    [wordmarkFrameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:timeForPage(2)
                                                                            andFrame:self.wordmark.frame]];
    
    // move down and to the right between pages 2 and 3
    [wordmarkFrameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:timeForPage(3)
                                                                            andFrame:CGRectOffset(CGRectInset(self.unicorn.frame, 50, 50), self.view.frame.size.width, dy)]];
    
    // move back to initial position on page 4 for parallax effect
    [wordmarkFrameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:timeForPage(4)
                                                                            andFrame:CGRectOffset(self.wordmark.frame, 0, dy)]];
}

- (IBAction)buttonClicked:(id)sender
{
    if ([self.mDelegate respondsToSelector:@selector(enterButtonClicked)]) {
        [self.mDelegate enterButtonClicked];
    }
}
@end
