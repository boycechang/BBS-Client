//
//  ImageHistoryViewController.m
//  佳邮
//
//  Created by Boyce on 6/2/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import "ImageHistoryViewController.h"
#import "SDImageCache.h"
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"
#import "WBUtil.h"

@interface ImageHistoryViewController ()

@end

@implementation ImageHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.title = @"图片缓存";
    
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    CGRect viewRect = {{20, 104},{rect.size.width - 100, rect.size.height - 200}};
    slideImageView = [[SlideImageView alloc]initWithFrame:viewRect ZMarginValue:5 XMarginValue:10 AngleValue:0.3 Alpha:1000];
    slideImageView.borderColor = [UIColor whiteColor];
    slideImageView.delegate = self;
    [self.view addSubview:slideImageView];
    
    indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, rect.size.height - 40, 300, 40)];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont systemFontOfSize:20.f];
    [self.view addSubview:indexLabel];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"载入中...";
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        imagesArray = [[SDImageCache sharedImageCache] getAllDiskImagesPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES afterDelay:0.5];
            for(int i = 0; i < [imagesArray count]; i++)
            {
                UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[imagesArray objectAtIndex:i]]];
                [slideImageView addImage:image];
            }
            [slideImageView setImageShadowsWtihDirectionX:2 Y:2 Alpha:0.7];
            [slideImageView reLoadUIview];
            indexLabel.text = [NSString stringWithFormat:@"1/%d", [imagesArray count]];
        });
    });
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backBarItem;
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SlideImageViewDidClickWithIndex:(int)index
{
    /*
    NSMutableArray *photoDataSource = [[NSMutableArray alloc] init];
    for(int i = 0; i < [imagesArray count]; i++)
    {
        DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:[imagesArray objectAtIndex:i]];
        [photoDataSource addObject:photo];
    }
    
    CXPhotoBrowser * browser = [[CXPhotoBrowser alloc] initWithPhotoArray:photoDataSource];
    [browser setInitialPageIndex:index];
    [self presentViewController:browser animated:YES completion:nil];
     */
}

- (void)SlideImageViewDidEndScorllWithIndex:(int)index
{
    NSString* indexStr = [[NSString alloc] initWithFormat:@"%d/%d", index, [imagesArray count]];
    indexLabel.text = indexStr;
}

@end
