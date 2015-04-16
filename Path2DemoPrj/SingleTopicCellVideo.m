//
//  SingleTopicCell.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicCellVideo.h"
#import "Attachment.h"
#import "BBSAPI.h"
#import "AppDelegate.h"

@implementation SingleTopicCellVideo
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
@synthesize news;
@synthesize playerController;

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

-(void)moviePlayerPreloadDidFinish:(NSNotification*)notification{
    //添加你的处理代码
}

-(void)MPMoviePlayerScallingModeDidChanged:(NSNotification*)notification
{
    
}

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    //[self.view removeFromSuperView];
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
    
    [articleTitleLabel setText:[NSString stringWithFormat:@"%@", (NSString *)[news objectForKey:@"title"]]];
    [contentLabel setText:[NSString stringWithFormat:@"%@", (NSString *)[news objectForKey:@"content"]]];
    [loushu setText:[NSString stringWithFormat:@"%@", [BBSAPI dateToString:(NSDate *)[news objectForKey:@"updatedAt"]]]];
    NSNumber *number = [news objectForKey:@"like"];
    [likeLabel setText:[NSString stringWithFormat:@"%i", [number intValue]]];
    
    /*
     AVUser *user = [news objectForKey:@"user"];
     [authorLabel setText:[NSString stringWithFormat:@"%@", (NSString *)[user objectForKey:@"realUserName"]]];
     AVFile *faceImageFile = [user objectForKey:@"headImage"];
     NSData *faceImageData = [faceImageFile getData];
     [authorFaceImageView setImage:[UIImage imageWithData:faceImageData]];
     */
    
    float tqheught = [TQRichTextView getHeightWithString:[NSString stringWithFormat:@"%@", (NSString *)[news objectForKey:@"content"]] FrameWidth:self.frame.size.width - 30];
    CGSize size2 = CGSizeMake(self.frame.size.width - 30, tqheught);
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, self.frame.size.width - 30, size2.height)];
    contentLabel.font = [UIFont systemFontOfSize:17.0];
    contentLabel.backgroundColor = [UIColor clearColor];
    
    authorFaceImageView.layer.cornerRadius = 12;
    authorFaceImageView.clipsToBounds = YES;
    
    
    AVFile *videoFile = [self.news objectForKey:@"video"];
    NSData *videoData = [videoFile getData];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/video.mov"];
    [videoData writeToFile:filePath atomically:YES];
    
    self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    [self.playerController setShouldAutoplay:YES];
    [self.playerController.view setFrame:CGRectMake(0, 75, 320, 428)];
    [self addSubview:self.playerController.view];
    [self.playerController play];
}

@end
