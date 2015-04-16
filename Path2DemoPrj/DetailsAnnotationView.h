//
//  DetailsAnnotationView.h
//  Match3Draft
//
//  Created by iObitLXF on 2/21/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "DetailsView.h"

@interface DetailsAnnotationView : MKAnnotationView

@property (nonatomic,strong)DetailsView *cell;
-(void)setCellUI:(MapItemInfoVO *)vo;

@end
