//
//  MKMapView (MapViewUtil).h
//  ScenicGuide
//
//  Created by xf.lai on 13-8-1.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (double)getZoomLevel;
@end
