//
//  MapClassVC.m
//  Succorfish Installer App
//
//  Created by stuart watts on 14/03/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "MapClassVC.h"
#import "CustomAnnotationView.h"
#define span1 5000

@interface MapClassVC ()
{
    UIView * topView;
    BOOL isViewDetailsClicked;
    CustomAnnotationView* customMainLocation;
    CustomAnnotationView* customPing1;
    CustomAnnotationView* customPing2;
    CustomAnnotationView* customPing3;
    
    CustomAnnotation *annotationPin ;
    CustomAnnotation *annotationPin1 ;
    CustomAnnotation *annotationPin2 ;
    CustomAnnotation *annotationPin3 ;
}
@end

@implementation MapClassVC
@synthesize detailsDict,isfromLastWayPOint,isfromHistory;
- (void)viewDidLoad
{
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[APP_DELEGATE getbackgroundImage]];
    imgBack.userInteractionEnabled = YES;
    [self.view addSubview:imgBack];
    
    [self setNavigationViewFrames];
    [super viewDidLoad];
    
    if (![APP_DELEGATE isNetworkreachable])
    {
        [self CheckInternetError];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth-00, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"NetTag's location on Map"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize + 5]];
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
    
    UILabel * lblView = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, viewWidth, 54)];
    [lblView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
    [lblView setText:@" Tap here to see NetTag's location on Google map with direction."];
    [lblView setFont:[UIFont fontWithName:CGRegularItalic size:textSize + 2]];
    [lblView setTextColor:[UIColor whiteColor]];
    lblView.userInteractionEnabled = YES;
    [self.view addSubview:lblView];
    
    UIImageView * img = [[UIImageView alloc] init];
    img.frame = CGRectMake(viewWidth - 60, 5, 44, 44);
    img.image = [UIImage imageNamed:@"gps_direction.png"];
    [lblView addSubview:img];
    
    UIButton * btnMoreDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMoreDetail addTarget:self action:@selector(btnGpsDirectionClick) forControlEvents:UIControlEventTouchUpInside];
    btnMoreDetail.frame = CGRectMake(0, 0, viewWidth, 54);
    btnMoreDetail.backgroundColor = [UIColor clearColor];
    [lblView addSubview:btnMoreDetail];
    //    btnMoreDetail.hidden = true;
    
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
        [self setMainViewContent:64+54];
    }
    if (isfromHistory == true)
    {
        btnMoreDetail.hidden = false;
        
    }
}

