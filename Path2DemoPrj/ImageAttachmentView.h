//
//  ImageAttachmentView.h
//  虎踞龙蟠
//
//  Created by Boyce on 8/16/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@protocol ImageAttachmentViewDelegate <NSObject>

-(void)imageAttachmentViewTaped:(int)indexNum;

@end


@interface ImageAttachmentView : UIView
{
    UIImageView * imageView;
    UILabel * nameLabel;
}
@property(nonatomic, assign)int indexNum;
@property(nonatomic, assign)id mDelegate;
-(void)setAttachmentURL:(NSURL *)imageURL NameText:(NSString *)nameText;

@end
