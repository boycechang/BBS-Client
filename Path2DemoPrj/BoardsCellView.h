//
//  BoardsCellView.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/2/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BoardsCellView : UITableViewCell
{
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * descriptionLabel;
    IBOutlet UILabel * sectionLabel;
    IBOutlet UILabel * usersLabel;
    IBOutlet UILabel * countLabel;
    
    NSString * name;
    NSString * description;
    int users;
    int count;
    int section;
    BOOL leaf;
}
@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * description;
@property(nonatomic, assign)int users;
@property(nonatomic, assign)int count;
@property(nonatomic, assign)int section;
@property(nonatomic, assign)BOOL leaf;

@property(nonatomic, strong)UILabel * nameLabel;
@end
