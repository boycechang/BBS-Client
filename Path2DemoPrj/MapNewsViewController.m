;//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MapNewsViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Memo.h"
#import "SingleMapNewsViewController.h"
#import "Utils.h"

@implementation MapNewsViewController
@synthesize topTenArray;
@synthesize avObjectArray;
@synthesize customTableView;
@synthesize newsMapView;

@synthesize dataArray;
@synthesize pinAnnotation;
@synthesize detailsAnnotation;
@synthesize detailsAnnoArray;

#define KILORANGE 2

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"身边事儿";

    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
    customTableView.backgroundColor = [UIColor clearColor];
    customTableView.mTableView.backgroundColor = [UIColor clearColor];
    customTableView.mTableView.separatorColor = [UIColor clearColor];
    customTableView.mRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTableView];
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    
    self.detailsAnnoArray = [[NSMutableArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100;
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    
    UIBarButtonItem *switchButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map"] style:UIBarButtonItemStylePlain target:self action:@selector(switchView:)];
    self.navigationItem.rightBarButtonItem = switchButton;
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backBarItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (newsMapView == nil) {
        newsMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        newsMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        newsMapView.delegate = self;
        newsMapView.showsUserLocation = YES;
        [self.view addSubview:newsMapView];
        
        newsMapView.hidden = YES;
        [self getData];
    }
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.geoPoint = [AVGeoPoint geoPointWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}

-(IBAction)switchView:(id)sender
{
    if (newsMapView.hidden) {
        [newsMapView setHidden:NO];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"list"]];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([self.geoPoint latitude], [self.geoPoint longitude]), 200, 200);
        MKCoordinateRegion adjustedRegion = [newsMapView regionThatFits:viewRegion];
        [newsMapView setRegion:adjustedRegion animated:YES];
    } else {
        [newsMapView setHidden:YES];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"map"]];
    }
}

-(void)getData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        while(self.geoPoint == nil) {
            
        }
        
        if (appDelegate.myBBS.mapNewsArray != nil && appDelegate.myBBS.mapAVObjectArray != nil && appDelegate.myBBS.mapPointArray != nil) {
            self.topTenArray = appDelegate.myBBS.mapNewsArray;
            self.avObjectArray = appDelegate.myBBS.mapAVObjectArray;
            self.dataArray = appDelegate.myBBS.mapPointArray;
        } else {
            AVQuery * query = [AVQuery queryWithClassName:@"News"];
            [query whereKey:@"is_published" equalTo:[NSNumber numberWithInt:1]];
            [query whereKey:@"location" nearGeoPoint:self.geoPoint withinKilometers:KILORANGE];
            query.limit = 50;      //获取最接近用户地点的50条数据
            
            NSArray* nearPlaces = [query findObjects];
            
            NSMutableArray *memosArray = [[NSMutableArray alloc] init];
            NSMutableArray *data = [[NSMutableArray alloc] init];
            
            for (AVObject * avObject in nearPlaces) {
                Memo *memo = [[Memo alloc] init];
                memo.createdAt = (NSDate *)[avObject objectForKey:@"updatedAt"];
                memo.title = (NSString *)[avObject objectForKey:@"title"];
                memo.content = (NSString *)[avObject objectForKey:@"content"];
                memo.like = (NSNumber *)[avObject objectForKey:@"like"];
                AVFile *imageFile = [avObject objectForKey:@"image"];
                if (imageFile != nil) {
                    memo.image = [UIImage imageWithData:[imageFile getData]];
                }
                AVGeoPoint *geoPoint = [avObject objectForKey:@"location"];
                memo.latitude = [NSNumber numberWithDouble:[geoPoint latitude]];
                memo.longtitude = [NSNumber numberWithDouble:[geoPoint longitude]];
                memo.username = [avObject objectForKey:@"username"];
                [memosArray addObject:memo];
                
                MapItemInfoVO *vo = [[MapItemInfoVO alloc] init];
                vo.strLat = [NSString stringWithFormat:@"%f", [geoPoint latitude]];
                vo.strLon = [NSString stringWithFormat:@"%f", [geoPoint longitude]];
                vo.strTitle = (NSString *)[avObject objectForKey:@"title"];
                vo.strDetails = (NSString *)[avObject objectForKey:@"content"];
                
                NSMutableArray *childAry = [[NSMutableArray alloc] init];
                for (int i = 0; i < 2; i++) {
                    MapItemInfoVO *child = [[MapItemInfoVO alloc] init];
                    child.strId = [NSString stringWithFormat:@"%d", i];
                    if (i == 0) {
                        child.strTitle = [NSString stringWithFormat:@"%d\n赞", [memo.like intValue]];
                    } else if (i == 1) {
                        child.strTitle = [NSString stringWithFormat:@"%@", [BBSAPI dateToString:memo.createdAt]];
                    }
                    [childAry addObject:child];
                }
                vo.aryChild = childAry;
                
                if (imageFile != nil) {
                    vo.image = [UIImage imageWithData:[imageFile getData]];
                } else {
                    vo.image = [UIImage imageNamed:@"VideoIcon"];
                }
                [data addObject:vo];
            }
            
            self.avObjectArray = nearPlaces;
            self.topTenArray = memosArray;
            self.dataArray = data;
             
            appDelegate.myBBS.mapNewsArray = self.topTenArray;
            appDelegate.myBBS.mapAVObjectArray = self.avObjectArray;
            appDelegate.myBBS.mapPointArray = self.dataArray;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [newsMapView addAnnotations:[self generateAnnotations]];
            [activityView stop];
            activityView = nil;
        });
    });
}

