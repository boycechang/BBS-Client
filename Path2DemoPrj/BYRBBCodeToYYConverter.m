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

@interface BYRBBCodeToYYConverter () <BBCodeParserDelegate, BBCodeStringDelegate>

@property (nonatomic, assign) CGFloat containerWidth;
@property (nonatomic, strong) NSArray *currentAttachments;

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
    }
    return self;
}

- (NSAttributedString *)parseBBCode:(NSString *)code
                        attachemtns:(NSArray <Attachment *> *)attachments
                     containerWidth:(CGFloat)containerWidth;
{
    self.currentAttachments = attachments;
    self.containerWidth = containerWidth;
    BBCodeString *codeString = [[BBCodeString alloc] initWithBBCode:code andLayoutProvider:self];
    return codeString.attributedString;
}

#pragma mark - BBCodeStringDelegate

/** Returns the attributed text which will be displayed for the given BBCode element. **/
- (NSAttributedString *)getAttributedTextForElement:(BBElement *)element {
    if ([element.tag containsString:@"upload="]) {
        NSInteger index = [[element.tag substringFromIndex:7] integerValue];
        Attachment *att = [self.currentAttachments objectAtIndex:index - 1];
        if (!att.thumbnail_middle) {
            return nil;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.containerWidth, 260)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor separatorColor].CGColor;
        imageView.layer.borderWidth = 0.5;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:att.url]];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(self.containerWidth, 260) alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
        
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
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(self.containerWidth, 260) alignToFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] alignment:YYTextVerticalAlignmentTop];
        
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
                 NSForegroundColorAttributeName : [UIColor labelColor]
        };
    } else if ([element.tag isEqualToString:@"i"]) {
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        return @{NSFontAttributeName : [UIFont fontWithDescriptor:newDescriptor size:0],
                 NSForegroundColorAttributeName : [UIColor labelColor]
        };
    } else if ([element.tag isEqualToString:@"u"]) {
        return @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                 NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                 NSForegroundColorAttributeName : [UIColor labelColor]
           };
    } else if ([element.tag containsString:@"url"]) {
        NSString *url = [element.tag substringFromIndex:4];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor systemBlueColor]];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            
        };
        return @{YYTextHighlightAttributeName : highlight,
                 NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]
        };
    } else {
        
        return @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                 NSForegroundColorAttributeName : [UIColor labelColor]
        };
    }
    
    return nil;
}

@end
