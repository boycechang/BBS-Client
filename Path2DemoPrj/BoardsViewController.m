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
#import "BoardHeaderView.h"
#import "PostTopicViewController.h"

@interface BoardsViewController ()

@property (nonatomic, strong) NSArray *favBoards;
@property (nonatomic, strong) NSArray *boards;

@end


@implementation BoardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    
    self.flowLayout.minimumLineSpacing = 15;
    self.flowLayout.minimumInteritemSpacing = 15;
    self.flowLayout.estimatedItemSize = CGSizeMake(100, 100);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    [self.collectionView registerClass:BoardCell.class forCellWithReuseIdentifier:BoardCell.class.description];
    [self.collectionView registerClass:BoardHeaderView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:BoardHeaderView.class.description];
    
    if (self.rootSection == nil) {
        self.navigationItem.title = @"版面";
        self.flowLayout.headerReferenceSize = CGSizeMake(100, 50);
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
        BoardHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BoardHeaderView.class.description forIndexPath:indexPath];
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
    NSArray *boards;
    if (!self.rootSection &&
        indexPath.section == 0) {
        boards = self.favBoards;
    } else {
        boards = self.boards;
    }
    
    Board *board = [boards objectAtIndex:indexPath.row];
    
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        if (board.section) {
            TopicsViewController *topicsViewController = [TopicsViewController new];
            topicsViewController.board = board;
            return topicsViewController;
        } else {
            BoardsViewController *boardsViewController = [[BoardsViewController alloc] init];
            boardsViewController.rootSection = board;
            return boardsViewController;
        }
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        if (board.section) {
            UIAction *action1 = [UIAction actionWithTitle: board.is_favorite ? @"取消收藏" : @"收藏" image:board.is_favorite ? [UIImage systemImageNamed:@"star.slash.fill"] : [UIImage systemImageNamed:@"star"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                
                NSString *baseurl;
                if (board.is_favorite) {
                    baseurl = @"/favorite/delete/0.json";
                } else {
                    baseurl = @"/favorite/add/0.json";
                }
                
                NSDictionary *params = @{@"name" : board.name, @"dir" : @"0"};
                
                [[BYRNetworkManager sharedInstance] POST:baseurl parameters:params responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                    board.is_favorite = !board.is_favorite;
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }];
            UIAction *action2 = [UIAction actionWithTitle:@"发帖" image:[UIImage systemImageNamed:@"square.and.pencil"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
                postTopicViewController.postType = 0;
                postTopicViewController.boardName = board.name;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.navigationBar.prefersLargeTitles = NO;
                [self presentViewController:nav animated:YES completion:nil];
            }];
            
            UIMenu *menu = [UIMenu menuWithTitle:nil children:@[action1, action2]];
            return menu;
        }
        return nil;
    }];
    
    return config;
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
