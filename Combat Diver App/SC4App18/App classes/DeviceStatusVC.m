//
//  DeviceStatusVC.m
//  SC4App18
//
//  Created by srivatsa s pobbathi on 06/12/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "DeviceStatusVC.h"
#import "DeviceMap.h"
#import "MapClassVC.h"

#import <QuartzCore/QuartzCore.h>
#import "KPTrilaterator.h"
@interface DeviceStatusVC ()<UIScrollViewDelegate,FCAlertViewDelegate>
{
    UIBezierPath *path;
    CAShapeLayer *pathLayer;
    CABasicAnimation *pathAnimation;
    UIButton * btnPing,*btnPing2,*btnPing3,* btnCalculate;

    BOOL isReturns, isRequestResponsed;
    int stepType, headerhHeight, viewWidth, heightttt, locatedID;
    NSTimer * requestTimeout;
    NSMutableDictionary * dictDetail;
    UIScrollView * myScrollview;
    NSMutableArray * arrContacts;
    FCAlertView * autoAlert;
}

@end

@implementation DeviceStatusVC
@synthesize previousDict;

- (void)viewDidLoad
{
    stepType = 1;
    locatedID = -1;
    dictDetail = [[NSMutableDictionary alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[APP_DELEGATE getbackgroundImage]];
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
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, headerhHeight)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewWidth,headerhHeight)];
    lblBack.backgroundColor = [UIColor blackColor];
    lblBack.alpha = 0.4;
    [viewHeader addSubview:lblBack];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Diver 1"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIImageView * backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20+(headerhHeight-20-20)/2, 12, 20)];
    [backImg setImage:[UIImage imageNamed:@"back_icon.png"]];
    [backImg setContentMode:UIViewContentModeScaleAspectFit];
    backImg.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:backImg];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(0, 0, 100 + 40, headerhHeight);
    btnBack.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnBack];
    
    if (IS_IPHONE_X)
    {
        viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
        lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
        backImg.frame = CGRectMake(10, 12+44, 12, 20);
        btnBack.frame = CGRectMake(0, 0, 70, 88);
    }
    [self setupMainContentView:headerhHeight+44+16];
    

    arrContacts = [[NSMutableArray alloc] init];
    [[DataBaseManager dataBaseManager] execute:@"Select * from NewContact" resultsArray:arrContacts];
    
    dictDetail = [[NSMutableDictionary alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setupMainContentView:(int)headerHeights
{
    heightttt = headerHeights;
    myScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, viewWidth, DEVICE_HEIGHT-64)];
    myScrollview.backgroundColor = UIColor.clearColor;
    myScrollview.contentSize = CGSizeMake(viewWidth*3, DEVICE_HEIGHT);
    myScrollview.scrollEnabled = false;
    [self.view addSubview:myScrollview];
    
    int yy = 1;

    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 213)];
    [myScrollview addSubview:view1];
    
    UILabel * lblStep1Desc = [[UILabel alloc] initWithFrame:CGRectMake(0, yy, viewWidth, 50)];
    [self setDescLabelProperties:lblStep1Desc];
    [lblStep1Desc setText:@" Step 1 : Tap on Ping button to get the distance of the Diver"];
    [view1 addSubview:lblStep1Desc];
    
    btnPing = [[UIButton alloc]initWithFrame:CGRectMake((viewWidth-100)/2, 81, 100, 100)];
    btnPing.tag = 1;
    [self setPingButtonproperties:btnPing];
    [btnPing setBackgroundImage:[UIImage imageNamed:@"PingGreen.png"] forState:UIControlStateNormal];
    btnPing.enabled = true;
    [view1 addSubview:btnPing];
    
    lblLatLong1 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-250, view1.frame.size.height-124, 240, 60)];
    [self setOtherLabelProperties:lblLatLong1 withText:@"Lat / Long : NA"];
    lblLatLong1.numberOfLines=0;
    [view1 addSubview:lblLatLong1];

    lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-70, viewWidth-5, 30)];
    [self setOtherLabelProperties:lblStatus withText:@"Status : Pening"];
    [view1 addSubview:lblStatus];
    
    lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-44, viewWidth-5, 44)];
    [self setOtherLabelProperties:lblDistance withText:@"Distance : --"];
    [view1 addSubview:lblDistance];
    
    animateView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 250, 150)];
    [view1 addSubview:animateView1];
    [self setAnimatedLabelwithView:animateView1];

    yy = yy+213;
    
    UILabel * lblLine = [[UILabel alloc]initWithFrame:CGRectMake(0, yy, viewWidth, 1)];
    lblLine.backgroundColor = UIColor.whiteColor;
    [myScrollview addSubview:lblLine];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, yy, viewWidth, 213)];
    [myScrollview addSubview:view2];

    UILabel * lblStep2Desc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    [self setDescLabelProperties:lblStep2Desc];
    [lblStep2Desc setText:@" Step 2 : Now move 200 meters away in 90 degree & Tap on Ping button."];
    [view2 addSubview:lblStep2Desc];
    
    btnPing2 = [[UIButton alloc]initWithFrame:CGRectMake((viewWidth-100)/2, 81, 100, 100)];
    btnPing2.tag = 2;
    [self setPingButtonproperties:btnPing2];
    [view2 addSubview:btnPing2];
    
    lblLatLong2 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-250, view2.frame.size.height-124, 240, 60)];
    [self setOtherLabelProperties:lblLatLong2 withText:@"Lat / Long : NA"];
    lblLatLong2.numberOfLines = 0;
    [view2 addSubview:lblLatLong2];

    lblStatus2 = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-70, viewWidth-5, 30)];
    [self setOtherLabelProperties:lblStatus2 withText:@"Status : Pending"];
    [view2 addSubview:lblStatus2];
    
    lblDistance2 = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-44, viewWidth-5, 44)];
    [self setOtherLabelProperties:lblDistance2 withText:@"Distance : --"];
    [view2 addSubview:lblDistance2];
    
    animateView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 250, 150)];
    [view2 addSubview:animateView2];
    [self setAnimatedLabelwithView:animateView2];
    
    lblHint2Up = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 100, 75)];
    [self setHinLabel:lblHint2Up withText:@"Move 200 meter this way!"];
    [animateView2 addSubview:lblHint2Up];
    
    lblOr1 = [[UILabel alloc] initWithFrame:CGRectMake(0,65, 120, 20)];
    [self setHinLabel:lblOr1 withText:@"OR!"];
    [animateView2 addSubview:lblOr1];
    
    lblHint2Down = [[UILabel alloc] initWithFrame:CGRectMake(5,75, 100, 75)];
    [self setHinLabel:lblHint2Down withText:@"Move 200 meter this way!"];
    [animateView2 addSubview:lblHint2Down];

    yy = yy+213;

    UILabel *  lblLine2 = [[UILabel alloc]initWithFrame:CGRectMake(0, yy, viewWidth, 1)];
    lblLine2.backgroundColor = UIColor.whiteColor;
    [myScrollview addSubview:lblLine2];
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, yy, viewWidth, 213)];
    [myScrollview addSubview:view3];

    UILabel * lblStep3Desc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    [self setDescLabelProperties:lblStep3Desc];
    [lblStep3Desc setText:@" Step 3 : Now move 200 meter at right angle and Press Ping button."];
    [view3 addSubview:lblStep3Desc];
    
    btnPing3 = [[UIButton alloc]initWithFrame:CGRectMake((viewWidth-100)/2, 81, 100, 100)];
    btnPing3.tag = 3;
    [self setPingButtonproperties:btnPing3];
    [view3 addSubview:btnPing3];
    
    lblLatLong3 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-250, view3.frame.size.height-124, 240, 60)];
    [self setOtherLabelProperties:lblLatLong3 withText:@"Lat / Long : NA"];
    lblLatLong3.numberOfLines = 0;
    [view3 addSubview:lblLatLong3];

    lblStatus3 = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-70, viewWidth-5, 30)];
    [self setOtherLabelProperties:lblStatus3 withText:@"Status : Pending"];
    [view3 addSubview:lblStatus3];
    
    lblDistance3 = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-44, viewWidth-5, 44)];
    [self setOtherLabelProperties:lblDistance3 withText:@"Distance : --"];
    [view3 addSubview:lblDistance3];
    
    animateView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 250, 150)];
    [view3 addSubview:animateView3];
    [self setAnimatedLabelwithView:animateView3];
    
    lblHin3Right = [[UILabel alloc] initWithFrame:CGRectMake(5,75, 100, 75)];
    [self setHinLabel:lblHin3Right withText:@"Move 200 meter this way!"];
    [animateView3 addSubview:lblHin3Right];
    
    lblOr2 = [[UILabel alloc] initWithFrame:CGRectMake(65,100, 120, 20)];
    [self setHinLabel:lblOr2 withText:@"OR!"];
    [animateView3 addSubview:lblOr2];
    
    lblHin3Left = [[UILabel alloc] initWithFrame:CGRectMake(150,75, 100, 75)];
    [self setHinLabel:lblHin3Left withText:@"Move 200 meter this way!"];
    [animateView3 addSubview:lblHin3Left];

    yy = yy+200;

    /*UILabel * lblLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, yy, viewWidth, 1)];
    lblLine3.backgroundColor = UIColor.whiteColor;
    [myScrollview addSubview:lblLine3];*/
    
    btnCalculate = [[UIButton alloc]init];
    btnCalculate.frame = CGRectMake(0, DEVICE_HEIGHT-60, viewWidth, 60);
    btnCalculate.backgroundColor = UIColor.blackColor;
    [btnCalculate setTitle:@"Calculate" forState:UIControlStateNormal];
    btnCalculate.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize+2];
    [btnCalculate setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnCalculate addTarget:self action:@selector(btnCalculateClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCalculate];
    btnCalculate.enabled = false;
    
    animateView1.hidden = NO;
    animateView2.hidden = YES;
    animateView3.hidden = YES;
    [timer1 invalidate];
    timer1 = nil;
    timer1 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(lineAnimationforPing2) userInfo:nil repeats:YES];
}

