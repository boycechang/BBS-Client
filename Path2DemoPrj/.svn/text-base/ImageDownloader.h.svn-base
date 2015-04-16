//  SingleImageWithScrollViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 1/5/13.
//  Copyright (c) 2012 SEU. All rights reserved.
//

//@class RootViewController;

#import "ImageData.h"
@interface ImageDownloader : NSObject
{
    UIImageView * imageView;
    ImageData * imageData;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}
@property (nonatomic, strong)UIImageView * imageView;;
@property (nonatomic, strong)ImageData * imageData;
@property (nonatomic, strong)NSMutableData *activeDownload;
@property (nonatomic, strong)NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end
