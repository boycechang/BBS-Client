//
//  BoardsViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BYRCollectionViewController.h"

@class Board;

@interface BoardsViewController : BYRCollectionViewController

@property (nonatomic, strong) Board *rootSection;

@end
