//
//  CompassViewController.m
//  SensorDemo
//
//  Created by  on 2017/7/26.
//  Copyright © 2017年 http://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "CompassViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

#import "ScaleView.h"

@interface CompassViewController ()<CLLocationManagerDelegate>
{
    ScaleView * _scaView;
    UILabel * _directionLabel;
    UILabel * _angleLabel;
    UILabel * _positionLabel;
    UILabel * _latitudlongitudeLabel;
    int viewWidth,headerhHeight;
}
//location information
@property(nonatomic, strong)  CLLocation *currLocation;

@property(strong,nonatomic)CLLocationManager *locationManager;

@end

@implementation CompassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    viewWidth = DEVICE_WIDTH;
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:@"Ipadright_bg.png"];
    [self.view addSubview:imgBack];
    
    headerhHeight = 64;
    if (IS_IPAD)
    {
        headerhHeight = 64;
        viewWidth = 704;
        imgBack.frame = CGRectMake(0, 0, 704, DEVICE_HEIGHT);
        imgBack.image = [UIImage imageNamed:@"right_bg.png"];
    }
    else
    {
        headerhHeight = 64;
        if (IS_IPHONE_X)
        {
            headerhHeight = 88;
        }
        viewWidth = DEVICE_WIDTH;
        imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    }
    self.navigationItem.title = @"COMPASS";
    
    [self setupUI];
    
//    [self createLocationManager];
    
}

- (void)setupUI{
    
    _scaView = [[ScaleView alloc] initWithFrame:CGRectMake(0, 0, viewWidth- 30, viewWidth- 30)];
    _scaView.center = CGPointMake(viewWidth/2, viewWidth/2);
    _scaView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scaView];
    
//    _angleLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2 - 100, _scaView.frame.size.height + _scaView.frame.origin.y, 100, 100)];
//    _angleLabel.font = [UIFont systemFontOfSize:30];
//    _angleLabel.textAlignment = NSTextAlignmentCenter;
//    _angleLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:_angleLabel];
//
//    _directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2, _angleLabel.frame.origin.y, 50, 50)];
//    _directionLabel.font = [UIFont systemFontOfSize:15];
//    _directionLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:_directionLabel];
//
//    _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2, _angleLabel.frame.origin.y + _directionLabel.frame.size.height, viewWidth/2, 70)];
//    _positionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    _positionLabel.numberOfLines = 3;
//    _positionLabel.font = [UIFont systemFontOfSize:15];
//    _positionLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:_positionLabel];
//
//    _latitudlongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _positionLabel.frame.origin.y + _positionLabel.frame.size.height, viewWidth, 30)];
//    _latitudlongitudeLabel.font = [UIFont systemFontOfSize:16];
//    _latitudlongitudeLabel.textAlignment = NSTextAlignmentCenter;
//    _latitudlongitudeLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:_latitudlongitudeLabel];
    
}


//Create an initialization positioning device
- (void)createLocationManager{
    
    //attention  // Pay attention to open the location service of the mobile phone, where the privacy
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    self.locationManager.delegate=self;
    //  Positioning frequency, once every several meters
    // Distance to the filter, after a few meters of movement, will trigger the positioning of the proxy function
    self.locationManager.distanceFilter = 0;
    
    // The more accurate the positioning, the more accurate the power consumption
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//navigation
    
    //Request to allow authorization for user location at the front desk
    [self.locationManager requestWhenInUseAuthorization];
    
    //Allow background location updates, blue bars flash into the background
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
    //Determine whether the positioning device can use and can obtain navigation data
    if ([CLLocationManager locationServicesEnabled]&&[CLLocationManager headingAvailable]){
        
        [self.locationManager startUpdatingLocation];//Open location service
        [self.locationManager startUpdatingHeading];//Start getting heading data
        
    }
    else{
        NSLog(@"Cannot get heading data");
    }
    
}

#pragma mark---与导航有关方法

