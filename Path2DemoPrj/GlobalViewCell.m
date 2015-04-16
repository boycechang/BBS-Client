//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "GlobalViewCell.h"

@implementation GlobalViewCell
@synthesize ID;
@synthesize title;
@synthesize author;
@synthesize board;
@synthesize time;
@synthesize replies;
@synthesize read;
@synthesize unread;
@synthesize top;
@synthesize mark;
@synthesize hasAtt;
@synthesize articleTitleLabel;
@synthesize articleDateLabel;
@synthesize boardLabel;
@synthesize readandreplyLabel;
@synthesize authorLabel;

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
        
        [dateString  appendString:@"今天"];
        
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
    
    if (unread) {
        [articleTitleLabel setAlpha:1];
    }
    else {
        [articleTitleLabel setAlpha:0.4];
    }
    
    [articleTitleLabel setText:[NSString stringWithFormat:@"%@", title]];
    [authorLabel setText:[NSString stringWithFormat:@"%@  %@%@ %@", author, (top? @"🔝":@""), (mark? @"💎":@""), (hasAtt? @"🔗":@"")]];
    [readandreplyLabel setText:[NSString stringWithFormat:@"%i", replies]];
    if (board != nil) {
        [boardLabel setText:[NSString stringWithFormat:@"%@ 版", board]];
    }
    else {
        [boardLabel setText:@""];
    }
    
    [articleDateLabel setText:[self dateToString:time]];
    
    backImageView.layer.cornerRadius = 5.0;
}
@end
