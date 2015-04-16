//
//  AttachmentsViewController.h
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-1-29.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attachment.h"
#import "HomeViewController.h"
#import "SingleImageWithScrollViewController.h"
#import "MWPhotoBrowser.h"

@interface AttachmentsViewController : UIViewController<UIDocumentInteractionControllerDelegate, UIAlertViewDelegate, MWPhotoBrowserDelegate>
{
    NSArray * attList;
    NSArray * picList;
    NSArray * otherList;
    
    IBOutlet UITableView * attTable;
    NSString * openString;
    
    NSArray *_photos;
}
@property(nonatomic, strong)NSArray *attList;
@property(nonatomic, strong)NSArray * picList;
@property(nonatomic, strong)NSArray * otherList;
@property(nonatomic, strong)NSString * openString;
@property (nonatomic, strong)NSArray *photos;
@property (nonatomic, strong)UIViewController * saveController;

-(IBAction)back:(id)sender;
@end
