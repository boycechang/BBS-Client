//
//  DemoPhoto.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "DemoPhoto.h"
#import "DemoPhotoLoadingView.h"
#import "UIImageView+AFNetworking.h"

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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [[UIImageView new] setImageWithURLRequest:request placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          _underlyingImage = image;
                                          [self notifyImageDidFinishLoad];
                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          [self notifyImageDidFailLoadWithError:error];
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
