//
//  BYRBBCodeToYYConverter.h
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Attachment;

@interface BYRImageAttachmentModel : NSObject

@property (nonatomic, strong) Attachment *attachment;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSAttributedString *attachmentText;
@property (nonatomic, strong) NSArray <BYRImageAttachmentModel *> *allSortedAttachments;

@end


@protocol BYRBBCodeToYYConverterActionDelegate <NSObject>

- (void)BBCodeDidClickURL:(NSString *)url;
- (void)BBCodeDidClickAttachment:(BYRImageAttachmentModel *)attachmentModel;

@end

@class Attachment;

@interface BYRBBCodeToYYConverter : NSObject

@property (nonatomic, weak) id <BYRBBCodeToYYConverterActionDelegate> actionDelegate;

+ (instancetype)sharedInstance;

- (NSAttributedString *)parseBBCode:(NSString *)code
                        attachemtns:(NSArray <Attachment *> *)attachments
                     containerWidth:(CGFloat)containerWidth;

@end


NS_ASSUME_NONNULL_END