-(void)refreshData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        AVQuery * query = [AVQuery queryWithClassName:@"News"];
        [query whereKey:@"is_published" equalTo:[NSNumber numberWithInt:1]];
        
        [query whereKey:@"location" nearGeoPoint:self.geoPoint withinKilometers:KILORANGE];
        query.limit = 50;      //获取最接近用户地点的50条数据
        NSArray* nearPlaces = [query findObjects];
        
        NSMutableArray *memosArray = [[NSMutableArray alloc] init];
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        for (AVObject * avObject in nearPlaces) {
            Memo *memo = [[Memo alloc] init];
            memo.createdAt = (NSDate *)[avObject objectForKey:@"updatedAt"];
            memo.title = (NSString *)[avObject objectForKey:@"title"];
            memo.content = (NSString *)[avObject objectForKey:@"content"];
            memo.like = (NSNumber *)[avObject objectForKey:@"like"];
            AVFile *imageFile = [avObject objectForKey:@"image"];
            if (imageFile != nil) {
                memo.image = [UIImage imageWithData:[imageFile getData]];
            }
            AVGeoPoint *geoPoint = [avObject objectForKey:@"location"];
            memo.latitude = [NSNumber numberWithDouble:[geoPoint latitude]];
            memo.longtitude = [NSNumber numberWithDouble:[geoPoint longitude]];
            memo.username = [avObject objectForKey:@"username"];
            [memosArray addObject:memo];
            
            MapItemInfoVO *vo = [[MapItemInfoVO alloc] init];
            vo.strLat = [NSString stringWithFormat:@"%f", [geoPoint latitude]];
            vo.strLon = [NSString stringWithFormat:@"%f", [geoPoint longitude]];
            vo.strTitle = (NSString *)[avObject objectForKey:@"title"];
            vo.strDetails = (NSString *)[avObject objectForKey:@"content"];
            
            NSMutableArray *childAry = [[NSMutableArray alloc] init];
            for (int i = 0; i < 2; i++) {
                MapItemInfoVO *child = [[MapItemInfoVO alloc] init];
                child.strId = [NSString stringWithFormat:@"%d", i];
                if (i == 0) {
                    child.strTitle = [NSString stringWithFormat:@"%d\n赞", [memo.like intValue]];
                } else if (i == 1) {
                    child.strTitle = [NSString stringWithFormat:@"%@", [BBSAPI dateToString:memo.createdAt]];
                }
                [childAry addObject:child];
            }
            vo.aryChild = childAry;
            
            if (imageFile != nil) {
                vo.image = [UIImage imageWithData:[imageFile getData]];
            } else {
                vo.image = [UIImage imageNamed:@"VideoIcon"];
            }
            
            [data addObject:vo];
        }
        self.avObjectArray = nearPlaces;
        self.topTenArray = memosArray;
        self.dataArray = data;
        
        appDelegate.myBBS.mapNewsArray = self.topTenArray;
        appDelegate.myBBS.mapAVObjectArray = self.avObjectArray;
        appDelegate.myBBS.mapPointArray = self.dataArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [newsMapView removeAnnotations:newsMapView.annotations];
            [newsMapView addAnnotations:[self generateAnnotations]];
            [activityView stop];
            activityView = nil;
        });
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [activityView stop];
    activityView = nil;
}