#pragma mark - Button EVent
-(void)btnBackClick
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self tempMethod];
}
-(void)btnPingClicked:(id)sender
{
    if (globalPeripheral.state != CBPeripheralStateConnected)
    {
        [autoAlert removeFromSuperview];
        autoAlert = [[FCAlertView alloc] init];
        autoAlert.colorScheme = [UIColor blackColor];
        [autoAlert makeAlertTypeWarning];
        [autoAlert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Device is disconnected. Please connect Surface device from Dashboard"
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
        return;
    }
    else
    {
        isRequestResponsed = NO;
//        isRequestResponsed = YES; //For Demo
        [requestTimeout invalidate];
        requestTimeout = nil;
        requestTimeout = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(RequestTimeoutMethod) userInfo:nil repeats:NO];
        
        if ([sender tag] == 1)
        {
            [APP_DELEGATE endHudProcess];
            [APP_DELEGATE startHudProcess:@"Fetching distance..."];
            stepType = 2;
            [self SendPingCommandBLE];
        }
        else if ([sender tag] == 2)
        {
            [autoAlert removeFromSuperview];
            autoAlert = [[FCAlertView alloc] init];
            autoAlert.tag = 222;
            autoAlert.delegate = self;
            autoAlert.colorScheme = [UIColor blackColor];
            [autoAlert makeAlertTypeCaution];
            [autoAlert showAlertInView:self
                         withTitle:@"Combat Diver"
                      withSubtitle:@"Please make sure that you have moved 200 meters away in 90 degree from location PING 1."
                   withCustomImage:[UIImage imageNamed:@"logo.png"]
               withDoneButtonTitle:nil
                        andButtons:nil];
        }
        else if ([sender tag] == 3)
        {
            [autoAlert removeFromSuperview];
            autoAlert = [[FCAlertView alloc] init];
            autoAlert.tag = 333;
            autoAlert.delegate = self;
            autoAlert.colorScheme = [UIColor blackColor];
            [autoAlert makeAlertTypeCaution];
            [autoAlert showAlertInView:self
                         withTitle:@"Combat Diver"
                      withSubtitle:@"Please make sure that you have moved 200 meters away in right angle direction from PING 2 location."
                   withCustomImage:[UIImage imageNamed:@"logo.png"]
               withDoneButtonTitle:nil
                        andButtons:nil];
        }
    }
}
-(void)SendPingCommandBLE
{
    NSInteger firstInt = [@"02" integerValue];
    NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
    
    NSInteger secondInt = [@"05" integerValue];
    NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
    
    NSInteger thirdInt = [@"04" integerValue];
    NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
    
    NSString * strNanoID = [APP_DELEGATE checkforValidString:[previousDict valueForKey:@"SC4_nano_id"]];
    if (![strNanoID isEqualToString:@"NA"])
    {
        NSInteger sc4Int = [[previousDict valueForKey:@"SC4_nano_id"] integerValue];
        NSData * sc4NanoData = [[NSData alloc] initWithBytes:&sc4Int length:4];
        
        NSMutableData *completeData = [firstData mutableCopy];
        [completeData appendData:secondData];
        [completeData appendData:thirdData];
        [completeData appendData:sc4NanoData];
        NSLog(@"Sent Data>>>>>>>>>>>%@",completeData);
        [[BLEService sharedInstance] writeValuetoDeviceDiverMsg:completeData with:globalPeripheral];
    }
}

