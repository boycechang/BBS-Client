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
    UILabel * nameLabel;
    IBOutlet UILabel * descriptionLabel;
    IBOutlet UILabel * sectionLabel;    
    
    
    NSString * name;
    NSString * description;
    int section;
    BOOL leaf;
}

@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * description;
@property(nonatomic, assign)int section;
@property(nonatomic, assign)BOOL leaf;

-(void)setReadyToShow;
-(void)showAinmationWhenSeleceted;
@end
