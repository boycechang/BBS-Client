//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BoardsViewController.h"
#import <Masonry.h>
#import "Models.h"
#import "TopicsViewController.h"
#import "BYRNetworkManager.h"
#import "BYRNetworkReponse.h"
#import "BoardCell.h"
#import "BoardHeaderCollectionReusableView.h"

@interface BoardsViewController () <UIContextMenuInteractionAnimating>

@property (nonatomic, strong) NSArray *favBoards;
@property (nonatomic, strong) NSArray *boards;

@end


@implementation BoardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flowLayout.minimumLineSpacing = 15;
    self.flowLayout.minimumInteritemSpacing = 15;
    self.flowLayout.estimatedItemSize = CGSizeMake(100, 100);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    [self.collectionView registerClass:BoardCell.class forCellWithReuseIdentifier:BoardCell.class.description];
    [self.collectionView registerClass:BoardHeaderCollectionReusableView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:BoardHeaderCollectionReusableView.class.description];
    
    if (self.rootSection == nil) {
        self.navigationItem.title = @"版面";
        self.flowLayout.headerReferenceSize = CGSizeMake(100, 60);
    } else {
        self.title = self.rootSection.board_description ?: self.rootSection.name;
    }
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.rootSection) {
        return 1;
    }
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        BoardHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BoardHeaderCollectionReusableView.class.description forIndexPath:indexPath];
        [header updateWithSectionName:indexPath.section == 0 ? @"我的收藏" : @"全部版面"];
        reusableview = header;
    }
    
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.rootSection) {
        return self.boards.count;
    }
    
    if (section == 0) {
        return self.favBoards.count;
    } else {
        return self.boards.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *boards;
    if (!self.rootSection &&
        indexPath.section == 0) {
        boards = self.favBoards;
    } else {
        boards = self.boards;
    }
    
    Board *board = [boards objectAtIndex:indexPath.row];
    BoardCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:BoardCell.class.description forIndexPath:indexPath];
    [cell updateWithBoard:board isMyFav:boards == self.favBoards];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[self viewControllerForIndexPath:indexPath] animated:YES];
}

- (nullable UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point
{
    UIAction *action1 = [UIAction actionWithTitle:@"测试1" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        
    }];
    UIAction *action2 = [UIAction actionWithTitle:@"测试2" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        
    }];
    
    UIMenu *menu = [UIMenu menuWithTitle:@"选择" children:@[action1, action2]];
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        return [self viewControllerForIndexPath:indexPath];
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return menu;
    }];
    
    return config;
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator
{
    UIViewController *vc = animator.previewViewController;
    [animator addCompletion:^{
        [self.navigationController pushViewController:vc animated:NO];
    }];
}

- (UIViewController *)viewControllerForIndexPath:(NSIndexPath *)indexPath {
    NSArray *boards;
    if (!self.rootSection &&
        indexPath.section == 0) {
        boards = self.favBoards;
    } else {
        boards = self.boards;
    }
    
    Board *board = [boards objectAtIndex:indexPath.row];
    
    if (board.section) {
        TopicsViewController *topicsViewController = [TopicsViewController new];
        topicsViewController.board = board;
        return topicsViewController;
    } else {
        BoardsViewController *boardsViewController = [[BoardsViewController alloc] init];
        boardsViewController.rootSection = board;
        return boardsViewController;
    }
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    if (self.rootSection == nil) {
        __block int finishedCount = 0;
        [[BYRNetworkManager sharedInstance] GET:@"/section.json" parameters:nil responseClass:BoardResponse.class success:^(NSURLSessionDataTask * _Nonnull task, BoardResponse * _Nullable responseObject) {
            
            NSMutableArray *allBoards = [NSMutableArray new];
            
            if (responseObject.sections) {
                [allBoards addObjectsFromArray:responseObject.sections];
            }
            
            if (responseObject.sub_sections) {
                [allBoards addObjectsFromArray:responseObject.sub_sections];
            }
            
            if (responseObject.boards) {
                [allBoards addObjectsFromArray:responseObject.boards];
            }
            
            self.boards = allBoards;
            
            finishedCount++;
            if (finishedCount == 2) {
                completion();
            }
            
            completion();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finishedCount++;
            if (finishedCount == 2) {
                completion();
            }
        }];
        
        [[BYRNetworkManager sharedInstance] GET:@"/favorite/0.json" parameters:nil responseClass:BoardResponse.class success:^(NSURLSessionDataTask * _Nonnull task, BoardResponse * _Nullable responseObject) {
            self.favBoards = responseObject.boards;
            
            finishedCount++;
            if (finishedCount == 2) {
                completion();
            }
            
            completion();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finishedCount++;
            if (finishedCount == 2) {
                completion();
            }
        }];
        
    } else {
        [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/section/%@.json", self.rootSection.name] parameters:nil responseClass:BoardResponse.class success:^(NSURLSessionDataTask * _Nonnull task, BoardResponse * _Nullable responseObject) {
            NSMutableArray *allBoards = [NSMutableArray new];
            
            if (responseObject.sections) {
                [allBoards addObjectsFromArray:responseObject.sections];
            }
            
            if (responseObject.sub_sections) {
                [allBoards addObjectsFromArray:responseObject.sub_sections];
            }
            
            if (responseObject.boards) {
                [allBoards addObjectsFromArray:responseObject.boards];
            }
            
            self.boards = allBoards;
            completion();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion();
        }];
    }
}

@end
