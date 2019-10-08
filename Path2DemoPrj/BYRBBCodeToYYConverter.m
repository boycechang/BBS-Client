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

@property (nonatomic, strong) YYTextHighlight *yyLinkHeight;

@property (nonatomic, strong) NSDictionary *normalTextAttributs;
@property (nonatomic, strong) NSDictionary *quoteTextAttributs;

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
        _usedAttachments = [NSMutableSet new];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 4;
        _paragraphStyle = paragraphStyle;
        _normalTextAttributs = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
        };
        
        NSMutableParagraphStyle *quoteParagraphStyle = [NSMutableParagraphStyle new];
        quoteParagraphStyle.lineSpacing = 2;
        _quoteTextAttributs = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],
                 NSForegroundColorAttributeName : [UIColor secondaryLabelColor],
                 NSParagraphStyleAttributeName : quoteParagraphStyle,
        };
        
        YYTextBorder *highlightBorder = [YYTextBorder new];
        highlightBorder.fillColor = [UIColor systemFillColor];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        
        __weak typeof (self) wself = self;
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            NSDictionary *attributes = [[text attributedSubstringFromRange:range] yy_attributes];
            NSString *urlString = [attributes objectForKey:NSLinkAttributeName];
            
            if (![urlString containsString:@":"]) {
                if ([urlString containsString:@"@"]) {
                    urlString = [NSString stringWithFormat:@"mailto:%@", urlString];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
                    return;
                } else if (![urlString hasPrefix:@"http"]) {
                    urlString = [NSString stringWithFormat:@"http://%@", urlString];
                }
            }
            
            if ([wself.actionDelegate respondsToSelector:@selector(BBCodeDidClickURL:)]) {
                [wself.actionDelegate BBCodeDidClickURL:urlString];
            }
        };
        
        self.yyLinkHeight = highlight;
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
    
    // 处理链接
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray <NSTextCheckingResult *> *results = [detector matchesInString:codeString.attributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, codeString.attributedString.string.length)];
    
    for (NSTextCheckingResult *result in results) {
        [codeString.attributedString yy_setTextHighlight:self.yyLinkHeight range:result.range];
        [codeString.attributedString yy_setColor:[UIColor systemBlueColor] range:result.range];
        [codeString.attributedString yy_setLink:[codeString.attributedString.string substringWithRange:result.range] range:result.range];
    }
    
    // 处理引用
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"【 在.*的(?:大作|邮件)中提到: 】.*\\s*" options:NSRegularExpressionCaseInsensitive error:nil];
    results = [expression matchesInString:codeString.attributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, codeString.attributedString.string.length)];
    for (NSTextCheckingResult *result in results) {
        [codeString.attributedString addAttributes:self.quoteTextAttributs range:result.range];
    }
    
    expression = [NSRegularExpression regularExpressionWithPattern:@":.*\\s*" options:NSRegularExpressionCaseInsensitive error:nil];
    results = [expression matchesInString:codeString.attributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, codeString.attributedString.string.length)];
    for (NSTextCheckingResult *result in results) {
        [codeString.attributedString addAttributes:self.quoteTextAttributs range:result.range];
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
    return @[@"b", @"i", @"u", @"size", @"B", @"I", @"U", @"SIZE",
             @"color", @"face", @"COLOR", @"FACE",
             @"url", @"img", @"URL", @"IMG",
             @"upload", @"UPLOAD"];
}

/** Returns the attributes for the part of NSAttributedString which will present the given BBCode element.  **/
- (NSDictionary *)getAttributesForElement:(BBElement *)element {
    if ([[element.tag lowercaseString] isEqualToString:@"b"]) {
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        return @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:0],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
        };
    } else if ([[element.tag lowercaseString] isEqualToString:@"i"]) {
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        return @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:0],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
        };
    } else if ([[element.tag lowercaseString] isEqualToString:@"u"]) {
        return @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                 NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                 NSForegroundColorAttributeName : [UIColor labelColor],
                 NSParagraphStyleAttributeName : self.paragraphStyle,
           };
    } else if ([[element.tag lowercaseString] containsString:@"size="]) {
        NSInteger size = [[element.tag substringFromIndex:5] integerValue];
        
        if (size >= 4 && size <= 6) {
            return @{
                  NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2],
                  NSForegroundColorAttributeName : [UIColor labelColor],
                  NSParagraphStyleAttributeName : self.paragraphStyle,
            };
        } else if (size > 6) {
            return @{
                  NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                  NSForegroundColorAttributeName : [UIColor labelColor],
                  NSParagraphStyleAttributeName : self.paragraphStyle,
            };
        } else {
            return self.normalTextAttributs;
        }
    } else if ([[element.tag lowercaseString] containsString:@"url="]) {
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
        return self.normalTextAttributs;
    }
    
    return nil;
}

@end
