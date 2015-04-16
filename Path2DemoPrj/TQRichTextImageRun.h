//
//  TQRichTextImageRun.h
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextBaseRun.h"

@interface TQRichTextImageRun : TQRichTextBaseRun

void TQRichTextRunEmojiDelegateDeallocCallback(void *refCon);

//--上行高度
CGFloat TQRichTextRunEmojiDelegateGetAscentCallback(void *refCon);

//--下行高度
CGFloat TQRichTextRunEmojiDelegateGetDescentCallback(void *refCon);
//-- 宽
CGFloat TQRichTextRunEmojiDelegateGetWidthCallback(void *refCon);
@end
