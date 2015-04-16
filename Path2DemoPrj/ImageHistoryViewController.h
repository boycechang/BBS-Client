//
//  ImageHistoryViewController.h
//  佳邮
//
//  Created by Boyce on 6/2/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideImageView.h"

@interface ImageHistoryViewController : UIViewController<SlideImageViewDelegate>
{
    SlideImageView* slideImageView;
    UILabel *indexLabel;
    UILabel *clickLabel;
    NSArray *imagesArray;
}
@end
