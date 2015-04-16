//
//  CustomNoFooterWithDeleteTableView.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RefreshTableHeaderView.h"
#import "RefreshTableFooterView.h"

@protocol CustomTableViewDataDeleage;
@protocol CustomTableViewDelegate;

@interface CustomNoFooterWithDeleteTableView : UIView<RefreshTableHeaderViewDelegate,RefreshTableFooterViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL isHeaderDataLoading;
    BOOL isFooterDataLoading;
    RefreshTableHeaderView * mRefreshTableHeaderView;
    RefreshTableFooterView * mRefreshTableFooterView;
    
    UITableView * mTableView;
    CGFloat mTableViewContentHeight;
    int mTableViewCellNum;
    id mDelegate;
    float mContentOffset;
}
-(void)removeFooterView;
@property (nonatomic, assign) float mContentOffset;
- (id)initWithFrame:(CGRect)frame Delegate:(id)delegate;
-(void)reloadData;
-(void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
-(NSIndexPath *)indexPathForCell:(UITableViewCell *)tableViewCell;
-(void)setCustomTableViewTag:(NSInteger)tag;
@property(nonatomic, retain) UITableView * mTableView;
@property(nonatomic, retain) RefreshTableHeaderView * mRefreshTableHeaderView;
@property(nonatomic, retain) RefreshTableFooterView * mRefreshTableFooterView;
@end

@protocol CustomTableViewDataDeleage 
@required
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol CustomTableViewDelegate 
@required
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView;
- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView;
@optional
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
@end