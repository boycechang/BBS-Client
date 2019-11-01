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
#import "BYREmotionParser.h"
#import "BYRContentParser.h"
#import <Down-Swift.h>
#import <BYR-Swift.h>
#import <MJExtension.h>

@implementation BYRImageAttachmentModel
@end

@interface BYRBBCodeToYYConverter () <BBCodeParserDelegate, BBCodeStringDelegate, Styler>

@property (nonatomic, assign) CGFloat containerWidth;

@property (nonatomic, strong) NSArray *currentAttachments;
@property (nonatomic, strong) NSMutableArray *usedAttachments;
@property (nonatomic, strong) NSMutableArray *sotedAttachmentModels;

@property (nonatomic, strong) NSParagraphStyle *paragraphStyle;
@property (nonatomic, strong) YYTextHighlight *yyLinkHighlight;
@property (nonatomic, strong) NSDictionary *normalTextAttributs;

@end

@implementation BYRBBCodeToYYConverter

- (instancetype)init {
    self = [super init];
    if (self) {
        _usedAttachments = [NSMutableArray new];
        _sotedAttachmentModels = [NSMutableArray new];
        
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
        
        self.yyLinkHighlight = highlight;
    }
    return self;
}

- (NSAttributedString *)parseBBCode:(NSString *)code
                        attachemtns:(NSArray <Attachment *> *)attachments
                     containerWidth:(CGFloat)containerWidth;
{
    [self.usedAttachments removeAllObjects];
    [self.sotedAttachmentModels removeAllObjects];
    
    self.currentAttachments = attachments;
    self.containerWidth = containerWidth;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 4;
    _paragraphStyle = paragraphStyle;
    _normalTextAttributs = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
             NSForegroundColorAttributeName : [UIColor labelColor],
             NSParagraphStyleAttributeName : self.paragraphStyle,
    };
    
    BBCodeString *codeString = [[BBCodeString alloc] initWithBBCode:code andLayoutProvider:self];
    
    // 补充剩余的attachment
    for (Attachment *att in self.currentAttachments) {
        if ([self.usedAttachments containsObject:att]) {
            continue;
        }
        
        if (att.thumbnail_middle.length) {
            BYRImageAttachmentModel *model = [self generateImageAttachmentModel:att];
            [self.sotedAttachmentModels addObject:model];
            [codeString.attributedString appendAttributedString:model.attachmentText];
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
    
    for (BYRImageAttachmentModel *attModel in self.sotedAttachmentModels) {
        attModel.allSortedAttachments = [self.sotedAttachmentModels copy];
    }
    
    // parse link
    [[BYRContentParser sharedInstance] parseLink:codeString.attributedString highlight:self.yyLinkHighlight];
    
    // parse quote
    NSMutableParagraphStyle *quoteParagraphStyle = [NSMutableParagraphStyle new];
    quoteParagraphStyle.lineSpacing = 2;
    quoteParagraphStyle.headIndent = 5;
    quoteParagraphStyle.tailIndent = -5;
    quoteParagraphStyle.firstLineHeadIndent = 5;
    quoteParagraphStyle.paragraphSpacingBefore = 5;
    NSDictionary *quoteTextAttributs = @{
        NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],
        NSForegroundColorAttributeName : [UIColor secondaryLabelColor],
        NSParagraphStyleAttributeName : quoteParagraphStyle,
        BYRContentParserQuoteAttributedName : @1
    };
    [[BYRContentParser sharedInstance] parseQuote:codeString.attributedString attributes:quoteTextAttributs];
    
    // parse emoji
    [[BYREmotionParser sharedInstance] parseText:codeString.attributedString selectedRange:nil];
    
    return codeString.attributedString;
}


#pragma mark - action

- (void)imageAttachmentCicked:(BYRImageAttachmentModel *)imageAttachmentModel {
    if ([self.actionDelegate respondsToSelector:@selector(BBCodeDidClickAttachment:)]) {
        [self.actionDelegate BBCodeDidClickAttachment:imageAttachmentModel];
    }
}

#pragma mark - private

