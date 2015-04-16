//
//  AttachmentView.h
//  虎踞龙蟠
//
//  Created by Boyce on 8/16/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttachmentViewDelegate <NSObject>

-(void)attachmentViewTaped:(BOOL)isPhoto IndexNum:(int)indexNum;

@end

@interface AttachmentView : UIView
{
    UIView * typeView;
    UILabel * typeLabel;
    UILabel * nameLabel;
}
@property(nonatomic, assign)BOOL isPhoto;
@property(nonatomic, assign)int indexNum;
@property(nonatomic, assign)id mDelegate;

-(void)setAttachment:(NSString *)typeText NameText:(NSString *)nameText;

@end
