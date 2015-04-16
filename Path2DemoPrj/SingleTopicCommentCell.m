//
//  SingleTopicCommentCell.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicCommentCell.h"
#import "Attachment.h"
#import "BBSAPI.h"
#import "AppDelegate.h"

@implementation SingleTopicCommentCell
@synthesize ID;
@synthesize time;
@synthesize content;
@synthesize author;
@synthesize authorFaceURL;
@synthesize quoter;
@synthesize quote;
@synthesize read;
@synthesize num;
@synthesize attachments;
@synthesize attachmentsViewArray;

@synthesize mDelegate;
@synthesize indexRow;

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
    if (action == @selector(copycontentTextView:) || action == @selector(copyAuthorLabel:)) {
        return YES;
    }
    return NO;
}

//针对于copy的实现
-(void)copycontentTextView:(id)sender{
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
        UIMenuItem *copyAuthor = [[UIMenuItem alloc] initWithTitle:@"复制作者" action:@selector(copyAuthorLabel:)];
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制评论" action:@selector(copycontentTextView:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects: copyAuthor, copy, nil]];
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


#pragma - SingleTopicCommentCellDelegate
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
    
    if (num == 1) {
        [loushu setText:[NSString stringWithFormat:@"沙发    %@", [BBSAPI dateToString:time]]];
    }
    else if(num == 2) {
        [loushu setText:[NSString stringWithFormat:@"板凳    %@", [BBSAPI dateToString:time]]];
    }
    else {
        [loushu setText:[NSString stringWithFormat:@"%i楼    %@", num, [BBSAPI dateToString:time]]];
    }
    
    [authorLabel setText:[NSString stringWithFormat:@"%@", author]];
    
    float tqheught = [TQRichTextView getHeightWithString:content FrameWidth:self.frame.size.width - 30];
    CGSize size1 = CGSizeMake(self.frame.size.width - 30, tqheught);
    
    [contentTextView setFrame:CGRectMake(contentTextView.frame.origin.x, contentTextView.frame.origin.y, self.frame.size.width - 30, size1.height)];
    
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:17.0];
    [contentTextView setText:content];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
    if (ShowAttachments) {
        NSArray * picArray = [self getPicList];
        for (int i = 0; i < [picArray count]; i++) {
            Attachment * att = [picArray objectAtIndex:i];
            ImageAttachmentView * imageAttachmentView = [[ImageAttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 320)/2, i*400 + contentTextView.frame.origin.y + size1.height + 10, 320, 400)];
            [imageAttachmentView setAttachmentURL:[NSURL URLWithString:att.attUrl] NameText:att.attFileName];
            imageAttachmentView.indexNum = i;
            imageAttachmentView.mDelegate = self;
            [self addSubview:imageAttachmentView];
            [self.attachmentsViewArray addObject:imageAttachmentView];
        }
        
        NSArray * docArray = [self getDocList];
        for (int i = 0; i < [docArray count]; i++) {
            Attachment * att = [docArray objectAtIndex:i];
            AttachmentView * attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, i*60 + [picArray count]*400 + contentTextView.frame.origin.y + size1.height + 10, 290, 50)];
            [attachmentView setAttachment:att.attFileName NameText:att.attFileName];
            attachmentView.isPhoto = NO;
            attachmentView.indexNum = i;
            attachmentView.mDelegate = self;
            [self addSubview:attachmentView];
            [self.attachmentsViewArray addObject:attachmentView];
        }
    }
    else {
        NSArray * picArray = [self getPicList];
        for (int i = 0; i < [picArray count]; i++) {
            Attachment * att = [picArray objectAtIndex:i];
            AttachmentView * attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, i*60 + contentTextView.frame.origin.y + size1.height + 10, 290, 50)];
            [attachmentView setAttachment:att.attFileName NameText:att.attFileName];
            attachmentView.isPhoto = YES;
            attachmentView.indexNum = i;
            attachmentView.mDelegate = self;
            [self addSubview:attachmentView];
            [self.attachmentsViewArray addObject:attachmentView];
        }
        
        NSArray * docArray = [self getDocList];
        for (int i = 0; i < [docArray count]; i++) {
            Attachment * att = [docArray objectAtIndex:i];
            AttachmentView * attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, i*60 + [picArray count]*60 + contentTextView.frame.origin.y + size1.height + 10, 290, 50)];
            [attachmentView setAttachment:att.attFileName NameText:att.attFileName];
            attachmentView.isPhoto = NO;
            attachmentView.indexNum = i;
            attachmentView.mDelegate = self;
            [self addSubview:attachmentView];
            [self.attachmentsViewArray addObject:attachmentView];
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