#pragma mark -
#pragma mark tableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identi = @"MapNewsTableViewCell";
    MapNewsTableViewCell * cell = (MapNewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MapNewsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.memo = [topTenArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingleMapNewsViewController * singleMapNewsViewController = [[SingleMapNewsViewController alloc] initWithRootNews:[avObjectArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:singleMapNewsViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AVObject * news = [avObjectArray objectAtIndex:indexPath.row];
    [news deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSMutableArray * newToptenArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [avObjectArray count]; i++) {
                if (i != indexPath.row) {
                    [newToptenArray addObject:[avObjectArray objectAtIndex:i]];
                }
            }
            appDelegate.myBBS.mapAVObjectArray = self.avObjectArray = newToptenArray;
            NSMutableArray *memosArray = [[NSMutableArray alloc] init];
            for (AVObject * avObject in newToptenArray) {
                Memo *memo = [[Memo alloc] init];
                memo.createdAt = (NSDate *)[avObject objectForKey:@"updatedAt"];
                memo.title = (NSString *)[avObject objectForKey:@"title"];
                memo.content = (NSString *)[avObject objectForKey:@"content"];
                memo.like = (NSNumber *)[avObject objectForKey:@"like"];
                AVFile *imageFile = [avObject objectForKey:@"image"];
                if (imageFile != nil) {
                    memo.image = [UIImage imageWithData:[imageFile getData]];
                }
                AVGeoPoint *geoPoint = [avObject objectForKey:@"location"];
                memo.latitude = [NSNumber numberWithDouble:[geoPoint latitude]];
                memo.longtitude = [NSNumber numberWithDouble:[geoPoint longitude]];
                memo.username = [avObject objectForKey:@"username"];
                [memosArray addObject:memo];
            }
            appDelegate.myBBS.mapNewsArray = self.topTenArray = memosArray;
            
            [customTableView.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"删除失败！";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.8];
        }
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AVObject * news = [avObjectArray objectAtIndex:indexPath.row];
    NSString * username = [news objectForKey:@"username"];
    AVUser * currentUser = [AVUser currentUser];
    if ([username isEqualToString:currentUser.username]) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [self refreshData];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark LOCATION

- (void)clickItemButton:(ItemView *)view
{
    SingleMapNewsViewController * singleMapNewsViewController = [[SingleMapNewsViewController alloc] initWithRootNews:[self.avObjectArray objectAtIndex:view.tag]];
    [self.navigationController pushViewController:singleMapNewsViewController animated:YES];
}

- (NSArray *)generateAnnotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.topTenArray count]; i++) {
        Memo * memo = [self.topTenArray objectAtIndex:i];
        PinAnnotation *pinAnno = [[PinAnnotation alloc] initWithLatitude:[memo.latitude doubleValue]  andLongitude:[memo.longtitude doubleValue]];
        pinAnno.tag = i;
        [annotations addObject:pinAnno];
    }
    return annotations;
}

