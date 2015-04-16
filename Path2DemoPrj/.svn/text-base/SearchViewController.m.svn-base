//
//  SearchViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController
@synthesize searchString;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchBoardViewController = [[SearchBoardViewController alloc] initWithNibName:@"SearchBoardViewController" bundle:nil];
        searchTopicViewController = [[SearchTopicViewController alloc] initWithNibName:@"SearchTopicViewController" bundle:nil];
        searchUserViewController = [[SearchUserViewController alloc] initWithNibName:@"SearchUserViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 64)];
    [searchBoardViewController.view setFrame:CGRectMake(0, 44, 320, rect.size.height-64)];
    [searchTopicViewController.view setFrame:CGRectMake(0, 44, 320, rect.size.height-108)];
    [searchUserViewController.view setFrame:CGRectMake(0, 44, 320, rect.size.height-108)];
    
    [self.view addSubview:searchBoardViewController.view];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    searchBoardViewController = nil;
    
    searchTopicViewController = nil;
    
    searchUserViewController = nil;
    
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)refreshSearching
{
    searchBoardViewController.searchString = searchString;
    searchTopicViewController.searchString = searchString;
    searchUserViewController.searchString = searchString;
    [searchBoardViewController reloadData];
    [searchTopicViewController reloadData];
    [searchUserViewController reloadData];
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    switch (myUISegmentedControl.selectedSegmentIndex) {
        case 0:
            [searchTopicViewController.view removeFromSuperview];
            [searchUserViewController.view removeFromSuperview];
            [self.view addSubview:searchBoardViewController.view];
            break;
        case 1:
            [searchBoardViewController.view removeFromSuperview];
            [searchUserViewController.view removeFromSuperview];
            [self.view addSubview:searchTopicViewController.view];
            break;
        case 2:
            [searchTopicViewController.view removeFromSuperview];
            [searchBoardViewController.view removeFromSuperview];
            [self.view addSubview:searchUserViewController.view];
            break;
        default:
            break;
    }
}

@end
