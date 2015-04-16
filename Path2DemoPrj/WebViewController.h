//
//  WebViewController.h
//  虎踞龙蟠
//
//  Created by Boyce on 8/17/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    NSString * attachmentName;
    NSURL * url;
}

- (id)initWithURL:(NSString *)AttachmentName AttachmentURL:(NSURL *)URL;
@end
