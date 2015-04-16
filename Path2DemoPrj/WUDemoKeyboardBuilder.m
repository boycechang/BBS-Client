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
        NSMutableArray *emStringArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 73; i++) {
            WUEmoticonsKeyboardKeyItem *loveKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
            loveKey.image = [UIImage imageNamed:[NSString stringWithFormat:@"[em%i].gif", i]];
            loveKey.textToInput = [NSString stringWithFormat:@"[em%i]", i];
            [emStringArray addObject:loveKey];
        }
        WUEmoticonsKeyboardKeyItemGroup *emGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        emGroup.keyItems = emStringArray;
        emGroup.title = @"经典";
        
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
        
        //Text keys
        NSArray *textKeys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmotionTextKeys" ofType:@"plist"]];
        
        NSMutableArray *textKeyItems = [NSMutableArray array];
        for (NSString *text in textKeys) {
            WUEmoticonsKeyboardKeyItem *keyItem = [[WUEmoticonsKeyboardKeyItem alloc] init];
            keyItem.title = text;
            keyItem.textToInput = text;
            [textKeyItems addObject:keyItem];
        }
        
        //Text key group
        WUEmoticonsKeyboardKeysPageFlowLayout *textIconsLayout = [[WUEmoticonsKeyboardKeysPageFlowLayout alloc] init];
        textIconsLayout.itemSize = CGSizeMake(80, 142/3.0);
        textIconsLayout.itemSpacing = 0;
        textIconsLayout.lineSpacing = 0;
        textIconsLayout.pageContentInsets = UIEdgeInsetsMake(0,0,0,0);
        
        WUEmoticonsKeyboardKeyItemGroup *textIconsGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        textIconsGroup.keyItems = textKeyItems;
        textIconsGroup.keyItemsLayout = textIconsLayout;
        textIconsGroup.keyItemCellClass = WUDemoKeyboardTextKeyCell.class;
        textIconsGroup.title = @"文字";
        
        //Set keyItemGroups
        keyboard.keyItemGroups = @[emGroup, emaGroup, embGroup, emcGroup, textIconsGroup];
        
        //Setup cell popup view
        [keyboard setKeyItemGroupPressedKeyCellChangedBlock:^(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup, WUEmoticonsKeyboardKeyCell *fromCell, WUEmoticonsKeyboardKeyCell *toCell) {
            [WUDemoKeyboardBuilder sharedEmotionsKeyboardKeyItemGroup:keyItemGroup pressedKeyCellChangedFromCell:fromCell toCell:toCell];
        }];
        

        //Keyboard appearance
        
        //Custom text icons scroll background
        UIView *textGridBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [textIconsLayout collectionViewContentSize].width, [textIconsLayout collectionViewContentSize].height)];
        textGridBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textGridBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyboard_grid_bg"]];
        [textIconsLayout.collectionView addSubview:textGridBackgroundView];
        
        //Custom utility keys
        [keyboard setImage:[UIImage imageNamed:@"keyboard_switch"] forButton:WUEmoticonsKeyboardButtonKeyboardSwitch state:UIControlStateNormal];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateNormal];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_switch_pressed"] forButton:WUEmoticonsKeyboardButtonKeyboardSwitch state:UIControlStateHighlighted];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del_pressed"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateHighlighted];
        
        //Keyboard background
        [keyboard setBackgroundImage:[[UIImage imageNamed:@"keyboard_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
        //[keyboard setBackgroundColor:[UIColor lightGrayColor]];
        
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setTintColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
         
        //SegmentedControl
        /*
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setBackgroundImage:[[UIImage imageNamed:@"keyboard_segment_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setBackgroundImage:[[UIImage imageNamed:@"keyboard_segment_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setDividerImage:[UIImage imageNamed:@"keyboard_segment_normal_selected"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setDividerImage:[UIImage imageNamed:@"keyboard_segment_selected_normal"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        */
        
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