-(void)btnStatusClicked
{
    
}
-(void)btnCalculateClicked
{
    //Algorithm to fetch the final location of NetTag, Then save in DB & Move to Map Class
    
    [self SaveinDatabase];
    
    /*DeviceMap * view1 = [[DeviceMap alloc]init];
    [self.navigationController pushViewController:view1 animated:true];*/
}
-(void)RequestTimeoutMethod
{
    [APP_DELEGATE endHudProcess];
    if (isRequestResponsed == NO)
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeCaution];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Something went wrong. Please try again later."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];

    }
}
#pragma mark - Database Methods
-(void)SaveinDatabase
{
    double dateStamp = [[NSDate date] timeIntervalSince1970];
    
    NSString * strDistance1 = [dictDetail valueForKey:@"step1_distance"];
    NSString * strDistance2 = [dictDetail valueForKey:@"step2_distance"];
    NSString * strDistance3 = [dictDetail valueForKey:@"step3_distance"];
    
    NSString * strLat1 = [dictDetail valueForKey:@"step1_lat"];
    NSString * strLat2 = [dictDetail valueForKey:@"step2_lat"];
    NSString * strLat3 = [dictDetail valueForKey:@"step3_lat"];
    
    NSString * strLong1 = [dictDetail valueForKey:@"step1_long"];
    NSString * strLong2 = [dictDetail valueForKey:@"step2_long"];
    NSString * strLong3 = [dictDetail valueForKey:@"step3_long"];
    
    NSString * strPingtime1 = [dictDetail valueForKey:@"step1_pingtime"];
    NSString * strPingtime2 = [dictDetail valueForKey:@"step2_pingtime"];
    NSString * strPingtime3 = [dictDetail valueForKey:@"step3_pingtime"];
    
    double d1temp = [strDistance1 doubleValue];
    double d2temp = [strDistance2 doubleValue];
    double d3temp = [strDistance3 doubleValue];
    
    CGFloat d1 = (d1temp/1.0);
    CGFloat d2 = (d2temp/1.0);
    CGFloat d3 = (d3temp/1.0);

    double lat1 = [strLat1 doubleValue];
    double lat2 = [strLat2 doubleValue];
    double lat3 = [strLat3 doubleValue];
    
    double lon1 = [strLong1 doubleValue];
    double lon2 = [strLong2 doubleValue];
    double lon3 = [strLong3 doubleValue];
    
    CLLocation * loc1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    CLLocation * loc2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    CLLocation * loc3 = [[CLLocation alloc] initWithLatitude:lat3 longitude:lon3];
    
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:loc1 forKey:@"location"];
    [dic1 setObject:[NSNumber numberWithFloat:d1] forKey:@"distance"];
    
    NSMutableDictionary * dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:loc2 forKey:@"location"];
    [dic2 setObject:[NSNumber numberWithFloat:d2] forKey:@"distance"];
    
    NSMutableDictionary * dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:loc3 forKey:@"location"];
    [dic3 setObject:[NSNumber numberWithFloat:d3] forKey:@"distance"];
    
    NSMutableArray * tmpArr = [[NSMutableArray alloc] initWithObjects:dic1,dic2,dic3, nil];
    NSMutableArray * netTagLatLongArr = [[NSMutableArray alloc] init];
    
    KPTrilaterator * trl = [[KPTrilaterator alloc] init];
    netTagLatLongArr = [trl compute:tmpArr];
    
    if ([netTagLatLongArr count]>=2)
    {
        NSString * strQry = [NSString stringWithFormat:@"insert into 'Diver_Locate' ('diver_id','diver_name', 'nanoID', 'time', 'status') values ('%@','%@','%@','%@', '%@')",[previousDict valueForKey:@"id"],[previousDict valueForKey:@"name"], [previousDict valueForKey:@"nano"], [NSString stringWithFormat:@"%f",dateStamp],@"0"];
        locatedID = [[DataBaseManager dataBaseManager] executeSw:strQry];
        
        double netLat = [[netTagLatLongArr objectAtIndex:0] doubleValue];
        double netLong = [[netTagLatLongArr objectAtIndex:1] doubleValue];
        NSString * strSubQry = [NSString stringWithFormat:@"insert into 'Diver_Locate_Detail' ('diver_locate_id','step1_distance','step1_lat', 'step1_long', 'step1_pingtime', 'step2_distance','step2_lat', 'step2_long', 'step2_pingtime', 'step3_distance','step3_lat', 'step3_long', 'step3_pingtime','final_lat','final_long') values ('%@','%@','%@','%@', '%@','%@','%@','%@', '%@','%@','%@','%@', '%@','%@', '%@')",[NSString stringWithFormat:@"%d",locatedID],strDistance1,strLat1, strLong1, strPingtime1,strDistance2,strLat2, strLong2, strPingtime2, strDistance3, strLat3, strLong3, strPingtime3,[NSString stringWithFormat:@"%f",netLat],[NSString stringWithFormat:@"%f",netLong]];
        [[DataBaseManager dataBaseManager] execute:strSubQry];
        
        [dictDetail setObject:[NSString stringWithFormat:@"%f",netLat] forKey:@"final_lat"];
        [dictDetail setObject:[NSString stringWithFormat:@"%f",netLong] forKey:@"final_long"];
        [dictDetail setObject:[previousDict valueForKey:@"name"] forKey:@"name"];
        
        MapClassVC * mapV = [[MapClassVC alloc] init];
        mapV.detailsDict = dictDetail;
        [self.navigationController pushViewController:mapV animated:YES];
    }
    else
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeSuccess];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Something went wrong. Please try again."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
}

