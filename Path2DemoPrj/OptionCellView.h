//
//  FriendCellView.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "DataModel.h"

@interface OptionCellView : UITableViewCell
{
    IBOutlet UILabel *optionLabel;
    IBOutlet UIProgressView *progress;
    IBOutlet UILabel *numLabel;
    IBOutlet UILabel *checkLabel;
    LDProgressView *progressView;
    
    Vote * rootVote;
    Vote * option;
    
    BOOL isSelect;
}
@property(nonatomic, strong)Vote * rootVote;
@property(nonatomic, strong)Vote * option;
@property(nonatomic, assign)BOOL isSelect;
@end
