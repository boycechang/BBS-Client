//
//  FriendCellView.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface VoteCellView : UITableViewCell
{
    IBOutlet UILabel * voteTitleLabel;
    IBOutlet UILabel * timeLabel;
    IBOutlet UILabel * userCountLabel;
    
    IBOutlet UILabel * authorLabel;
    IBOutlet UIImageView * authorHeadImageView;
    
    Vote * vote;
}
@property(nonatomic, strong)Vote * vote;
@property(nonatomic, strong)IBOutlet UIImageView * backImageView;
@end