#pragma mark - Notification Methods
-(void)GetDistanceofNanoID:(NSMutableDictionary *)dict
{
    [requestTimeout invalidate];
    requestTimeout = nil;

    [APP_DELEGATE endHudProcess];
    
    NSLog(@"Here in Setupsurfae got the lat=%@ and long",dict);
    
    NSInteger classNano = [[previousDict valueForKey:@"SC4_nano_id"] integerValue];
    NSInteger bleNano = [[dict valueForKey:@"NanoID"] integerValue];
    if (classNano == bleNano)
    {
        double distanceInt = [[dict valueForKey:@"distance"] doubleValue];
        double val = distanceInt/1000;
        NSString * strMsg = [NSString stringWithFormat:@"Got the distance for Step %d. \n Distane is %.3f meter",stepType-1,val];
        NSString * strDistance = [APP_DELEGATE checkforValidString:[dict valueForKey:@"distance"]];
        NSString * strLat = [APP_DELEGATE checkforValidString:[dict valueForKey:@"lat"]];
        NSString * strLong = [APP_DELEGATE checkforValidString:[dict valueForKey:@"long"]];
        double dateStamp = [[NSDate date] timeIntervalSince1970];
        
        if (stepType == 2)
        {
            [dictDetail setObject:[NSString stringWithFormat:@"%.3f",val] forKey:@"step1_distance"];
            [dictDetail setObject:strLat forKey:@"step1_lat"];
            [dictDetail setObject:strLong forKey:@"step1_long"];
            [dictDetail setObject:[NSString stringWithFormat:@"%f",dateStamp] forKey:@"step1_pingtime"];
            [dictDetail setObject:@"Completed" forKey:@"Status"];
            
            lblDistance.text = [NSString stringWithFormat:@"Distance : %.3f meter",val];
            lblStatus.text = @"Status : Completed";
            lblLatLong1.text = [NSString stringWithFormat:@"Lat : %@\n Long : %@ ",strLat,strLong];
            
            [btnPing setBackgroundImage:[UIImage imageNamed:@"PingRed.png"] forState:UIControlStateNormal];
            btnPing.enabled = false;
            [btnPing2 setBackgroundImage:[UIImage imageNamed:@"PingGreen.png"] forState:UIControlStateNormal];
            btnPing2.enabled = true;
            
            [timer1 invalidate];
            timer1 = nil;
            timer1 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(lineAnimationforPing2) userInfo:nil repeats:YES];
            
            animateView1.hidden = YES;
            animateView2.hidden = NO;
            animateView3.hidden = YES;
        }
        else if (stepType == 3)
        {
            if ([[dictDetail valueForKey:@"step1_lat"] isEqualToString:strLat] || [[dictDetail valueForKey:@"step1_long"] isEqualToString:strLong])
            {
                [autoAlert removeFromSuperview];
                autoAlert = [[FCAlertView alloc] init];
                autoAlert.colorScheme = [UIColor blackColor];
                [autoAlert makeAlertTypeWarning];
                [autoAlert showAlertInView:self
                                  withTitle:@"NetTag Recovery App"
                               withSubtitle:@"Please move 200 meter. Previous ping location and current ping location should not be the same."
                            withCustomImage:[UIImage imageNamed:@"logo.png"]
                        withDoneButtonTitle:nil
                                 andButtons:nil];
                return;
            }
            else
            {
                [dictDetail setObject:[NSString stringWithFormat:@"%.3f",val] forKey:@"step2_distance"];
                [dictDetail setObject:strLat forKey:@"step2_lat"];
                [dictDetail setObject:strLong forKey:@"step2_long"];
                [dictDetail setObject:[NSString stringWithFormat:@"%f",dateStamp] forKey:@"step2_pingtime"];
                [dictDetail setObject:@"Completed" forKey:@"Status"];
                
                lblDistance2.text = [NSString stringWithFormat:@"Distance : %.3f meter",val];
                lblStatus2.text = @"Status : Completed";
                lblLatLong2.text = [NSString stringWithFormat:@"Lat : %@\n Long : %@ ",strLat,strLong];
                
                [btnPing setBackgroundImage:[UIImage imageNamed:@"PingRed.png"] forState:UIControlStateNormal];
                btnPing.enabled = false;
                [btnPing2 setBackgroundImage:[UIImage imageNamed:@"PingRed.png"] forState:UIControlStateNormal];
                btnPing2.enabled = false;
                [btnPing3 setBackgroundImage:[UIImage imageNamed:@"PingGreen.png"] forState:UIControlStateNormal];
                btnPing3.enabled = true;
                
                [timer1 invalidate];
                timer1 = nil;
                timer1 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(lineAnimationforPing2) userInfo:nil repeats:YES];
                
                animateView1.hidden = YES;
                animateView2.hidden = YES;
                animateView3.hidden = NO;
                
            }
            
        }
        else if (stepType == 4)
        {
            if ([[dictDetail valueForKey:@"step2_lat"] isEqualToString:strLat] || [[dictDetail valueForKey:@"step2_long"] isEqualToString:strLong] || [[dictDetail valueForKey:@"step3_lat"] isEqualToString:strLat] || [[dictDetail valueForKey:@"step3_long"] isEqualToString:strLong])
            {
                [autoAlert removeFromSuperview];
                autoAlert = [[FCAlertView alloc] init];
                autoAlert.colorScheme = [UIColor blackColor];
                [autoAlert makeAlertTypeWarning];
                [autoAlert showAlertInView:self
                                  withTitle:@"NetTag Recovery App"
                               withSubtitle:@"Please move 200 meter. Previous ping location and current ping location should not be the same."
                            withCustomImage:[UIImage imageNamed:@"logo.png"]
                        withDoneButtonTitle:nil
                                 andButtons:nil];
                return;
            }
            else
            {
                [dictDetail setObject:[NSString stringWithFormat:@"%.3f",val] forKey:@"step3_distance"];
                [dictDetail setObject:strLat forKey:@"step3_lat"];
                [dictDetail setObject:strLong forKey:@"step3_long"];
                [dictDetail setObject:[NSString stringWithFormat:@"%f",dateStamp] forKey:@"step3_pingtime"];
                [dictDetail setObject:@"Completed" forKey:@"Status"];
                
                lblDistance3.text = [NSString stringWithFormat:@"Distance : %.3f meter",val];
                lblStatus3.text = @"Status : Completed";
                lblLatLong3.text = [NSString stringWithFormat:@"Lat : %@\n Long : %@ ",strLat,strLong];
                
                [timer1 invalidate];
                timer1 = nil;
                
                btnCalculate.backgroundColor = [UIColor colorWithRed:31.0/255.0f green:173.0/255.0f blue:18.0/255.0f alpha:1];
                [btnPing3 setBackgroundImage:[UIImage imageNamed:@"PingRed.png"] forState:UIControlStateNormal];
                btnPing3.enabled = false;
                btnCalculate.enabled = true;
                
                animateView1.hidden = YES;
                animateView2.hidden = YES;
                animateView3.hidden = YES;
                strMsg = [NSString stringWithFormat:@"Got the distance for Step %d. Distane is %.3f meter.Now tap on Calculate to get the location of NetTag.",stepType-1,val];
                
            }
        }
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeSuccess];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:strMsg
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
}
-(void)ShowErrorMessagewithType:(NSString *)strType withNanoID:(NSString *)strNanoID;
{
    [requestTimeout invalidate];
    requestTimeout = nil;

    [APP_DELEGATE endHudProcess];
    
    NSString * strMsg = @"NA";
    if ([strType isEqualToString:@"01"])//GPS Error
    {
        strMsg = @"Something went wrong. Please try again to Ping. Not able to find latitude & longitude";
    }
    else if ([strType isEqualToString:@"02"])  //Nano modem (No response from nano modem)
    {
        strMsg = @"There is no response from Nano modem. Please try again later.";
    }
    else if ([strType isEqualToString:@"03"])//Nano modem is not present
    {
        strMsg = @"Nano modem is not present or its incorrect. Please move back try again to seach.";
    }
    if (![strMsg isEqualToString:@"NA"])
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:strMsg
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
}

