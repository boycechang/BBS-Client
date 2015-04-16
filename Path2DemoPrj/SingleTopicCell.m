//
//  SingleTopicCell.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicCell.h"
#import "Attachment.h"
#import "BBSAPI.h"
#import "AppDelegate.h"

@implementation SingleTopicCell
@synthesize ID;
@synthesize read;
@synthesize time;
@synthesize title;
@synthesize author;
@synthesize authorFaceURL;
@synthesize content;
@synthesize attachments;
@synthesize indexRow;
@synthesize mDelegate;
@synthesize attachmentsViewArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSArray *)getPicList
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attFileName] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

-(NSArray *)getDocList
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attFileName] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            //[picArray addObject:[attachments objectAtIndex:i]];
        }
        else
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

#pragma -Longpress
- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyTitleLabel:) || action == @selector(copyContentLabel:) || action == @selector(copyAuthorLabel:)) {
        return YES;
    }
    return NO;
}

//针对于copy的实现
-(void)copyTitleLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = title;
}
-(void)copyContentLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = content;
}
-(void)copyAuthorLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = author;
}

//添加touch事件
-(void)attachLongPressHandler{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyTitle = [[UIMenuItem alloc] initWithTitle:@"复制标题" action:@selector(copyTitleLabel:)];
        UIMenuItem *copyContent = [[UIMenuItem alloc] initWithTitle:@"复制正文" action:@selector(copyContentLabel:)];
        UIMenuItem *copyAuthor = [[UIMenuItem alloc] initWithTitle:@"复制作者" action:@selector(copyAuthorLabel:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copyAuthor, copyTitle, copyContent, nil]];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}


-(IBAction)reply:(id)sender
{
    [self replyButtonTaped];
}
-(IBAction)edit:(id)sender
{
    [self editButtonTaped];
}

#pragma - ImageAttachmentViewDelegate
-(void)imageAttachmentViewTaped:(int)indexNum
{
    [mDelegate imageAttachmentViewInCellTaped:indexRow Index:indexNum];
}
#pragma - AttachmentViewDelegate
-(void)attachmentViewTaped:(BOOL)isPhoto IndexNum:(int)indexNum
{
    [mDelegate attachmentViewInCellTaped:isPhoto IndexRow:indexRow IndexNum:indexNum];
}

#pragma - SingleTopicCellDelegate
-(void)userHeadTaped
{
    [mDelegate userHeadTaped:indexRow];
}
-(void)replyButtonTaped
{
    [mDelegate replyButtonTaped:indexRow];
}
-(void)editButtonTaped
{
    [mDelegate editButtonTaped:indexRow];
}


#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
    
    if (attachmentsViewArray != nil) {
        UIView * view;
        for (view in attachmentsViewArray) {
            [view removeFromSuperview];
        }
        self.attachmentsViewArray = [[NSMutableArray alloc] init];
    }
    else {
        self.attachmentsViewArray = [[NSMutableArray alloc] init];
    }
    
    [articleTitleLabel setText:title];
    [authorLabel setText:author];
    [loushu setText:[NSString stringWithFormat:@"楼主    %@", [BBSAPI dateToString:time]]];

    float tqheught = [TQRichTextView getHeightWithString:content FrameWidth:self.frame.size.width - 30];
    CGSize size2 = CGSizeMake(self.frame.size.width - 30, tqheught);
    
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, self.frame.size.width - 30, size2.height)];
    contentLabel.font = [UIFont systemFontOfSize:17.0];
    contentLabel.backgroundColor = [UIColor clearColor];
    [contentLabel setText:content];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
    if (ShowAttachments) {
        NSArray * picArray = [self getPicList];
        for (int i = 0; i < [picArray count]; i++) {
            Attachment * att = [picArray objectAtIndex:i];
            ImageAttachmentView * imageAttachmentView = [[ImageAttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 320)/2, i*400 + contentLabel.frame.origin.y + size2.height + 10, 320, 400)];
            [imageAttachmentView setAttachmentURL:[NSURL URLWithString:att.attUrl] NameText:att.attFileName];
            imageAttachmentView.indexNum = i;
            imageAttachmentView.mDelegate = self;
            [self addSubview:imageAttachmentView];
            [attachmentsViewArray addObject:imageAttachmentView];
        }
        
        NSArray * docArray = [self getDocList];
        for (int i = 0; i < [docArray count]; i++) {
            Attachment * att = [docArray objectAtIndex:i];
            AttachmentView * attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, i*60 + [picArray count]*400 + contentLabel.frame.origin.y + size2.height + 10, 290, 50)];
            [attachmentView setAttachment:att.attFileName NameText:att.attFileName];
            attachmentView.isPhoto = NO;
            attachmentView.indexNum = i;
            attachmentView.mDelegate = self;
            [self addSubview:attachmentView];
            [attachmentsViewArray addObject:attachmentView];
        }
    }
    else
    {
        NSArray * picArray = [self getPicList];
        for (int i = 0; i < [picArray count]; i++) {
            Attachment * att = [picArray objectAtIndex:i];
            AttachmentView * attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, i*60 + contentLabel.frame.origin.y + size2.height + 10, 290, 50)];
            [attachmentView setAttachment:att.attFileName NameText:att.attFileName];
            attachmentView.isPhoto = YES;
            attachmentView.indexNum = i;
            attachmentView.mDelegate = self;
            [self addSubview:attachmentView];
            [attachmentsViewArray addObject:attachmentView];
        }
        
        NSArray * docArray = [self getDocList];
        for (int i = 0; i < [docArray count]; i++) {
            Attachment * att = [docArray objectAtIndex:i];
            AttachmentView * attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, i*60 + [picArray count]*60 + contentLabel.frame.origin.y + size2.height + 10, 290, 50)];
            [attachmentView setAttachment:att.attFileName NameText:att.attFileName];
            attachmentView.isPhoto = NO;
            attachmentView.indexNum = i;
            attachmentView.mDelegate = self;
            [self addSubview:attachmentView];
            [attachmentsViewArray addObject:attachmentView];
        }
    }
    
    authorFaceImageView.layer.cornerRadius = 12;
    authorFaceImageView.clipsToBounds = YES;
    BOOL isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
    if (isLoadAvatar) {
        [authorLabel setFrame:CGRectMake(47, authorLabel.frame.origin.y, authorLabel.frame.size.width, authorLabel.frame.size.height)];
        [loushu setFrame:CGRectMake(47, loushu.frame.origin.y, loushu.frame.size.width, loushu.frame.size.height)];
        
        [authorFaceImageView setHidden:NO];
        [authorFaceImageView setImageWithURL:authorFaceURL];
    }
    else {
        [authorLabel setFrame:CGRectMake(15, authorLabel.frame.origin.y, authorLabel.frame.size.width, authorLabel.frame.size.height)];
        [loushu setFrame:CGRectMake(15, loushu.frame.origin.y, loushu.frame.size.width, loushu.frame.size.height)];
        
        [authorFaceImageView setHidden:YES];
    }
    
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadTaped)];
    [authorFaceImageView addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer* recognizer2;
    recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadTaped)];
    [authorLabel addGestureRecognizer:recognizer2];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myBBS != nil && [appDelegate.myBBS.mySelf.username isEqualToString:author]) {
        [editButton setHidden:NO];
    }
    else {
        [editButton setHidden:YES];
    }
    
    [self attachLongPressHandler];
}

@end
