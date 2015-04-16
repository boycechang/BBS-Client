//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TimeScroller.h"
#import "TopTenViewController.h"
#import "SingleTopicViewController.h"

@protocol HomeViewControllerDelegate <NSObject>

-(void)changeReadMode;

@end

@interface HomeViewController : UIViewController{
    IBOutlet UILabel * topTitle;
    CGPoint touchBeganPoint;
    UIViewController * realViewController;
    
    BOOL homeViewIsOutOfStage;
    id __unsafe_unretained mDelegate;
    
    UIImageView * firstLoadImageView;
}
@property(nonatomic, strong)UIViewController * realViewController;
@property(nonatomic, assign)id mDelegate;

- (IBAction)leftBarBtnTapped:(id)sender;
- (void)removeOldViewController;
- (void)showViewController:(NSString *)topTitle;
- (void)firstrestoreViewLocation;
- (void)restoreViewLocation;
- (void)moveToRightSide;
- (void)moveToRightSideTotaly;

- (IBAction)changeMode:(id)sender;
@end