#pragma mark - Quick Properties Methods

-(void)setDescLabelProperties:(UILabel *)lblSub
{
    [lblSub setBackgroundColor:[UIColor clearColor]];
    [lblSub setTextAlignment:NSTextAlignmentLeft];
    lblSub.numberOfLines = 0;
    [lblSub setFont:[UIFont fontWithName:CGRegularItalic size:textSize+1]];
    [lblSub setTextColor:[UIColor whiteColor]];
    lblSub.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
}
-(void)setPingButtonproperties:(UIButton *)btn
{
    btn.backgroundColor = UIColor.clearColor;
    btn.layer.masksToBounds = true;
    [btn setBackgroundImage:[UIImage imageNamed:@"PingRed.png"] forState:UIControlStateNormal];
    btn.enabled = false;
    [btn setTitle:@"Ping" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize+10];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector((btnPingClicked:)) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setOtherLabelProperties:(UILabel *)lbl withText:(NSString *)strText
{
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:strText];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setFont:[UIFont fontWithName:CGRegular size:textSize+1]];
    [lbl setTextColor:[UIColor whiteColor]];
}
-(void)setAnimatedLabelwithView:(UIView *)mainView
{
    UILabel * currentLocation = [[UILabel alloc] initWithFrame:CGRectMake(115, 65, 20, 20)];
    currentLocation.backgroundColor = UIColor.redColor;
    currentLocation.alpha = 3;
    currentLocation.layer.cornerRadius = 10;
    currentLocation.layer.masksToBounds = YES;
    currentLocation.layer.borderColor = [UIColor whiteColor].CGColor;
    currentLocation.layer.borderWidth = 1;
    [mainView addSubview:currentLocation];
    [UIView animateWithDuration:0.50 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        currentLocation.alpha = 0;
    } completion:nil];
    
    UILabel * lblYouHere = [[UILabel alloc] initWithFrame:CGRectMake(145,65, 120, 20)];
    [lblYouHere setBackgroundColor:[UIColor clearColor]];
    [lblYouHere setText:@"You are here!"];
    [lblYouHere setTextAlignment:NSTextAlignmentCenter];
    [lblYouHere setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
    [lblYouHere setTextColor:[UIColor whiteColor]];
    [mainView addSubview:lblYouHere];
    
    if (mainView == animateView3)
    {
        lblYouHere.frame = CGRectMake(55,40, 140, 20);
        [lblYouHere setText:@"Now You are here!"];
    }
}
-(void)setHinLabel:(UILabel *)lbl withText:(NSString *)strText
{
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:strText];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
    [lbl setTextColor:[UIColor whiteColor]];
    lbl.hidden = YES;
    lbl.numberOfLines = 0;
}