#pragma mark  Range
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ([self.detailsAnnoArray count]>0) {
        DetailsAnnotation *first = [self.detailsAnnoArray objectAtIndex:0];
        PinAnnotationView *pV = (PinAnnotationView *)[mapView viewForAnnotation:self.pinAnnotation];
        DetailsAnnotationView *dV = (DetailsAnnotationView *)[mapView viewForAnnotation:first];
        [dV.superview bringSubviewToFront:dV];
        [pV.superview bringSubviewToFront:pV];
    }
    
    if (!self.detailsAnnotation) {
        return;
    }
    
    CGPoint pinPoint = [mapView convertCoordinate:self.detailsAnnotation.coordinate toPointToView:self.view];
    BOOL bContains  = CGRectContainsPoint(self.view.bounds, pinPoint);
    
    if (bContains) {
        DetailsAnnotationView *annoView = (DetailsAnnotationView *)[mapView viewForAnnotation:self.detailsAnnotation];
        CGPoint center = self.view.center;//[mapView convertCoordinate:_mapView.centerCoordinate toPointToView:self.view];
        CGFloat angle = [Utils getAngleByPoint:pinPoint center:center];
        [annoView.cell rotationViews:angle];
    }
    else{
        [newsMapView deselectAnnotation:self.pinAnnotation animated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    if ([self.detailsAnnoArray count]>0) {
        DetailsAnnotation *first = [self.detailsAnnoArray objectAtIndex:0];
        PinAnnotationView *pV = (PinAnnotationView *)[mapView viewForAnnotation:self.pinAnnotation];
        DetailsAnnotationView *dV = (DetailsAnnotationView *)[mapView viewForAnnotation:first];
        [dV.superview bringSubviewToFront:dV];
        [pV.superview bringSubviewToFront:pV];
    }
    
    if (self.detailsAnnotation) {
        CGPoint pinPoint = [mapView convertCoordinate:self.detailsAnnotation.coordinate toPointToView:self.view];
        BOOL bContains  = CGRectContainsPoint(self.view.bounds, pinPoint);
        if (!bContains) {
            [newsMapView deselectAnnotation:self.pinAnnotation animated:NO];
        }
    }
}

#pragma mark Annotation
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
	if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
        
        if (self.detailsAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            self.detailsAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        
        self.pinAnnotation = (PinAnnotation *)view.annotation;
        
        DetailsAnnotation *detailsAnno = [[DetailsAnnotation alloc]
                                          initWithLatitude:view.annotation.coordinate.latitude
                                          andLongitude:view.annotation.coordinate.longitude];
        
        detailsAnno.tag = self.pinAnnotation.tag;
        [mapView addAnnotation:detailsAnno];
        
        [self.detailsAnnoArray insertObject:detailsAnno atIndex:0];
        
        if (!self.detailsAnnotation) {
            self.detailsAnnotation = detailsAnno;
        }
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if ([self.detailsAnnoArray count] > 0) {
        DetailsAnnotation *last = [self.detailsAnnoArray lastObject];
        
        PinAnnotationView *pV = (PinAnnotationView *)[mapView viewForAnnotation:self.pinAnnotation];
        DetailsAnnotationView *dV = (DetailsAnnotationView *)[mapView viewForAnnotation:last];
        [dV.superview bringSubviewToFront:dV];
        [pV.superview bringSubviewToFront:pV];
        
        DetailsAnnotationView *annoView = (DetailsAnnotationView *)[mapView viewForAnnotation:last];
        [annoView.cell disappearItems:^{
            [mapView removeAnnotation:last];
            [self.detailsAnnoArray removeLastObject];
            
            if ([self.detailsAnnoArray count] > 0) {
                self.detailsAnnotation = [self.detailsAnnoArray objectAtIndex:0];
            } else {
                self.detailsAnnotation = nil;
            }
        }];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //层次次序
    PinAnnotationView *pV = (PinAnnotationView *)[mapView viewForAnnotation:self.pinAnnotation];
    DetailsAnnotationView *dV = (DetailsAnnotationView *)[mapView viewForAnnotation:self.detailsAnnotation];
    [dV.superview bringSubviewToFront:dV];
    [pV.superview bringSubviewToFront:pV];
}

//设置MKAnnotation上的annotationView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[DetailsAnnotation class]]) {
        DetailsAnnotation *anno = (DetailsAnnotation *)annotation;
        self.detailsAnnotation = anno;
        NSUInteger num = anno.tag;
        DetailsAnnotationView *annotationView =(DetailsAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"DetailsAnnotationView"];
        if (!annotationView) {
            annotationView = [[DetailsAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DetailsAnnotationView"];
        }
        annotationView.tag = num;
        MapItemInfoVO *vo = [self.dataArray objectAtIndex:num];
        [annotationView setCellUI:vo];
        
        CGPoint selectCenter =[mapView convertCoordinate:annotation.coordinate toPointToView:self.view];
        CGPoint center =self.view.center;
        CGFloat angle = [Utils getAngleByPoint:selectCenter center:center];
        CGPoint newCenter = CGPointMake(annotationView.cell.center.x - (annotationView.cell.bounds.size.width/2 * sin(angle)), annotationView.cell.center.y - (annotationView.cell.bounds.size.width/2 * cos(angle)));
        
        [annotationView.cell toAppearItemsView:newCenter angle:angle];
        [annotationView.cell setDetailsViewBlock:^(ItemView *btn) {
            [self clickItemButton:btn];
        }];
        
        return annotationView;
        
	} else if ([annotation isKindOfClass:[PinAnnotation class]]) {
        
        PinAnnotation *anno = (PinAnnotation *)annotation;
        NSUInteger num = anno.tag;
        PinAnnotationView *annotationView =(PinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotationView"];
        if (!annotationView) {
            annotationView = [[PinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotationView"];
        }
        annotationView.tag = num;
        return annotationView;
    }
	return nil;
}

@end
