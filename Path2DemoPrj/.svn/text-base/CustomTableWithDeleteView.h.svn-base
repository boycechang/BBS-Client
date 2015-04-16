//
//  CustomTableView.h
//  UI实验
//
//  Created by 张晓波 on 12/29/11.
//  Copyright (c) 2011 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableHeaderView.h"
#import "RefreshTableFooterView.h"

@protocol CustomTableViewDataDeleage;
@protocol CustomTableViewDelegate; 

@interface CustomTableWithDeleteView : UIView<RefreshTableHeaderViewDelegate,RefreshTableFooterViewDelegate,UITableViewDelegate,UITableViewDataSource>
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