-(void)lineAnimationforPing2
{
    [pathLayer removeFromSuperlayer];
    path = [UIBezierPath bezierPath];
    if (isReturns == NO)
    {
        isReturns = YES;
        if (stepType == 2)
        {
            lblOr1.hidden = NO;
            lblHint2Up.hidden = NO;
            lblHint2Down.hidden = YES;
            [path moveToPoint:CGPointMake(125.0,65.0)];
            [path addLineToPoint:CGPointMake(125.0, 00.0)];
        }
        else if (stepType == 3)
        {
            lblOr2.hidden = NO;
            lblHin3Right.hidden = YES;
            lblHin3Left.hidden = NO;
            [path moveToPoint:CGPointMake(135.0,75.0)];
            [path addLineToPoint:CGPointMake(255.0, 75.0)];
        }
    }
    else
    {
        isReturns = NO;
        if (stepType == 2)
        {
            [path moveToPoint:CGPointMake(125.0,85.0)];
            [path addLineToPoint:CGPointMake(125.0, 85+65)];
            lblHint2Up.hidden = YES;
            lblHint2Down.hidden = NO;
        }
        else if (stepType == 3)
        {
            [path moveToPoint:CGPointMake(115.0,75.0)];
            [path addLineToPoint:CGPointMake(5, 75)];
            lblHin3Right.hidden = NO;
            lblHin3Left.hidden = YES;
        }
    }

    pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.view.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor redColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 2.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    if (stepType == 2)
    {
        [animateView2.layer addSublayer:pathLayer];
    }
    else if(stepType == 3)
    {
        [animateView3.layer addSublayer:pathLayer];
    }
    
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}
-(NSString*)hexFromStr:(NSString*)str
{
    NSData* nsData = [str dataUsingEncoding:NSUTF8StringEncoding];
    const char* data = [nsData bytes];
    NSUInteger len = nsData.length;
    NSMutableString* hex = [NSMutableString string];
    for(int i = 0; i < len; ++i)
        [hex appendFormat:@"%02X", data[i]];
    return hex;
}

