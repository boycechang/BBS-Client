//
//  WUDemoKeyboardBuilder.m
//  WUEmoticonsKeyboardDemo
//
//  Created by YuAo on 7/20/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "WUDemoKeyboardBuilder.h"
#import "WUDemoKeyboardTextKeyCell.h"
#import "WUDemoKeyboardPressedCellPopupView.h"

@implementation WUDemoKeyboardBuilder

+ (WUEmoticonsKeyboard *)sharedEmoticonsKeyboard {
    static WUEmoticonsKeyboard *_sharedEmoticonsKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //create a keyboard of default size
        WUEmoticonsKeyboard *keyboard = [WUEmoticonsKeyboard keyboard];
        
        //Icon keys
        NSMutableArray *emaStringArray = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 41; i++) {
            WUEmoticonsKeyboardKeyItem *loveKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
            loveKey.image = [UIImage imageNamed:[NSString stringWithFormat:@"[ema%i].gif", i]];
            loveKey.textToInput = [NSString stringWithFormat:@"[ema%i]", i];
            [emaStringArray addObject:loveKey];
        }
        WUEmoticonsKeyboardKeyItemGroup *emaGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        emaGroup.keyItems = emaStringArray;
        emaGroup.title = @"悠嘻猴";
        
        NSMutableArray *embStringArray = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 24; i++) {
            WUEmoticonsKeyboardKeyItem *loveKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
            loveKey.image = [UIImage imageNamed:[NSString stringWithFormat:@"[emb%i].gif", i]];
            loveKey.textToInput = [NSString stringWithFormat:@"[emb%i]", i];
            [embStringArray addObject:loveKey];
        }
        WUEmoticonsKeyboardKeyItemGroup *embGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        embGroup.keyItems = embStringArray;
        embGroup.title = @"兔斯基";
        
        NSMutableArray *emcStringArray = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 58; i++) {
            WUEmoticonsKeyboardKeyItem *loveKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
            loveKey.image = [UIImage imageNamed:[NSString stringWithFormat:@"[emc%i].gif", i]];
            loveKey.textToInput = [NSString stringWithFormat:@"[emc%i]", i];
            [emcStringArray addObject:loveKey];
        }
        WUEmoticonsKeyboardKeyItemGroup *emcGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        emcGroup.keyItems = emcStringArray;
        emcGroup.title = @"洋葱头";
        
        //Set keyItemGroups
        keyboard.keyItemGroups = @[emaGroup, embGroup, emcGroup];
        
        //Setup cell popup view
        [keyboard setKeyItemGroupPressedKeyCellChangedBlock:^(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup, WUEmoticonsKeyboardKeyCell *fromCell, WUEmoticonsKeyboardKeyCell *toCell) {
            [WUDemoKeyboardBuilder sharedEmotionsKeyboardKeyItemGroup:keyItemGroup pressedKeyCellChangedFromCell:fromCell toCell:toCell];
        }];
        
        //Custom utility keys
        [keyboard setImage:[UIImage imageNamed:@"keyboard_switch"] forButton:WUEmoticonsKeyboardButtonKeyboardSwitch state:UIControlStateNormal];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateNormal];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_switch_pressed"] forButton:WUEmoticonsKeyboardButtonKeyboardSwitch state:UIControlStateHighlighted];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del_pressed"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateHighlighted];
        
        //Keyboard background
        [keyboard setBackgroundImage:[[UIImage imageNamed:@"keyboard_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
        
        _sharedEmoticonsKeyboard = keyboard;
    });
    return _sharedEmoticonsKeyboard;
}

+ (void)sharedEmotionsKeyboardKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup
             pressedKeyCellChangedFromCell:(WUEmoticonsKeyboardKeyCell *)fromCell
                                    toCell:(WUEmoticonsKeyboardKeyCell *)toCell
{
    static WUDemoKeyboardPressedCellPopupView *pressedKeyCellPopupView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pressedKeyCellPopupView = [[WUDemoKeyboardPressedCellPopupView alloc] initWithFrame:CGRectMake(0, 0, 83, 110)];
        pressedKeyCellPopupView.hidden = YES;
        [[self sharedEmoticonsKeyboard] addSubview:pressedKeyCellPopupView];
    });
    
    if ([[self sharedEmoticonsKeyboard].keyItemGroups indexOfObject:keyItemGroup] <= 3) {
        [[self sharedEmoticonsKeyboard] bringSubviewToFront:pressedKeyCellPopupView];
        if (toCell) {
            pressedKeyCellPopupView.keyItem = toCell.keyItem;
            pressedKeyCellPopupView.hidden = NO;
            CGRect frame = [[self sharedEmoticonsKeyboard] convertRect:toCell.bounds fromView:toCell];
            pressedKeyCellPopupView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)-CGRectGetHeight(pressedKeyCellPopupView.frame)/2);
        }else{
            pressedKeyCellPopupView.hidden = YES;
        }
    }
}

@end