- (BYRImageAttachmentModel *)generateImageAttachmentModel:(Attachment *)attachment {
    BYRImageAttachmentModel *model = [BYRImageAttachmentModel new];
    model.attachment = attachment;
    model.imageView = [self generateImageViewWithURL:attachment.url];
    
    __weak typeof (self) wself = self;
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:model.imageView contentMode:UIViewContentModeCenter attachmentSize:model.imageView.frame.size alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [wself imageAttachmentCicked:model];
    };
    [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];
    
    model.attachmentText = attachText;
    return model;
}

- (UIImageView *)generateImageViewWithURL:(NSString *)url {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.containerWidth, 260)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor separatorColor].CGColor;
    imageView.layer.borderWidth = 0.5;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    return imageView;
}

#pragma mark - BBCodeStringDelegate

/** Returns the attributed text which will be displayed for the given BBCode element. **/
- (NSAttributedString *)getAttributedTextForElement:(BBElement *)element {
    if ([[element.tag lowercaseString] containsString:@"upload="]) {
        NSInteger index = [[element.tag substringFromIndex:7] integerValue];
        if (index > self.currentAttachments.count) {
            return nil;
        }
        
        Attachment *att = [self.currentAttachments objectAtIndex:index - 1];
        if (![self.usedAttachments containsObject:att]) {
            [self.usedAttachments addObject:att];
        }
        
        if (att.thumbnail_middle.length) {
            BYRImageAttachmentModel *model = [self generateImageAttachmentModel:att];
            [self.sotedAttachmentModels addObject:model];
            return model.attachmentText;
        } else {
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
            return attachText;
        }
        
    } else if ([[element.tag lowercaseString] containsString:@"img="]) {
        NSString *url = [element.tag substringFromIndex:4];
        
        UIImageView *imageView = [self generateImageViewWithURL:url];
        
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
    } else if ([[element.tag lowercaseString] containsString:@"md"]) {
        MarkDownParser *parser = [[MarkDownParser alloc] initWithString:element.format];
        NSAttributedString *attachText = [parser parseWithStyler:self];
        return attachText;
    }
    
    return nil;
}

/** Returns the whitelist of the BBCode tags your code supports. **/
- (NSArray *)getSupportedTags {
    return @[@"b", @"i", @"u", @"size", @"B", @"I", @"U", @"SIZE",
             @"color", @"face", @"COLOR", @"FACE",
             @"url", @"img", @"URL", @"IMG",
             @"upload", @"UPLOAD",
             @"md", @"MD"];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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
                  NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                  NSForegroundColorAttributeName : [UIColor labelColor],
                  NSParagraphStyleAttributeName : self.paragraphStyle,
            };
        } else if (size > 6) {
            return @{
                  NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2],
                  NSForegroundColorAttributeName : [UIColor labelColor],
                  NSParagraphStyleAttributeName : self.paragraphStyle,
            };
        } else {
            return self.normalTextAttributs;
        }
    } else if ([[element.tag lowercaseString] containsString:@"color="]) {
        NSString *hexString = [element.tag substringFromIndex:6];
        UIColor *color = [self colorFromHexString:hexString];
        return @{
              NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
              NSForegroundColorAttributeName : color ?: [UIColor labelColor],
              NSParagraphStyleAttributeName : self.paragraphStyle,
        };
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
    } else if ([[element.tag lowercaseString] containsString:@"md"]) {
        return nil;
    }
    
    return self.normalTextAttributs;
}


#pragma mark - Styler

- (void)styleWithBlockQuote:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithCode:(NSMutableAttributedString * _Nonnull)str {
    YYTextBorder *codeBorder = [YYTextBorder new];
    codeBorder.lineStyle = YYTextLineStyleSingle;
    codeBorder.fillColor = [UIColor tertiarySystemFillColor];
    codeBorder.insets = UIEdgeInsetsMake(0, -3, 0, -3);
    codeBorder.cornerRadius = 2;
    codeBorder.strokeWidth = YYTextCGFloatFromPixel(2);
    
    NSMutableParagraphStyle *codeParagraph = [NSMutableParagraphStyle new];
    codeParagraph.lineSpacing = 2;
    codeParagraph.headIndent = 5;
    codeParagraph.tailIndent = -5;
    codeParagraph.firstLineHeadIndent = 5;
    codeParagraph.paragraphSpacingBefore = 5;
    
    NSDictionary *att = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCallout],
             NSForegroundColorAttributeName : [UIColor secondaryLabelColor],
             NSParagraphStyleAttributeName : codeParagraph,
                          YYTextBorderAttributeName : codeBorder
    };
    
    [str addAttributes:att range:NSMakeRange(0, str.length)];
}

