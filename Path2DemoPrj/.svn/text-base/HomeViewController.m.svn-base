//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

#define kTriggerOffSet 100.0f

/////////////////////////////////////
@interface HomeViewController () 
- (void)restoreViewLocation;
- (void)moveToRightSide;
- (void)animateHomeViewToSide:(CGRect)newViewRect;
@end

/////////////////////////////////////
@implementation HomeViewController
@synthesize realViewController;
@synthesize mDelegate;

/*
#pragma mark -
#pragma mark Override touch methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    touchBeganPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
}

// Scale or move select view when touch moved (Add by Ethan, 2011-11-27)
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    CGFloat xOffSet = touchPoint.x - touchBeganPoint.x;
    
    if (xOffSet >= 0 && xOffSet <= 290) {
        self.navigationController.view.frame = CGRectMake(xOffSet, 
                                                      self.navigationController.view.frame.origin.y, 
                                                      self.navigationController.view.frame.size.width, 
                                                      self.navigationController.view.frame.size.height);
    }
}

// reset indicators when touch ended (Add by Ethan, 2011-11-27)
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // animate to left side
    if (self.navigationController.view.frame.origin.x < -kTriggerOffSet) 
    {}
    else if (self.navigationController.view.frame.origin.x > kTriggerOffSet)
         {
            AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (appdelegate.isSearching) {
                [appdelegate showLeftViewTotaly];
            }
            else {
                [self moveToRightSide];
            }
         }
        else 
            [self restoreViewLocation];
}
*/


- (void)awakeFromNib {
    self.realViewController = [[TopTenViewController alloc] initWithNibName:@"TopTenViewController" bundle:nil];
    [self showViewController:@"今日十大"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL * isNotFirstLoad = [defaults boolForKey:@"isNotFirstLoad"];
    if (!isNotFirstLoad) {
        firstLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        [firstLoadImageView setImage:[UIImage imageNamed:@"techImage1.png"]];
        [self performSelector:@selector(dismissTechImage) withObject:nil afterDelay:2.5];
        [self.view addSubview:firstLoadImageView];
    }
}

-(void)dismissTechImage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isNotFirstLoad"];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [firstLoadImageView setAlpha:0];
    [UIView commitAnimations];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark Other methods

// restore view location
- (void)restoreViewLocation {
    homeViewIsOutOfStage = NO;
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
                         if (overView != nil)
                             [overView removeFromSuperview];
                     }];
}
- (void)firstrestoreViewLocation {
    homeViewIsOutOfStage = NO;
    [UIView animateWithDuration:0.7 
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
                         if (overView != nil)
                             [overView removeFromSuperview];
                     }];
}

// move view to right side
- (void)moveToRightSide {
    homeViewIsOutOfStage = YES;
    [self animateHomeViewToSide:CGRectMake(290.0f, 
                                           self.navigationController.view.frame.origin.y, 
                                           self.navigationController.view.frame.size.width, 
                                           self.navigationController.view.frame.size.height)];
}
- (void)moveToRightSideTotaly {
    homeViewIsOutOfStage = YES;
    [self animateHomeViewToSideTotaly:CGRectMake(340.0f, 
                                           self.navigationController.view.frame.origin.y, 
                                           self.navigationController.view.frame.size.width, 
                                           self.navigationController.view.frame.size.height)];
}
- (void)animateHomeViewToSideTotaly:(CGRect)newViewRect {
    UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
    if (overView != nil)
        [overView removeFromSuperview];
    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.navigationController.view.frame = newViewRect;
                     }
                     completion:^(BOOL finished){
                         UIControl *overView = [[UIControl alloc] init];
                         overView.tag = 10086;
                         overView.backgroundColor = [UIColor clearColor];
                         overView.frame = self.navigationController.view.frame;
                         [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                     }];
}
- (void)animateHomeViewToSide:(CGRect)newViewRect {
    UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
    if (overView != nil)
        [overView removeFromSuperview];
    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.navigationController.view.frame = newViewRect;
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = [[UIControl alloc] init];
                         overView.tag = 10086;
                         overView.backgroundColor = [UIColor clearColor];
                         overView.frame = self.navigationController.view.frame;
                         [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                     }];
}


// handle left bar btn
- (IBAction)leftBarBtnTapped:(id)sender {
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.isSearching) {
        [appdelegate showLeftViewTotaly];
    }
    else {
        [self moveToRightSide];
    }
}
- (void)removeOldViewController
{
    if (self.realViewController != nil) {
        [self.realViewController.view removeFromSuperview];
    }
}
- (void)showViewController:(NSString *)topTitleString
{
    [topTitle setText:topTitleString];
    //[self.realViewController.view setFrame:CGRectMake(10, 0, 320, 460)];
    [self.view insertSubview:self.realViewController.view atIndex:0];
}

#pragma -
#pragma mark TopTenViewController delegate
-(void)topTenCellSelected:(Topic *)topic
{
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithNibName:@"SingleTopicViewController" bundle:nil];
    singleTopicViewController.rootTopic = topic;
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
    ////modified by joe//////
}


-(void)dismissPostTopicView
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)changeMode:(id)sender
{
    mDelegate = realViewController;
    if ([mDelegate respondsToSelector:@selector(changeReadMode)]) {
        [mDelegate changeReadMode];
    }
}
@end