#pragma mark - CLLocationManagerDelegate
// Callback method after successful positioning, as long as the location changes, it will call this method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    
    self.currLocation = [locations lastObject];
    
    //Latitude and longitude
    NSString * latitudeStr = [NSString stringWithFormat:@"%3.2f",
                              _currLocation.coordinate.latitude];
    //longitude
    NSString * longitudeStr  = [NSString stringWithFormat:@"%3.2f",
                                _currLocation.coordinate.longitude];
    //height
    NSString * altitudeStr  = [NSString stringWithFormat:@"%3.2f",
                               _currLocation.altitude];
    
    NSLog(@"Latitude：%@  Longitude：%@  Altitude：%@", latitudeStr, longitudeStr, altitudeStr);
    
    _latitudlongitudeLabel.text = [NSString stringWithFormat:@"Latitude：%@  Longitude：%@  Altitude：%@", latitudeStr, longitudeStr, altitudeStr];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:self.currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           
                           NSString *street = [addressDictionary
                                               objectForKey:(NSString *)kABPersonAddressStreetKey];
                           street = street == nil ? @"": street;
                           
                           NSString *country = placemark.country;
                           
                           NSString * subLocality = placemark.subLocality;
                           
                           NSString *city = [addressDictionary
                                             objectForKey:(NSString *)kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           
                           NSLog(@"%@",[NSString stringWithFormat:@"%@ \n%@ \n%@  %@ ",country, city,subLocality ,street]);
                           
                           _positionLabel.text = [NSString stringWithFormat:@" %@\n %@ %@%@ " ,country, city,subLocality ,street];
                           
                       }
                       
                   }];
}

//Obtain geographic and geomagnetic heading data to rotate geographical scales
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
// Get current device
    UIDevice *device =[UIDevice currentDevice];
    
    //   Judging whether the magnetometer is valid, negative when it is invalid, the smaller the more accurate
    if (newHeading.headingAccuracy>0)
    {
        //Geomagnetic heading data-》magneticHeading
        float magneticHeading =[self heading:newHeading.magneticHeading fromOrirntation:device.orientation];
        
        //Geographical heading data-》trueHeading
        float trueHeading =[self heading:newHeading.trueHeading fromOrirntation:device.orientation];
        
        // Geomagnetic North
        float heading = -1.0f *M_PI *newHeading.magneticHeading /180.0f;
        _angleLabel.text = [NSString stringWithFormat:@"%3.1f°",magneticHeading];
        
        //Rotation transformation
        [_scaView resetDirection:heading];
        
        [self updateHeading:newHeading];
        
    }
    
    
}

//Return current cell phone (camera) orientation
- (void)updateHeading:(CLHeading *)newHeading{
    
    CLLocationDirection  theHeading = ((newHeading.magneticHeading > 0) ?
                                       newHeading.magneticHeading : newHeading.trueHeading);
    
    int angle = (int)theHeading;
    
    switch (angle) {
        case 0:
            _directionLabel.text = @"north";
            break;
        case 90:
            _directionLabel.text = @"east";
            break;
        case 180:
            _directionLabel.text = @"south";
            break;
        case 270:
            _directionLabel.text = @"oo";
            break;
            
        default:
            break;
    }
    if (angle > 0 && angle < 90) {
        _directionLabel.text = @"northeast";
    }else if (angle > 90 && angle < 180){
        _directionLabel.text = @"southeast";
    }else if (angle > 180 && angle < 270){
        _directionLabel.text = @"southwest";
    }else if (angle > 270 ){
        _directionLabel.text = @"northwest";
    }
}


-(float)heading:(float)heading fromOrirntation:(UIDeviceOrientation)orientation{
    
    float realHeading =heading;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            realHeading=heading-180.0f;
            break;
        case UIDeviceOrientationLandscapeLeft:
            realHeading=heading+90.0f;
            break;
        case UIDeviceOrientationLandscapeRight:
            realHeading=heading-90.0f;
            break;
        default:
            break;
    }
    if (realHeading>360.0f)
    {
        realHeading-=360.0f;
    }
    else if (realHeading<0.0f)
    {
        realHeading+=360.0f;
    }
    return  realHeading;
}

//Determine if the device needs to be checked and it is interfered by foreign magnetic field
-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
    
}


- (void)dealloc{
    
    [self.locationManager stopUpdatingHeading];// Stop getting heading data, save power
    
    self.locationManager.delegate=nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    [self.locationManager stopUpdatingHeading];//// Stop getting heading data, save power
    
    self.locationManager.delegate=nil;
    
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
