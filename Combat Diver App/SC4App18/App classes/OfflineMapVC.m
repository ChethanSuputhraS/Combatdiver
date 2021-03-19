//
//  OfflineMapVC.m
//  SC4App18
//
//  Created by stuart watts on 11/12/2019.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "OfflineMapVC.h"
#import "MyAnnotation.h"

#define span1 5000

@interface OfflineMapVC ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *mapView;
    MKCircle *_radialCircle;
    CLLocation *_location;
    double radiusValue;
    MKPointAnnotation * annotation1, * annotationCurrent;
    int viewWidth;
}
@end

@implementation OfflineMapVC

- (void)viewDidLoad
{
    if (IS_IPAD)
    {
        viewWidth = 704;
    }
    else
    {
        viewWidth = DEVICE_WIDTH;
    }
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[APP_DELEGATE getbackgroundImage]];
    imgBack.userInteractionEnabled = YES;
    [self.view addSubview:imgBack];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initializeLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//ignored when significant location changes
    locationManager.activityType = CLActivityTypeAutomotiveNavigation; //I'm an active person!
    [locationManager startUpdatingLocation];
    locationManager.pausesLocationUpdatesAutomatically = YES; //'more coal!!' as my friend says
    //[locationManager startMonitoringSignificantLocationChanges];
    //CLRegion * ... hang on! it is deprecated, use this:
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(123, 12)
                                                                 radius:120 identifier:@"my region"];
    [locationManager startMonitoringForRegion:region]; //watch dog has been set
    // }
}
#pragma mark - Set Frames
-(void)setNavigationViewFrames
{
    if (IS_IPAD)
    {
        viewWidth = 704;
    }
    else
    {
        viewWidth = DEVICE_WIDTH;
    }
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, viewWidth-100, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Location on Map"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:17]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIImageView * backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12+20, 12, 20)];
    [backImg setImage:[UIImage imageNamed:@"back_icon.png"]];
    [backImg setContentMode:UIViewContentModeScaleAspectFit];
    backImg.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:backImg];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(0, 0, 140, 64);
    btnBack.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnBack];
    
    if (IS_IPHONE_X)
    {
        viewHeader.frame = CGRectMake(0, 0, viewWidth, 88);
        lblTitle.frame = CGRectMake(50, 40, viewWidth-100, 44);
        backImg.frame = CGRectMake(10, 12+44, 12, 20);
        btnBack.frame = CGRectMake(0, 0, 70, 88);
        [self setMainViewContent:88];
    }
    else
    {
        [self setMainViewContent:64];
    }
}
-(void)setMainViewContent:(int)yyHeight
{
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, yyHeight, viewWidth, DEVICE_HEIGHT-yyHeight)];
    [mapView setMapType:MKMapTypeStandard];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    
    if (IS_IPHONE_X)
    {
        mapView.frame = CGRectMake(0, yyHeight, viewWidth, DEVICE_HEIGHT-yyHeight-45);
    }
}
- (void)addRectangleToMap {
    CLLocationCoordinate2D points[4];
    points[0] = CLLocationCoordinate2DMake(10, 10);
    points[1] = CLLocationCoordinate2DMake(10, 20);
    points[2] = CLLocationCoordinate2DMake(20, 20);
    points[3] = CLLocationCoordinate2DMake(20, 10);
    
    MKPolygon *poly = [MKPolygon polygonWithCoordinates:points count:4];
    poly.title = @"Some title";
    
    [mapView addOverlay:poly];
}

- (void)addAnnotations {
    [mapView addAnnotation:[[MyAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(22.3048726, 70.7721573) andTitle:@"wow"]];//22.3048726,70.7721573
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(22.3048726, 70.7721573);
    
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,2000 ,2000);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:region];
    [mapView setRegion:adjustedRegion animated:YES];
    
}
#pragma mark - Core Location delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [[locations firstObject] description]);
    //[mapView setCenterCoordinate:((CLLocation *) [locations firstObject]).coordinate animated:YES];
    //[mapView setRegion:MKCoordinateRegionMake(((CLLocation *) [locations firstObject]).coordinate, MKCoordinateSpanMake(.5, .5))];
    //[locationManager stopUpdatingLocation];//important, enough!
    //locationManager.heading;    <-- what it gives? location.course?
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"pause");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    // on entering any of the monitored region
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //on exiting any of the monitored region
}

#pragma mark - MapKit delegate methods
- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *AnnotationIdentifier = @"MyAnnotation";
    MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        pinView.canShowCallout = YES;
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

//before iOS 7 it was - (MKOverlayView *)mapView:(MKMapView *)_mapView viewForOverlay:(id <MKOverlay>)overlay {
- (MKOverlayRenderer *)mapView:(MKMapView *)_mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolygonRenderer *line = nil;
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        //previously MKPolygonView
        line = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *) overlay];
        line.strokeColor = [UIColor redColor];
        line.lineWidth = 1;
    }
    return line;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
