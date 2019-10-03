//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "VoteCellView.h"
#import <UIImageView+WebCache.h>

@implementation VoteCellView
@synthesize vote;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)dateToString:(NSDate *)date;
{
    NSMutableString * dateString = [[NSMutableString alloc] init];
    
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents;
    dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        
        [dateString  appendString:@""];
        
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) && (dateComponents.day == todayComponents.day - 1)) {
        
        [dateString  appendString:@"昨天"];
        
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.weekOfYear == todayComponents.weekOfYear)) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"cccc";
        NSArray * array = [NSArray arrayWithObjects:@"开始", @"天", @"一", @"二", @"三", @"四", @"五", @"六", nil];
        [dateString  appendString:[NSString stringWithFormat:@"星期%@", [array objectAtIndex:dateComponents.weekday]]];
        
    } else if (dateComponents.year == todayComponents.year) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd";
        if ([dateFormatter stringFromDate:date] != nil) {
            [dateString  appendString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]]];
        }
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        if ([dateFormatter stringFromDate:date] != nil) {
            [dateString  appendString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]]];
        }
    }
    
    return dateString;
}


#pragma mark UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    
	[voteTitleLabel setText:vote.voteTitle];
    [authorLabel setText:vote.author];
    [userCountLabel setText:[NSString stringWithFormat:@"%i", vote.user_count]];
    
    if (vote.authorHeadUrl != nil) {
        [authorHeadImageView sd_setImageWithURL:vote.authorHeadUrl];
        authorHeadImageView.layer.cornerRadius = 30.0f;
        authorHeadImageView.clipsToBounds = YES;
    }
    
    if (vote.is_end)
        [timeLabel setText:@"已结束"];
    else
        [timeLabel setText:[NSString stringWithFormat:@"%@", [self dateToString:vote.end]]];
    
}
@end