-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)CheckInternetError
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert addButton:@"Google Map" withActionBlock:^{
        NSLog(@"Custom Font Button Pressed");
        // Put your action here
        
    }];
    alert.firstButtonCustomFont = [UIFont fontWithName:CGRegular size:textSize];
    [alert showAlertInView:self
                 withTitle:@"NetTag Recovery"
              withSubtitle:@"There is no internet connection. Tap on Google Map to see location on Goole Map"
           withCustomImage:[UIImage imageNamed:@"Subsea White 180.png"]
       withDoneButtonTitle:@"Cancel" andButtons:nil];
    
}
-(void)btnGpsDirectionClick
{
    double destLat = [[detailsDict valueForKey:@"final_lat"] doubleValue];
    double destLong = [[detailsDict valueForKey:@"final_long"] doubleValue];
    
    NSString *destinationString = [NSString stringWithFormat:@"https://maps.google.com/maps?q=%f,%f",destLat,destLong];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:destinationString]];
    
    
}
-(void)setMainViewContent:(int)yyHeight
{
    detailsMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, yyHeight, viewWidth, DEVICE_HEIGHT-yyHeight)];
    [detailsMap setMapType:MKMapTypeStandard];
    detailsMap.delegate = self;
    detailsMap.showsUserLocation = YES;
    [self.view addSubview:detailsMap];
    
    if (IS_IPHONE_X)
    {
        detailsMap.frame = CGRectMake(0, yyHeight, viewWidth, DEVICE_HEIGHT-yyHeight-45);
    }
    
    float currentLatitude = [[detailsDict valueForKey:@"final_lat"] floatValue];
    float currentLongitude =  [[detailsDict valueForKey:@"final_long"] doubleValue];
    
    CLLocationCoordinate2D pinlocation = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);;
    MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithCoordinate:pinlocation addressDictionary:nil];
    annotationPin = [[CustomAnnotation alloc] initWithPlacemark:mPlacemark];
    annotationPin.title = @"NetTag's Location";
    annotationPin.subtitle1 = @"sub titile" ;
    annotationPin.deviceImg = [UIImage imageNamed:@"logo.png"];;
    annotationPin.isfromAdd = @"NO";
    [detailsMap addAnnotation:annotationPin];
    
    CLLocation *locationCord = [[CLLocation alloc] initWithLatitude:currentLatitude longitude:currentLongitude];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
    ([locationCord coordinate], 1000, 1000);
    [detailsMap setRegion:region animated:YES];
    
    
    float currentLatitude1 = [[detailsDict valueForKey:@"step1_lat"] floatValue];
    float currentLongitude1 =  [[detailsDict valueForKey:@"step1_long"] floatValue];
    
    CLLocationCoordinate2D pinlocation1 = CLLocationCoordinate2DMake(currentLatitude1,currentLongitude1);;
    MKPlacemark *mPlacemark1 = [[MKPlacemark alloc] initWithCoordinate:pinlocation1 addressDictionary:nil];
    annotationPin1 = [[CustomAnnotation alloc] initWithPlacemark:mPlacemark1];
    annotationPin1.title = @"Ping1's Location";
    annotationPin1.subtitle1 = @"sub titile" ;
    annotationPin1.deviceImg = [UIImage imageNamed:@"logo.png"];;
    annotationPin1.isfromAdd = @"NO";
    [detailsMap addAnnotation:annotationPin1];
    
    float currentLatitude2 = [[detailsDict valueForKey:@"step2_lat"] floatValue];
    float currentLongitude2 =  [[detailsDict valueForKey:@"step2_long"] floatValue];
    
    CLLocationCoordinate2D pinlocation2 = CLLocationCoordinate2DMake(currentLatitude2,currentLongitude2);;
    MKPlacemark *mPlacemark2 = [[MKPlacemark alloc] initWithCoordinate:pinlocation2 addressDictionary:nil];
    annotationPin2 = [[CustomAnnotation alloc] initWithPlacemark:mPlacemark2];
    annotationPin2.title = @"Ping2's Location";
    annotationPin2.subtitle1 = @"sub titile" ;
    annotationPin2.deviceImg = [UIImage imageNamed:@"logo.png"];;
    annotationPin2.isfromAdd = @"NO";
    [detailsMap addAnnotation:annotationPin2];
    
    
    float currentLatitude3 = [[detailsDict valueForKey:@"step3_lat"] floatValue];
    float currentLongitude3 =  [[detailsDict valueForKey:@"step3_long"] floatValue];
    
    CLLocationCoordinate2D pinlocation3 = CLLocationCoordinate2DMake(currentLatitude3,currentLongitude3);;
    MKPlacemark *mPlacemark3 = [[MKPlacemark alloc] initWithCoordinate:pinlocation3 addressDictionary:nil];
    annotationPin3 = [[CustomAnnotation alloc] initWithPlacemark:mPlacemark3];
    annotationPin3.title = @"Ping3's Location";
    annotationPin3.subtitle1 = @"sub titile" ;
    annotationPin3.deviceImg = [UIImage imageNamed:@"logo.png"];;
    annotationPin3.isfromAdd = @"NO";
    [detailsMap addAnnotation:annotationPin3];
    
    if (![APP_DELEGATE isNetworkreachable])
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
        [alert addButton:@"Google Map" withActionBlock:^{
            NSLog(@"Custom Font Button Pressed");
            // Put your action here
            
        }];
        alert.firstButtonCustomFont = [UIFont fontWithName:CGRegular size:textSize];
        [alert showAlertInView:self
                     withTitle:@"NetTag Recovery"
                  withSubtitle:@"There is no internet connection. Tap on Google Map to see location on Goole Map"
               withCustomImage:[UIImage imageNamed:@"Subsea White 180.png"]
           withDoneButtonTitle:@"Cancel" andButtons:nil];
        
        //        return;
    }
    
}
-(void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    if([views count]>0)
    {
        MKAnnotationView *annotationView = [views objectAtIndex:0];
        if (annotationView)
        {
            id <MKAnnotation> mp = [annotationView annotation];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
            ([mp coordinate], 1000, 1000);
            if (region.center.latitude > -89 && region.center.latitude < 89 && region.center.longitude > -179 && region.center.longitude < 179 )
            {
                //                [mv setRegion:region animated:YES];
                //                [mv selectAnnotation:mp animated:YES];
            }
        }
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        MKPinAnnotationView *pin = (MKPinAnnotationView *) [detailsMap dequeueReusableAnnotationViewWithIdentifier: @"pin"];
        pin.image = [UIImage imageNamed:@"UserPin.png"];
        return nil;
    }
    else if ([annotation isKindOfClass:[CustomAnnotation class]])
    {
        static NSString * const identifier = @"CustomAnnotation";
        
        if (annotation == annotationPin)
        {
            customMainLocation = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            if (customMainLocation)
            {
                customMainLocation.annotation = annotation;
                
            }
            else
            {
                customMainLocation = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                
            }
            customMainLocation.canShowCallout = NO;
            customMainLocation.image = [UIImage imageNamed:@"mappin"];
            customMainLocation.title = [APP_DELEGATE checkforValidString:[detailsDict valueForKey:@"name"]];
            customMainLocation.subtitle1 = [NSString stringWithFormat:@"lat : %@ , long : %@",[detailsDict valueForKey:@"final_lat"],[detailsDict valueForKey:@"final_long"]];
            customMainLocation.deviceImg = [UIImage imageNamed:@"logoDisplay.png"];;
            customMainLocation.img = @"NA";
            [customMainLocation reloadInputViews];
            
            return customMainLocation;
            
        }
        else if (annotation == annotationPin1)
        {
            customPing1 = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            if (customPing1)
            {
                customPing1.annotation = annotation;
                
            }
            else
            {
                customPing1 = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                
            }
            
            customPing1.canShowCallout = NO;
            customPing1.image = [UIImage imageNamed:@"ping1.png"];
            customPing1.title = @"Ping 1";
            customPing1.subtitle1 = [NSString stringWithFormat:@"latitude : %@, longitude : %@",[detailsDict valueForKey:@"step1_lat"],[detailsDict valueForKey:@"step1_long"]];
            customPing1.deviceImg = [UIImage imageNamed:@"logoDisplay.png"];;
            customPing1.img = @"NA";
            [customPing1 reloadInputViews];
            
            
            return customPing1;
        }
        else if (annotation == annotationPin2)
        {
            customPing2 = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            if (customPing2)
            {
                customPing2.annotation = annotation;
                
            }
            else
            {
                customPing2 = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                
            }
            
            customPing2.canShowCallout = NO;
            customPing2.image = [UIImage imageNamed:@"ping2.png"];
            customPing2.title = @"Ping 2";
            customPing2.subtitle1 = [NSString stringWithFormat:@"latitude : %@, longitude : %@",[detailsDict valueForKey:@"step2_lat"],[detailsDict valueForKey:@"step2_long"]];
            customPing2.deviceImg = [UIImage imageNamed:@"logoDisplay.png"];;
            customPing2.img = @"NA";
            [customPing2 reloadInputViews];
            
            
            return customPing2;
        }
        else if (annotation == annotationPin3)
        {
            customPing3 = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            if (customPing3)
            {
                customPing3.annotation = annotation;
                
            }
            else
            {
                customPing3 = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                
            }
            
            customPing3.canShowCallout = NO;
            customPing3.image = [UIImage imageNamed:@"ping3.png"];
            customPing3.title = @"Ping 3";
            customPing3.subtitle1 = [NSString stringWithFormat:@"latitude : %@, longitude : %@",[detailsDict valueForKey:@"step3_lat"],[detailsDict valueForKey:@"step3_long"]];
            customPing3.deviceImg = [UIImage imageNamed:@"logoDisplay.png"];;
            customPing3.img = @"NA";
            [customPing3 reloadInputViews];
            return customPing3;
        }
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event
{
    isViewDetailsClicked = false;
    topView.hidden = true;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 -(void)btnMoreDetailClicked
 {
 if (isViewDetailsClicked == false)
 {
 isViewDetailsClicked = true;
 [topView removeFromSuperview];
 topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, 85)];
 [topView setBackgroundColor:[UIColor clearColor]];
 topView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
 [self.view addSubview:topView];
 
 
 
 UILabel * lblStep1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 25)];
 [lblStep1 setBackgroundColor:[UIColor clearColor]];
 [lblStep1 setText:@"Step 1 : 200meters"];
 [lblStep1 setTextAlignment:NSTextAlignmentLeft];
 [lblStep1 setFont:[UIFont fontWithName:CGRegular size:17]];
 [lblStep1 setTextColor:[UIColor whiteColor]];
 [topView addSubview:lblStep1];
 
 CGFloat boldTextFontSize = 18;
 NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:lblStep1.text];
 [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,8)];
 [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:boldTextFontSize] range:NSMakeRange(0,8)];
 [lblStep1 setAttributedText:string];
 
 
 UILabel * lblStep2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 25)];
 [lblStep2 setBackgroundColor:[UIColor clearColor]];
 [lblStep2 setText:@"Step 2 : 200meters"];
 [lblStep2 setTextAlignment:NSTextAlignmentLeft];
 [lblStep2 setFont:[UIFont fontWithName:CGRegular size:17]];
 [lblStep2 setTextColor:[UIColor whiteColor]];
 [topView addSubview:lblStep2];
 
 NSMutableAttributedString * string2 = [[NSMutableAttributedString alloc]initWithString:lblStep2.text];
 [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,8)];
 [string2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:boldTextFontSize] range:NSMakeRange(0,8)];
 [lblStep2 setAttributedText:string2];
 
 UILabel * lblStep3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 200, 25)];
 [lblStep3 setBackgroundColor:[UIColor clearColor]];
 [lblStep3 setText:@"Step 3 : 200meters"];
 [lblStep3 setTextAlignment:NSTextAlignmentLeft];
 [lblStep3 setFont:[UIFont fontWithName:CGRegular size:17]];
 [lblStep3 setTextColor:[UIColor whiteColor]];
 [topView addSubview:lblStep3];
 
 NSMutableAttributedString * string3 = [[NSMutableAttributedString alloc]initWithString:lblStep3.text];
 [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,8)];
 [string3 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:boldTextFontSize] range:NSMakeRange(0,8)];
 [lblStep3 setAttributedText:string3];
 
 UILabel * lblLat = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-210, 5, 210, 25)];
 [lblLat setBackgroundColor:[UIColor clearColor]];
 [lblLat setText:@"Latitude : 235.123412°"];
 [lblLat setTextAlignment:NSTextAlignmentLeft];
 [lblLat setFont:[UIFont fontWithName:CGRegular size:17]];
 [lblLat setTextColor:[UIColor whiteColor]];
 [topView addSubview:lblLat];
 
 NSMutableAttributedString * string4 = [[NSMutableAttributedString alloc]initWithString:lblLat.text];
 [string4 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,10)];
 [string4 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:boldTextFontSize] range:NSMakeRange(0,10)];
 [lblLat setAttributedText:string4];
 
 UILabel * lblLong = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-210, 30, 210, 25)];
 [lblLong setBackgroundColor:[UIColor clearColor]];
 [lblLong setText:@"Longitude : 253.343421°"];
 [lblLong setTextAlignment:NSTextAlignmentLeft];
 [lblLong setFont:[UIFont fontWithName:CGRegular size:17]];
 [lblLong setTextColor:[UIColor whiteColor]];
 [topView addSubview:lblLong];
 
 NSMutableAttributedString * string5 = [[NSMutableAttributedString alloc]initWithString:lblLong.text];
 [string5 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,10)];
 [string5 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:boldTextFontSize] range:NSMakeRange(0,11)];
 [lblLong setAttributedText:string5];
 
 
 UILabel * lblDirection = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-210, 55, 175, 25)];
 [lblDirection setBackgroundColor:[UIColor clearColor]];
 [lblDirection setText:@"Direction NE 20°"];
 [lblDirection setTextAlignment:NSTextAlignmentLeft];
 [lblDirection setFont:[UIFont fontWithName:CGRegular size:17]];
 [lblDirection setTextColor:[UIColor whiteColor]];
 [topView addSubview:lblDirection];
 
 
 UIButton * btnCalculate = [UIButton buttonWithType:UIButtonTypeCustom];
 [btnCalculate addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
 btnCalculate.frame = CGRectMake((viewWidth/2)-75, (topView.frame.size.height/2)-25, 150, 50);
 btnCalculate.backgroundColor = [UIColor clearColor];
 [btnCalculate setTitle:@"calculate" forState:UIControlStateNormal];
 [btnCalculate setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
 [topView addSubview:btnCalculate];
 btnCalculate.layer.cornerRadius = 20;
 btnCalculate.layer.borderColor = UIColor.whiteColor.CGColor;
 btnCalculate.layer.borderWidth = 1;
 btnCalculate.titleLabel.font = [UIFont fontWithName:CGRegular size:22];
 }
 else
 {
 isViewDetailsClicked = false;
 topView.hidden = true;
 }
 
 
 }
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