- (NSData *)dataFromHexString:(NSString*)hexStr
{
    const char *chars = [hexStr UTF8String];
    NSInteger i = 0, len = hexStr.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}
#pragma mark - Helper Methods

- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    NSLog(@"Button Clicked: %ld Title:%@", (long)index, title);
}

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView
{
    if (alertView.tag == 222)
    {
        [APP_DELEGATE endHudProcess];
        [APP_DELEGATE startHudProcess:@"Fetching distance..."];
        
        [self SendPingCommandBLE];

        stepType = 3;
        isReturns = NO;
        
    }
    else if (alertView.tag == 333)
    {
        isReturns = NO;
        stepType = 4;
        [self SendPingCommandBLE];

        [APP_DELEGATE endHudProcess];
        [APP_DELEGATE startHudProcess:@"Fetching distance..."];
        
    }
    NSLog(@"Done Button Clicked");
}

- (void)FCAlertViewDismissed:(FCAlertView *)alertView
{
    NSLog(@"Alert Dismissed");
}

- (void)FCAlertViewWillAppear:(FCAlertView *)alertView
{
    NSLog(@"Alert Will Appear");
}
-(void)tempMethod
{
    /*NanoID = 74002462;
     distance = 421;
     lat = "12.2047740";
     long = "76.3690590";
     
     NanoID = 74002462;
     distance = 515;
     lat = "12.2047680";
     long = "76.3690640";
     
     
     NanoID = 74002462;
     distance = 562;
     lat = "12.2047740";
     long = "76.3690590";*/
    //    12.4294116    76.4606766    1578980164.512168    (null)    12.4307083    76.4598533    1578980318.446419    (null)    12.4307616    76.4605450    1578980548.435026    12.344052    76.456254
    //12.4294116,76.4606766,151.015,12.4307083,76.4598533,192.823,12.4307616,76.4605450,169.247
    //Exact lat long of tag  : 12.42906, 76.46122
    //2nd Reading    12.4307433    76.4606016    1578980908.663008    (null)    12.4321883    76.4634866    1578981300.803292    (null)    12.4321533    76.4636883    1578981636.792005
    
    
    dictDetail = [[NSMutableDictionary alloc] init];
    [dictDetail setObject:@"12.4294116" forKey:@"step1_lat"];
    [dictDetail setObject:@"12.4307083" forKey:@"step2_lat"];
    [dictDetail setObject:@"12.4307616" forKey:@"step3_lat"];
    
    [dictDetail setObject:@"76.4606766" forKey:@"step1_long"];
    [dictDetail setObject:@"76.4598533" forKey:@"step2_long"];
    [dictDetail setObject:@"76.4605450" forKey:@"step3_long"];
    
    NSString * strDistance1 = @"324.949";
    NSString * strDistance2 = @"454.217";
    NSString * strDistance3 = @"431.766";
    
    NSString * strLat1 = [dictDetail valueForKey:@"step1_lat"];
    NSString * strLat2 = [dictDetail valueForKey:@"step2_lat"];
    NSString * strLat3 = [dictDetail valueForKey:@"step3_lat"];
    
    NSString * strLong1 = [dictDetail valueForKey:@"step1_long"];
    NSString * strLong2 = [dictDetail valueForKey:@"step2_long"];
    NSString * strLong3 = [dictDetail valueForKey:@"step3_long"];
    
    NSString * strPingtime1 = [dictDetail valueForKey:@"step1_pingtime"];
    NSString * strPingtime2 = [dictDetail valueForKey:@"step2_pingtime"];
    NSString * strPingtime3 = [dictDetail valueForKey:@"step3_pingtime"];
    
    double d1temp = [strDistance1 doubleValue];
    double d2temp = [strDistance2 doubleValue];
    double d3temp = [strDistance3 doubleValue];
    
    CGFloat d1 = (d1temp/1.0);
    CGFloat d2 = (d2temp/1.0);
    CGFloat d3 = (d3temp/1.0);
    
    double lat1 = [strLat1 doubleValue];
    double lat2 = [strLat2 doubleValue];
    double lat3 = [strLat3 doubleValue];
    
    double lon1 = [strLong1 doubleValue];
    double lon2 = [strLong2 doubleValue];
    double lon3 = [strLong3 doubleValue];
    
    CLLocation * loc1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    CLLocation * loc2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    CLLocation * loc3 = [[CLLocation alloc] initWithLatitude:lat3 longitude:lon3];
    
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:loc1 forKey:@"location"];
    [dic1 setObject:[NSNumber numberWithFloat:d1] forKey:@"distance"];
    
    NSMutableDictionary * dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:loc2 forKey:@"location"];
    [dic2 setObject:[NSNumber numberWithFloat:d2] forKey:@"distance"];
    
    NSMutableDictionary * dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:loc3 forKey:@"location"];
    [dic3 setObject:[NSNumber numberWithFloat:d3] forKey:@"distance"];
    
    
    NSMutableArray * tmpArr = [[NSMutableArray alloc] initWithObjects:dic1,dic2,dic3, nil];
    NSLog(@"Sent Arr=%@",tmpArr);
    NSMutableArray * netTagLatLongArr = [[NSMutableArray alloc] init];
    KPTrilaterator * trl = [[KPTrilaterator alloc] init];
    netTagLatLongArr = [trl compute:tmpArr];
    
    if ([netTagLatLongArr count]>=2)
    {
        double netLat = [[netTagLatLongArr objectAtIndex:0] doubleValue];
        double netLong = [[netTagLatLongArr objectAtIndex:1] doubleValue];
        NSString * strSubQry = [NSString stringWithFormat:@"insert into 'Diver_Locate_Detail' ('diver_locate_id','step1_distance','step1_lat', 'step1_long', 'step1_pingtime', 'step2_distance','step2_lat', 'step2_long', 'step2_pingtime', 'step3_distance','step3_lat', 'step3_long', 'step3_pingtime','final_lat','final_long') values ('%@','%@','%@','%@', '%@','%@','%@','%@', '%@','%@','%@','%@', '%@','%@', '%@')",[NSString stringWithFormat:@"%d",locatedID],strDistance1,strLat1, strLong1, strPingtime1,strDistance2,strLat2, strLong2, strPingtime2, strDistance3, strLat3, strLong3, strPingtime3,[NSString stringWithFormat:@"%f",netLat],[NSString stringWithFormat:@"%f",netLong]];
        [[DataBaseManager dataBaseManager] execute:strSubQry];
        
        [dictDetail setObject:[NSString stringWithFormat:@"%f",netLat] forKey:@"final_lat"];
        [dictDetail setObject:[NSString stringWithFormat:@"%f",netLong] forKey:@"final_long"];
        
        MapClassVC * mapV = [[MapClassVC alloc] init];
        mapV.detailsDict = dictDetail;
        [self.navigationController pushViewController:mapV animated:YES];
        
        
    }
    
    //    [trl trilaterate:tmpArr success:^(Location * loca)
    //     {
    //         NSLog(@"got the lcoation=%f  long=%f" ,loca.coordinates.latitude,loca.coordinates.longitude);
    //     }failure:^(NSError * err)
    //     {
    //
    //     }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 12.3412862,76.6150765,16z\
 
 NanoID = 74002462;
 distance = 421;
 lat = "12.2047740";
 long = "76.3690590";
 
 NanoID = 74002462;
 distance = 515;
 lat = "12.2047680";
 long = "76.3690640";


 NanoID = 74002462;
 distance = 562;
 lat = "12.2047740";
 long = "76.3690590";

*/

@end
