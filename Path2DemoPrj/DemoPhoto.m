//
//  DemoPhoto.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "DemoPhoto.h"
#import "DemoPhotoLoadingView.h"
#import <UIImageView+WebCache.h>

@interface DemoPhoto ()
{
    DemoPhotoLoadingView *_photoLoadingView;
}
@property (nonatomic, strong) DemoPhotoLoadingView *photoLoadingView;

@end

@implementation DemoPhoto
@synthesize photoLoadingView = _photoLoadingView;
- (void)loadImageFromFileAsync:(NSString *)path
{
    [super loadImageFromFileAsync:path];
}

- (void)loadImageFromURLAsync:(NSURL *)url
{
    [self notifyImageDidStartLoad];
    [[UIImageView new] sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            _underlyingImage = image;
            [self notifyImageDidFinishLoad];
        } else {
            [self notifyImageDidFailLoadWithError:error];
        }
    }];
}

- (void)unloadImage {
    [super unloadImage];
}

- (UIView *)photoLoadingView
{
    if (!_photoLoadingView)
    {
        _photoLoadingView = [[DemoPhotoLoadingView alloc] initWithPhoto:self];
    }
    
    return _photoLoadingView;
}
@end