- (void)styleWithCodeBlock:(NSMutableAttributedString * _Nonnull)str fenceInfo:(NSString * _Nullable)fenceInfo {
    YYTextBorder *codeBorder = [YYTextBorder new];
    codeBorder.lineStyle = YYTextLineStyleSingle;
    codeBorder.fillColor = [UIColor tertiarySystemFillColor];
    codeBorder.insets = UIEdgeInsetsMake(-3, -3, -3, -3);
    codeBorder.cornerRadius = 6;
    codeBorder.strokeWidth = YYTextCGFloatFromPixel(2);
    
    NSMutableParagraphStyle *codeParagraph = [NSMutableParagraphStyle new];
    codeParagraph.lineSpacing = 2;
    codeParagraph.headIndent = 5;
    codeParagraph.tailIndent = -5;
    codeParagraph.firstLineHeadIndent = 5;
    codeParagraph.paragraphSpacingBefore = 5;
    NSDictionary *att = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCallout],
             NSForegroundColorAttributeName : [UIColor secondaryLabelColor],
             NSParagraphStyleAttributeName : codeParagraph,
                          YYTextBlockBorderAttributeName : codeBorder
    };
    
    [str addAttributes:att range:NSMakeRange(0, str.length)];
}

- (void)styleWithCustomBlock:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithCustomInline:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithDocument:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithEmphasis:(NSMutableAttributedString * _Nonnull)str {
    UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
    UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    NSDictionary *att = @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:0],
             NSForegroundColorAttributeName : [UIColor labelColor],
             NSParagraphStyleAttributeName : self.paragraphStyle,
    };
    
    [str addAttributes:att range:NSMakeRange(0, str.length)];
}

- (void)styleWithHeading:(NSMutableAttributedString * _Nonnull)str level:(NSInteger)level {
    CGFloat scale = 1.f + (1.f / (CGFloat)level);
    UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
    UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    NSDictionary *att = @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:descriptor.pointSize * scale],
             NSForegroundColorAttributeName : [UIColor labelColor],
             NSParagraphStyleAttributeName : self.paragraphStyle,
    };
    
    [str addAttributes:att range:NSMakeRange(0, str.length)];
}

- (void)styleWithHtmlBlock:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithHtmlInline:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithImage:(NSMutableAttributedString * _Nonnull)str title:(NSString * _Nullable)title url:(NSString * _Nullable)url {
    UIImageView *imageView = [self generateImageViewWithURL:url];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    __weak typeof (self) wself = self;
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([wself.actionDelegate respondsToSelector:@selector(BBCodeDidClickURL:)]) {
            [wself.actionDelegate BBCodeDidClickURL:url];
        }
    };
    [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];
    
    return [str replaceCharactersInRange:NSMakeRange(0, str.length) withAttributedString:attachText];
}

- (void)styleWithItem:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithLineBreak:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithLink:(NSMutableAttributedString * _Nonnull)str title:(NSString * _Nullable)title url:(NSString * _Nullable)url {
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
    
    [str addAttributes:@{YYTextHighlightAttributeName : highlight,
             NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
             NSForegroundColorAttributeName : [UIColor systemBlueColor],
             NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
             NSParagraphStyleAttributeName : self.paragraphStyle,
    } range:NSMakeRange(0, str.length)];
}

- (void)styleWithList:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithParagraph:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithSoftBreak:(NSMutableAttributedString * _Nonnull)str {
    
}

- (void)styleWithStrong:(NSMutableAttributedString * _Nonnull)str {
    UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
    UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    NSDictionary *att = @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:0],
             NSForegroundColorAttributeName : [UIColor labelColor],
             NSParagraphStyleAttributeName : self.paragraphStyle,
    };
    
    [str addAttributes:att range:NSMakeRange(0, str.length)];
}

- (void)styleWithText:(NSMutableAttributedString * _Nonnull)str {
    [str addAttributes:self.normalTextAttributs range:NSMakeRange(0, str.length)];
}

- (void)styleWithThematicBreak:(NSMutableAttributedString * _Nonnull)str {
    
}

@synthesize listPrefixAttributes;

@end
