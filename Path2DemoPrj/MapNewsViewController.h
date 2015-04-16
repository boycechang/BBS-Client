//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomNoFooterWithDeleteTableView.h"
#import "MapNewsTableViewCell.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "PinAnnotation.h"
#import "PinAnnotationView.h"
#import "DetailsAnnotation.h"
#import "DetailsAnnotationView.h"
#import "MKMapView+MapViewUtil.h"

@interface MapNewsViewController : UIViewController<MBProgressHUDDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSArray *topTenArray;
    NSArray *avObjectArray;
    NSArray *dataArray;
    CustomNoFooterWithDeleteTableView *customTableView;
    FPActivityView *activityView;
    
    MKMapView *newsMapView;
}
@property(nonatomic, strong)NSArray *topTenArray;
@property(nonatomic, strong)NSArray *avObjectArray;
@property(nonatomic, strong)CustomNoFooterWithDeleteTableView * customTableView;
@property(nonatomic, strong)MKMapView *newsMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) AVGeoPoint *geoPoint;

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)PinAnnotation *pinAnnotation;
@property (nonatomic, strong)DetailsAnnotation *detailsAnnotation;
@property (nonatomic, strong)NSMutableArray *detailsAnnoArray;
@end
