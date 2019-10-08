//
//  BYRBBCodeToYYConverter.m
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRBBCodeToYYConverter.h"
#import <BBCodeParser.h>
#import <BBCodeString.h>
#import <YYText.h>
#import <UIImageView+WebCache.h>
#import "Models.h"
#import "AttachmentView.h"

@interface BYRBBCodeToYYConverter () <BBCodeParserDelegate, BBCodeStringDelegate>

@property (nonatomic, assign) CGFloat containerWidth;
@property (nonatomic, strong) NSArray *currentAttachments;

@property (nonatomic, strong) NSMutableSet *usedAttachments;
@property (nonatomic, strong) NSParagraphStyle *paragraphStyle;

@end

@implementation BYRBBCodeToYYConverter

+ (instancetype)sharedInstance {
    static BYRBBCodeToYYConverter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 4;
        _paragraphStyle = paragraphStyle;
        _usedAttachments = [NSMutableSet new];
    }
    return self;
}

- (NSAttributedString *)parseBBCode:(NSString *)code
                        attachemtns:(NSArray <Attachment *> *)attachments
                     containerWidth:(CGFloat)containerWidth;
{
    [self.usedAttachments removeAllObjects];
    self.currentAttachments = attachments;
    self.containerWidth = containerWidth;
    
    BBCodeString *codeString = [[BBCodeString alloc] initWithBBCode:code andLayoutProvider:self];
    
    // 补充剩余的attachment
    for (Attachment *att in self.currentAttachments) {
        if (att.thumbnail_middle.length) {
            if (![self.usedAttachments containsObject:att]) {
                // 处理图片附件，未处理过的追加到末尾
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.containerWidth, 260)];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.cornerRadius = 10;
                imageView.layer.masksToBounds = YES;
                imageView.layer.borderColor = [UIColor separatorColor].CGColor;
                imageView.layer.borderWidth = 0.5;
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:att.url]];
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
                
                YYTextHighlight *highlight = [YYTextHighlight new];
                __weak typeof (self) wself = self;
                NSArray *attachments = self.currentAttachments;
                highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                    if ([wself.actionDelegate respondsToSelector:@selector(BBCodeDidClickAttachmentImage:index:sourceView:)]) {
                        [wself.actionDelegate BBCodeDidClickAttachmentImage:attachments index:[attachments indexOfObject:att] sourceView:imageView];
                    }
                };
                [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];
                
                [codeString.attributedString appendAttributedString:attachText];
            }
        } else {
            //处理非图片附件
            [codeString.attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                     NSForegroundColorAttributeName : [UIColor labelColor],
                     NSParagraphStyleAttributeName : self.paragraphStyle,
            }]];
            
            CGFloat width = self.containerWidth > 300 ? 300 : self.containerWidth;
            CGFloat height = 80;
            AttachmentView *attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            [attachmentView updateWithAttachment:att];
            
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:attachmentView contentMode:UIViewContentModeCenter attachmentSize:attachmentView.frame.size alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            __weak typeof (self) wself = self;
            highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                if ([wself.actionDelegate respondsToSelector:@selector(BBCodeDidClickURL:)]) {
                    [wself.actionDelegate BBCodeDidClickURL:att.url];
                }
            };
            [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];            
            [codeString.attributedString appendAttributedString:attachText];
        }
    }
    
    return codeString.attributedString;
}


#pragma mark - private

- (NSMutableAttributedString *)generateImageAttachment:(NSString *)url {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.containerWidth, 260)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor separatorColor].CGColor;
    imageView.layer.borderWidth = 0.5;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
    return attachText;
}

#pragma mark - BBCodeStringDelegate

/** Returns the attributed text which will be displayed for the given BBCode element. **/
- (NSAttributedString *)getAttributedTextForElement:(BBElement *)element {
    if ([element.tag containsString:@"upload="]) {
        NSInteger index = [[element.tag substringFromIndex:7] integerValue];
        Attachment *att = [self.currentAttachments objectAtIndex:index - 1];
        if (!att.thumbnail_middle.length) {
            return nil;
        }
        
        [self.usedAttachments addObject:att];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.containerWidth, 260)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor separatorColor].CGColor;
        imageView.layer.borderWidth = 0.5;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:att.url]];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        __weak typeof (self) wself = self;
        NSArray *attachments = self.currentAttachments;
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if ([wself.actionDelegate respondsToSelector:@selector(BBCodeDidClickAttachmentImage:index:sourceView:)]) {
                [wself.actionDelegate BBCodeDidClickAttachmentImage:attachments index:[attachments indexOfObject:att] sourceView:imageView];
            }
        };
        [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];
        
        return attachText;
    } else if ([element.tag containsString:@"img="]) {
        NSString *url = [element.tag substringFromIndex:4];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.containerWidth, 260)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor separatorColor].CGColor;
        imageView.layer.borderWidth = 0.5;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        __weak typeof (self) wself = self;
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if ([wself.actionDelegate respondsToSelector:@selector(BBCodeDidClickURL:)]) {
                [wself.actionDelegate BBCodeDidClickURL:url];
            }
        };
        [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];
        
        return attachText;
    }
    
    return nil;
}

/** Returns the whitelist of the BBCode tags your code supports. **/
- (NSArray *)getSupportedTags {
    return @[@"b", @"i", @"u", @"size", @"color", @"face", @"url", @"img", @"upload"];
}

/** Returns the attributes for the part of NSAttributedString which will present the given BBCode element.  **/
- (NSDictionary *)getAttributesForElement:(BBElement *)element {
    if ([element.tag isEqualToString:@"b"]) {
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        return @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:0],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
        };
    } else if ([element.tag isEqualToString:@"i"]) {
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        return @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:0],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
        };
    } else if ([element.tag isEqualToString:@"u"]) {
        return @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                 NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
           };
    } else if ([element.tag containsString:@"url"]) {
        NSString *url = [element.tag substringFromIndex:4];
        
        YYTextBorder *highlightBorder = [YYTextBorder new];
        highlightBorder.strokeWidth = 0;
        highlightBorder.strokeColor = nil;
        highlightBorder.fillColor = [UIColor systemFillColor];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        
        __weak typeof (self) wself = self;
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if ([wself.actionDelegate respondsToSelector:@selector(BBCodeDidClickURL:)]) {
                [wself.actionDelegate BBCodeDidClickURL:url];
            }
        };
        
        return @{YYTextHighlightAttributeName : highlight,
                 NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                 NSForegroundColorAttributeName : [UIColor systemBlueColor],
                 NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                 NSParagraphStyleAttributeName : self.paragraphStyle,
        };
    } else {
        return @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
        };
    }
    
    return nil;
}

@end
