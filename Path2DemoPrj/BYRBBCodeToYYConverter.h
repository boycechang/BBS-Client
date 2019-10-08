//
//  BYRBBCodeToYYConverter.h
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BYRBBCodeToYYConverterActionDelegate <NSObject>

- (void)BBCodeDidClickURL:(NSString *)url;
- (void)BBCodeDidClickAttachmentImage:(NSArray *)attachments index:(NSInteger)indx sourceView:(UIView *)view;

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
