/*
 
 The MIT License (MIT)
 
 Copyright (c) 2015 ABM Adnan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "RadarViewController.h"
#import "ChatVC.h"


#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)
#define foo4random() (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)

@interface RadarViewController ()
{
    UIView * viewHeader;
}
@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;
@property (nonatomic, strong)	id				currentPopTipViewTarget;
@property (nonatomic, strong) AMPopTip *popTip;

@end

@implementation RadarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[APP_DELEGATE getbackgroundImage]];
    imgBack.userInteractionEnabled = YES;
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
    
     viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, headerhHeight)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewWidth,headerhHeight)];
    lblBack.backgroundColor = [UIColor blackColor];
    lblBack.alpha = 0.4;
    [viewHeader addSubview:lblBack];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Diverloc8"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    
    [self setMainContentView];
    
    if (IS_IPHONE)
    {
        UIImageView * imgMenu = [[UIImageView alloc] init];
        imgMenu.frame = CGRectMake(10, 20+13.5, 24, 17);
        imgMenu.image = [UIImage imageNamed:@"menu_icon.png"];
        [self.view addSubview:imgMenu];
        
        UIButton * btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerhHeight, headerhHeight)];
        [btnMenu setBackgroundColor:[UIColor clearColor]];
        [btnMenu addTarget:self action:@selector(btnLeftMenuClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnMenu];
        
        if (IS_IPHONE_X)
        {
            viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
            lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
            imgMenu.frame = CGRectMake(10, 13.5+44, 24, 17);
            btnMenu.frame = CGRectMake(0, 0, 70, 88);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    filteredContacts = [[NSMutableArray alloc]init];
    NSString * strContat = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strContat resultsArray:filteredContacts];
}
-(void)viewDidDisappear:(BOOL)animated
{
    // Start heading updates.
    if ([CLLocationManager headingAvailable])
    {
//        [_locManager stopUpdatingHeading];
//        [_locManager stopUpdatingHeading];

    }
}
-(void)setMainContentView
{
    self.visiblePopTipViews = [NSMutableArray array];
    
    [AMPopTip appearance].font = [UIFont fontWithName:@"Avenir-Medium" size:12];
    self.popTip = [AMPopTip popTip];
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.edgeMargin = 5;
    self.popTip.offset = 2;
    self.popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.popTip.tapHandler = ^{
        NSLog(@"Tap!");
    };
    self.popTip.dismissHandler = ^{
        NSLog(@"Dismiss!");
    };
    
    int yyy = 64;
    if (IS_IPHONE)
    {
        yyy = headerhHeight + 64;
    }
    
    //Radar Image Setup
    radarImg =[[UIImageView alloc] initWithFrame:CGRectMake(0, yyy, viewWidth, viewWidth)];
    radarImg.image=[UIImage imageNamed:@"radaar-dotted-new.png"];
    [self.view addSubview:radarImg];
    
    dots = [[NSMutableArray alloc] init];
    nearbyUsers = [[NSArray alloc] init];
    
    radarViewHolder=[[UIView alloc] init];
    radarViewHolder.frame=CGRectMake(0, yyy, viewWidth, viewWidth);
    radarViewHolder.backgroundColor=[UIColor clearColor];
    [self.view addSubview:radarViewHolder];
    radarViewHolder.center=CGPointMake(radarViewHolder.frame.size.width/2, radarViewHolder.frame.size.height/2);
    
    [self hintView];
    
    arcsView = [[Arcs alloc] initWithFrame:CGRectMake(0, yyy, viewWidth, viewWidth)];
    arcsView.center=CGPointMake(arcsView.frame.size.width/2, (arcsView.frame.size.height/2));
    if (IS_IPHONE)
    {
        arcsView.center=CGPointMake(arcsView.frame.size.width/2, (arcsView.frame.size.height/2)+64+64);
    }
    arcsView.backgroundColor=[UIColor clearColor];

    // NOTE: Since our gradient layer is built as an image,
    // we need to scale it to match the display of the device.
    //    arcsView.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    radarViewHolder.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    [radarViewHolder addSubview:arcsView];
    
    // add tap gesture recognizer to arcs view to capture tap on dots (user profiles) and enlarge the selected dots with a white border
    arcsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDotTapped:)];
    [arcsView addGestureRecognizer:tapGestureRecognizer];
    
    
    radarView = [[Radar alloc] initWithFrame:CGRectMake(0, yyy, radarViewHolder.frame.size.width, radarViewHolder.frame.size.height)];
    radarView.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    radarView.alpha = 0.68;
    [radarViewHolder addSubview:radarView];

    
    filteredContacts = [[NSMutableArray alloc]init];
    NSString * strContat = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strContat resultsArray:filteredContacts];
    
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectZero];
    lblBack.backgroundColor = [UIColor colorWithRed:0/255.0 green:150/255.0 blue:0/255.0 alpha:0.50];
    lblBack.frame=CGRectMake(viewWidth-90, yyy+30, 50, 50);
    lblBack.layer.cornerRadius = 25;
    lblBack.layer.masksToBounds = YES;
    [radarViewHolder addSubview:lblBack];
    
    if (IS_IPHONE)
    {
        lblBack.frame=CGRectMake(viewWidth-90, headerhHeight+20, 50, 50);
    }
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 0, 15, 50)];
    arrowImageView.image = [UIImage imageNamed:@"needle.png"];
    [lblBack addSubview:arrowImageView];
    
//    geoPointCompass = [[GeoPointCompass alloc] init];
//    // Add the image to be used as the compass on the GUI
//    [geoPointCompass setArrowImageView:arrowImageView];
//    // Set the coordinates of the location to be used for calculating the angle
//    geoPointCompass.latitudeOfTargetedPoint = 12.2958;
//    geoPointCompass.longitudeOfTargetedPoint = 76.6394;
    
    [self CreateDetailView];
    
    if (IS_IPHONE)
    {
        
//        lblBack.frame=CGRectMake(DEVICE_WIDTH-50, headerhHeight +50, 40, 40);
//        lblBack.layer.cornerRadius = 20;
//        arrowImageView.frame = CGRectMake(12.5, 0, 15, 40);
//
//        radarImg.frame = CGRectMake(0,(DEVICE_HEIGHT-DEVICE_WIDTH)/2, DEVICE_WIDTH, DEVICE_WIDTH);
//        radarImg.image=[UIImage imageNamed:@"radaar-dotted-new.png"];
//
//        radarViewHolder.frame=CGRectMake(0,(DEVICE_HEIGHT-DEVICE_WIDTH)/2, DEVICE_WIDTH, DEVICE_WIDTH);
//        radarViewHolder.center=CGPointMake(radarViewHolder.frame.size.width/2, radarViewHolder.frame.size.height/2);
//        radarViewHolder.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
//
//        arcsView.frame = CGRectMake(0, headerhHeight, DEVICE_WIDTH, DEVICE_WIDTH);
//        arcsView.center=CGPointMake(arcsView.frame.size.width/2, arcsView.frame.size.height/2);
//
//        radarView.frame =CGRectMake(0, headerhHeight, radarViewHolder.frame.size.width, radarViewHolder.frame.size.height);
//        radarView.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
////        radarView.center=CGPointMake(DEVICE_WIDTH/2,( DEVICE_HEIGHT/2)+00);
    }
    
    // start spinning the radar forever
    [self spinRadar];
    
    // start heading event to rotate the arcs along with device rotation
    currentDeviceBearing = 0;
//    [self startHeadingEvent];
    
    [self loadUsers];
}
-(void)hintView
{
    UILabel * lblHint = [[UILabel alloc] init];
    lblHint.frame = CGRectMake(10, 768-130-30, 150, 20);
    lblHint.textColor = [UIColor whiteColor];
    lblHint.text = @"Depth";
    lblHint.font = [UIFont fontWithName:CGBold size:textSize+2];
    [radarViewHolder addSubview:lblHint];

    
    UIView * hintView =[[UIView alloc] initWithFrame:CGRectMake(0, 768-130, 180, 300)];
    hintView.backgroundColor=[UIColor clearColor];
    [radarViewHolder addSubview:hintView];
    
    for (int iii = 0; iii < 5; iii++)
    {
        UILabel * lblDot = [[UILabel alloc] init];
        lblDot.frame = CGRectMake(10, (iii*25)+10, 20, 20);
        lblDot.layer.cornerRadius = 10;
        lblDot.layer.masksToBounds = YES;
        [hintView addSubview:lblDot];
        
        UILabel * lblHint = [[UILabel alloc] init];
        lblHint.frame = CGRectMake(40, (iii*25)+10, 150, 20);
        lblHint.textColor = [UIColor whiteColor];
        [hintView addSubview:lblHint];

        if (iii==0)
        {
            lblDot.backgroundColor = [UIColor yellowColor];
            lblHint.text = @"0 - 20 meter";
        }
        else if (iii==1)
        {
            lblDot.backgroundColor = [UIColor blueColor];
            lblHint.text = @"20 - 40 meter";
        }
        else if (iii==2)
        {
            lblDot.backgroundColor = [UIColor greenColor];
            lblHint.text = @"40 - 60 meter";

        }
        else if (iii==3)
        {
            lblDot.backgroundColor = [UIColor whiteColor];
            lblHint.text = @"60 - 80 meter";
        }
        else if (iii>=4)
        {
            lblDot.backgroundColor = [UIColor redColor];
            lblHint.text = @"80 - 100 meter";
        }
        if (IS_IPHONE)
        {
            lblDot.frame = CGRectMake(10, (iii*20)+10, 18, 18);
            lblHint.font = [UIFont systemFontOfSize:10];
            lblHint.frame = CGRectMake(40, (iii*20)+10, 150, 20);
            lblDot.layer.cornerRadius = 9;
        }
    }
    if (IS_IPHONE)
    {
        lblHint.frame = CGRectMake(5, DEVICE_HEIGHT-160, 150, 20);
        hintView.frame =CGRectMake(0, DEVICE_HEIGHT-140, 180, 130);
        lblHint.font = [UIFont fontWithName:CGRegular size:textSize-2];
        hintView.backgroundColor = [UIColor clearColor];
    }
}
-(void)btnLeftMenuClicked
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
    
}
-(void)CreateDetailView
{
    [topView removeFromSuperview];
    topView =[[UIView alloc] initWithFrame:CGRectMake(0,64, 705, 88)];
    topView.hidden = YES;
    topView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:topView];
    
    shipImg =[[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 60, 60)];
    shipImg.image=[UIImage imageNamed:@"user.png"];
//    shipImg.layer.cornerRadius=30;
    shipImg.layer.masksToBounds=YES;
    shipImg.layer.borderColor = [UIColor  whiteColor].CGColor;
//    shipImg.layer.borderWidth = 2;
//    shipImg.contentMode=UIViewContentModeScaleAspectFill;
//    shipImg.backgroundColor=[UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0];
    [topView addSubview:shipImg];
    
    namelbl =[[UILabel alloc] initWithFrame:CGRectMake(92, 0, 160, 44)];
    namelbl.textColor=[UIColor colorWithRed:22.0f/255.0f green:180.0f/255.0f blue:4.0f/255.0f alpha:1];
    namelbl.text=@"Mattehorn Spirit";
    namelbl.font=[UIFont fontWithName:CGRegular size:textSize + 3];
    namelbl.backgroundColor=[UIColor clearColor];
    [topView addSubview:namelbl];
    
    distanceLbl =[[UILabel alloc] initWithFrame:CGRectMake(92, 50, 150, 25)];
    distanceLbl.textColor=[UIColor greenColor];
    distanceLbl.text=@"2nm";
    distanceLbl.font=[UIFont fontWithName:CGRegular size:textSize + 1];
    distanceLbl.backgroundColor=[UIColor clearColor];
    [topView addSubview:distanceLbl];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Distance : 2 M"];
    [string setColorForText:@"Distance :" withColor:[UIColor whiteColor]];
    distanceLbl.attributedText = string;
    
    
    lblDirection =[[UILabel alloc] initWithFrame:CGRectMake(82+150+10, 50, 150, 25)];
    lblDirection.textColor=[UIColor greenColor];
    lblDirection.text=@"120";
    lblDirection.font=[UIFont fontWithName:CGRegular size:textSize + 1];
    lblDirection.backgroundColor=[UIColor clearColor];
    [topView addSubview:lblDirection];
    
    NSMutableAttributedString * strDirection = [[NSMutableAttributedString alloc] initWithString:@"Position : 260"];
    [strDirection setColorForText:@"Position :" withColor:[UIColor whiteColor]];
    lblDirection.attributedText = strDirection;

    lblDepth =[[UILabel alloc] initWithFrame:CGRectMake(82+150+150+10, 50, 150, 25)];
    lblDepth.textColor=[UIColor greenColor];
    lblDepth.text=@"120";
    lblDepth.font=[UIFont fontWithName:CGRegular size:textSize + 1];
    lblDepth.backgroundColor=[UIColor clearColor];
    [topView addSubview:lblDepth];
    
    NSMutableAttributedString * strDepth = [[NSMutableAttributedString alloc] initWithString:@"Depth : 45 Meter"];
    [strDepth setColorForText:@"Depth :" withColor:[UIColor whiteColor]];
    lblDepth.attributedText = strDepth;

    btnSendMsg =[UIButton buttonWithType:UIButtonTypeCustom];
    btnSendMsg.backgroundColor=[UIColor clearColor];
//    [btnSendMsg setTitle:@"Send Message" forState:UIControlStateNormal];
    btnSendMsg.titleLabel.font=[UIFont systemFontOfSize:16];
    [btnSendMsg setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    btnSendMsg.frame=CGRectMake(viewWidth-120 , 0, 88, 88);
    [btnSendMsg addTarget:self action:@selector(sendMessageClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnSendMsg];
//    btnSendMsg.layer.borderColor =[UIColor greenColor].CGColor;
//    btnSendMsg.layer.borderWidth =1;
//    btnSendMsg.layer.cornerRadius = 4;
    [btnSendMsg setImage:[UIImage imageNamed:@"send_icon.png"] forState:UIControlStateNormal];
    btnSendMsg.layer.masksToBounds = YES;
    
    if(IS_IPHONE)
    {
        shipImg.frame = CGRectMake(5, 10, 44, 44);
//        shipImg.layer.cornerRadius= 22;
        topView.frame = CGRectMake(0, headerhHeight, DEVICE_WIDTH, 66);
        
        namelbl.frame = CGRectMake(0, 41, 55, 25);
        namelbl.numberOfLines = 0;
        namelbl.font=[UIFont systemFontOfSize:15];
        namelbl.textAlignment = NSTextAlignmentCenter;

        distanceLbl.frame = CGRectMake(70, 0, 120, 29);
        distanceLbl.font=[UIFont systemFontOfSize:12];

        lblDirection.frame = CGRectMake(70, 35, 100, 29);
        lblDirection.font=[UIFont systemFontOfSize:12];

        lblDepth.frame = CGRectMake(180, 0,100, 29);
        lblDepth.font=[UIFont systemFontOfSize:12];

        btnSendMsg.frame=CGRectMake(DEVICE_WIDTH-50, 10.5, 45, 45);
        [btnSendMsg setTitle:@"" forState:UIControlStateNormal];
        [btnSendMsg setImage:[UIImage imageNamed:@"send_icon.png"] forState:UIControlStateNormal];
    }
    
}
-(void)sendMessageClick
{
//    viewString=@"home";
//    NSLog(@"details=%@",[filteredContacts objectAtIndex:selectedIndex]);
//    MassageipadViewController *msg=[[MassageipadViewController alloc]init];
//    msg.userNano = [[filteredContacts objectAtIndex:selectedIndex] valueForKey:@"nano"];
//    msg.userName = [[filteredContacts objectAtIndex:selectedIndex] valueForKey:@"name"];
//    [self.navigationController pushViewController:msg animated:YES];
    
    globalChatVC=[[ChatVC alloc]init];
    globalChatVC.userNano = [[filteredContacts objectAtIndex:selectedIndex] valueForKey:@"nano"];
    globalChatVC.userName = [[filteredContacts objectAtIndex:selectedIndex] valueForKey:@"name"];
    globalChatVC.sc4NanoId = [[filteredContacts objectAtIndex:selectedIndex] valueForKey:@"SC4_nano_id"];
    [self.navigationController pushViewController:globalChatVC animated:YES];
}

#pragma mark - Reload Radar

-(void) removePreviousDots {
    for (Dot *dot in dots) {
        [dot removeFromSuperview];
    }
    dots = [NSMutableArray array];

    // reset slider
    distanceSlider.minimumValue = 0;
    distanceSlider.maximumValue = 0;
    distanceSlider.value = 0;
}

-(void)renderUsersOnRadar:(NSArray*)users{
    
    CLLocationCoordinate2D myLoc = { 48.858370, 2.294481 };
    
    // the last user in the nearbyUsers list is the farthest
    float maxDistance = [[[users lastObject] valueForKey:@"distance"] floatValue];
    float minDistance = [[[users firstObject] valueForKey:@"distance"] floatValue];
    
    distanceSlider.minimumValue = minDistance;
    distanceSlider.maximumValue = maxDistance;
    distanceSlider.value = maxDistance;
    
    int iii=0;
    // add users dots
    for (NSDictionary *user in users) {
        
        Dot *dot = [[Dot alloc] initWithFrame:CGRectMake(0, 0, 32.0, 32.0)];
        if (IS_IPHONE)
        {
            dot.frame = CGRectMake(0, 0, 20.0, 20.0);
        }
        dot.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
        
        if (iii==0)
        {
            dot.color = [UIColor yellowColor];
        }
        else if (iii==1)
        {
            dot.color = [UIColor blueColor];
        }
        else if (iii==2)
        {
            dot.color = [UIColor greenColor];
        }
        else if (iii==3)
        {
            dot.color = [UIColor whiteColor];
        }
        else if (iii==4)
        {
            dot.color = [UIColor redColor];
        }
        else
        {
            dot.color = [UIColor redColor];
        }
        /*else if (iii==6)
        {
            dot.color = [UIColor cyanColor];
        }
        else if (iii==7)
        {
            dot.color = [UIColor purpleColor];
        }
        else
        {
            dot.color = [UIColor greenColor];
        }*/
        CLLocationCoordinate2D userLoc = { [[user valueForKey:@"lat"] floatValue], [[user valueForKey:@"lng"] floatValue] };
        
        float bearing = [self getHeadingForDirectionFromCoordinate:myLoc toCoordinate:userLoc];
        dot.bearing = [NSNumber numberWithFloat:bearing];
        
        float d = [[user valueForKey:@"distance"] floatValue];
        float distance = MAX(10, d * 310.0 / maxDistance); // 140 = radius of the radar circle, so the farthest user will be on the perimiter of radar circle
        NSLog(@"HEY distance=%f",distance);
        if (IS_IPHONE)
        {
            distance = MAX(35, d * 132.0 / maxDistance);
        }
        
        dot.distance = [NSNumber numberWithFloat:distance]; // relative distance
        
        dot.userDistance = [NSNumber numberWithFloat:d];
        dot.userProfile = user;
        dot.zoomEnabled = YES;
        dot.userInteractionEnabled = YES;
        [self rotateDot:dot fromBearing:0 toBearing:bearing atDistance:distance];
        
        [arcsView addSubview:dot];
        
        [dots addObject:dot];
        iii++;
    }
    
    // start timer to detect collision with radar line and blink
    detectCollisionTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                            target:self
                                                          selector:@selector(detectCollisions:)
                                                          userInfo:nil
                                                           repeats:YES];
}

- (void)loadUsers {
    // empty the existing dots from radar
    [self removePreviousDots]; // this is useful if you want to remove existing dots at runtime
    
    // At this point use your own method to load nearby users from server via network request.
    // I'm using some dummy hardcoded users data.
    // Make sure in your returned data the **sorted** by **nearest to farthest**
    nearbyUsers = @[
                 @{@"gender":@"female", @"lat":@48.859873, @"lng":@2.295083, @"distance":@1.1}, // *Nearest*
                 @{@"gender":@"male",   @"lat":@48.859619, @"lng":@2.296101, @"distance":@100.9}, //
                 @{@"gender":@"female", @"lat":@48.856492, @"lng":@2.298515, @"distance":@200.3}, // THE SORTING is
                 @{@"gender":@"male",   @"lat":@48.859718, @"lng":@2.300544, @"distance":@300.6}, // Very IMPORTANT!
                 @{@"gender":@"male",   @"lat":@48.854643, @"lng":@2.289186, @"distance":@500.1}  // *Farthest*
                 ];
    
    // This method should be called after successful return of JSON array from your server-side service
    [self renderUsersOnRadar:nearbyUsers];
}

#pragma mark - Spin the radar view continuously
-(void)spinRadar{
    /**** spin animation object ***/
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.duration = 1;
    spin.toValue = [NSNumber numberWithFloat:-M_PI];
    spin.cumulative = YES;
    spin.removedOnCompletion = NO; // this is to keep on animating after application pause-resume
    spin.repeatCount = MAXFLOAT;
    radarLine.layer.anchorPoint = CGPointMake(-0.18, 0.5);
    
    [radarLine.layer addAnimation:spin forKey:@"spinRadarLine"];
    [radarView.layer addAnimation:spin forKey:@"spinRadarView"];
}

//- (void)startHeadingEvent
//{
//    if (nil == _locManager)
//    {
//        // Retain the object in a property.
//        _locManager = [[CLLocationManager alloc] init];
//        _locManager.delegate = self;
//        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locManager.distanceFilter = kCLDistanceFilterNone;
//        _locManager.headingFilter = kCLHeadingFilterNone;
//        
//        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
//        [_locManager requestWhenInUseAuthorization];
////        [_locManager requestAlwaysAuthorization];
//        [_locManager startUpdatingLocation];
//        [_locManager stopUpdatingLocation];
//        CLLocation *location = [_locManager location];
//        // Configure the new event with information from the location
//    
//        float longitude=location.coordinate.longitude;
//        float latitude=location.coordinate.latitude;
//        
//        NSLog(@"dLongitude : %f", longitude);
//        NSLog(@"dLatitude : %f", latitude);
//    }
//
//
//    // Start heading updates.
//    if ([CLLocationManager headingAvailable]) {
//        [_locManager startUpdatingHeading];
//    }
//}

- (void)rotateArcsToHeading:(CGFloat)angle {
    // rotate the circle to heading degree
    arcsView.transform = CGAffineTransformMakeRotation(angle);
    // rotate all dots to opposite angle to keep the profile image straight up
    /*for (Dot *dot in dots) {
     dot.transform = CGAffineTransformMakeRotation(-angle);
     }*/
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return -degree;
    } else {
        return -(360+degree);
    }
}

#pragma mark - Rotate/Trsnslate Dot

- (void)rotateDot:(Dot*)dot fromBearing:(CGFloat)fromDegrees toBearing:(CGFloat)degrees atDistance:(CGFloat)distance {
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    if (IS_IPHONE)
    {
        CGPathAddArc(path,nil, DEVICE_WIDTH/2, DEVICE_WIDTH/2, distance, degreesToRadians(fromDegrees), degreesToRadians(degrees), YES);
    }
    else
    {
        CGPathAddArc(path,nil, 350, 350, distance, degreesToRadians(fromDegrees), degreesToRadians(degrees), YES);
    }
    
    CAKeyframeAnimation *theAnimation;
    
    // animation object for the key path
    theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    theAnimation.path=path;
    CGPathRelease(path);
    
    // set the animation properties
    theAnimation.duration=3;
    theAnimation.removedOnCompletion = NO;
    theAnimation.repeatCount = 0;
    theAnimation.autoreverses = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.cumulative = YES;
    
    
    CGPoint newPosition = CGPointMake(distance*cos(degreesToRadians(degrees))+348, distance*sin(degreesToRadians(degrees))+348);
    if (IS_IPHONE)
    {
        newPosition = CGPointMake(distance*cos(degreesToRadians(degrees))+DEVICE_WIDTH/2, distance*sin(degreesToRadians(degrees))+DEVICE_WIDTH/2);
    }
    dot.layer.position = newPosition;
    
    
    [dot.layer addAnimation:theAnimation forKey:@"rotateDot"];
    
}

- (void)translateDot:(Dot*)dot toBearing:(CGFloat)degrees atDistance:(CGFloat)distance {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [animation setFromValue:[NSValue valueWithCGPoint:[[dot.layer.presentationLayer valueForKey:@"position"] CGPointValue] ]];
    
    CGPoint newPosition = CGPointMake(distance*cos(degreesToRadians(degrees))+348, distance*sin(degreesToRadians(degrees))+348);
    if (IS_IPHONE)
    {
        newPosition = CGPointMake(distance*cos(degreesToRadians(degrees))+DEVICE_WIDTH/2, distance*sin(degreesToRadians(degrees))+DEVICE_WIDTH/2);
    }
    [animation setToValue:[NSValue valueWithCGPoint: newPosition]];
    
    [animation setDuration:0.3f];
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.cumulative = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [alphaAnimation setDuration:0.5f];
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.autoreverses = NO;
    alphaAnimation.repeatCount = 0;
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.cumulative = YES;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    if (IS_IPHONE)
    {
        if (distance > (DEVICE_WIDTH/2)-8)
        {
            [alphaAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
        }
        else
        {
            [alphaAnimation setToValue:[NSNumber numberWithFloat:1.0f]];
        }
    }
    else
    {
        if (distance > 342)
        {
            [alphaAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
        }
        else
        {
            [alphaAnimation setToValue:[NSNumber numberWithFloat:1.0f]];
        }
    }
    
    [dot.layer addAnimation:alphaAnimation forKey:@"alphaDot"];
    
    [dot.layer addAnimation:animation forKey:@"translateDot"];
    
}

#pragma mark - Tap Event on Dot
- (void)onDotTapped:(UITapGestureRecognizer *)recognizer {
    
    UIView *circleView = recognizer.view;
    
    CGPoint point = [recognizer locationInView:circleView];
    
    // The for loop is to find out multiple dots in vicinity
    // you may define a NSMutableArray before the for loop and
    // get the group of dots together
    NSMutableArray *tappedUsers = [NSMutableArray array];
//    topView.frame=CGRectMake(0,-88, 705, 88);
    topView.hidden = YES;
    selectedIndex = 0;
    NSInteger ii=0;
    
    for (Dot *d in dots)
    {
        if (d.zoomEnabled)
        {
            // remove selection from previously selected dot(s)
            d.zoomEnabled = NO;
            d.layer.borderColor = [UIColor clearColor].CGColor;
            [d setNeedsDisplay];
        }
        
        if([d.layer.presentationLayer hitTest:point] != nil)
        {
           // selectedIndex
            if ([filteredContacts count]>0)
            {
                selectedIndex = ii;
                NSString * nameStr = [[filteredContacts objectAtIndex:ii] valueForKey:@"name"];
                namelbl.text = nameStr;
                if (ii==0 || ii ==1)
                {
                    shipImg.image = [UIImage imageNamed:@"boat.png"];
                    shipImg.frame = CGRectMake(5,11.5,50,23);
                    if (IS_IPAD)
                    {
                        shipImg.frame = CGRectMake(5,27.5,72,33);
                    }
                }
                else
                {
                    shipImg.image = [UIImage imageNamed:@"diver_default.png"];
                    shipImg.frame = CGRectMake(5,5,34,33);
                    if (IS_IPAD)
                    {
                        shipImg.frame = CGRectMake(5,9,73,70);
                    }
                }
            }
            else
            {
                NSString * nameStr = [filteredContacts objectAtIndex:0];
                namelbl.text = nameStr;
            }
            [tappedUsers addObject:d]; // use this variable outside of for loop to get list of users

            // Show white border for selected dot(s) and zoom out a little bit
            d.layer.borderColor = [UIColor colorWithRed:(3.0f/255.0) green:(253.0f/255.0) blue:(6.0f/255.0) alpha:0.8].CGColor;
            d.layer.borderWidth = 1;
            d.layer.cornerRadius = 16;
            if (IS_IPHONE)
            {
                d.layer.cornerRadius = 10;
            }
            [d setNeedsDisplay];
            
            
            [self pulse:d];
            d.zoomEnabled = YES; // it'll keep a trace of selected dot(s)
            
            [UIView transitionWithView:topView
                              duration:0.30
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                
                                topView.hidden = NO;
//                                topView.frame=CGRectMake(0,64, 705, 88);
                    }
                            completion:nil];
        }
        ii = ii + 1;
    }
    // use tappedUsers variable according to your app logic
}
#pragma mark - Detect Collisions

- (void)detectCollisions:(NSTimer*)theTimer
{
    float radarLineRotation = radiandsToDegrees( [[radarLine.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue] );
    
    if (radarLineRotation >= 0) {
        radarLineRotation -= 360;
    }
    
    
    for (int i = 0; i < [dots count]; i++) {
        Dot *dot = [dots objectAtIndex:i];
        
        float dotBearing = [dot.bearing floatValue] - currentDeviceBearing;
        
        if (dotBearing < -360) {
            dotBearing += 360;
        }
        
        // collision detection
        if( ABS(dotBearing - radarLineRotation) <=  20)
        {
            [self pulse:dot];
            
        }
    }
}
-(void)pulse:(Dot*)dot{
    if([dot.layer.animationKeys containsObject:@"pulse"] || dot.zoomEnabled){ // view is already animating. so return
        return;
    }
    
    CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = 0.15;
    pulse.toValue = [NSNumber numberWithFloat:1.4];
    pulse.autoreverses = YES;
    dot.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    [dot.layer addAnimation:pulse forKey:@"pulse"];
}

#pragma mark - Button Events
-(void)moveToRadar
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)moveToMessage
{
//    History_IpadVCViewController * hstVC =[[History_IpadVCViewController alloc] init];
//    [self.navigationController pushViewController:hstVC animated:NO];
//    NSLog(@"msgfrom Raddar");
}
#pragma mark - Slider
- (IBAction)sliderValueChange:(UISlider *)sender {
    float new_distance = [sender value];
    float distanceFilter = 0;
    for (int i = 0; i < [nearbyUsers count]; i++) {
        NSDictionary *user = nearbyUsers[i];
        
        float distance = [[user valueForKey:@"distance"] floatValue];
        float nextDistance = distance;
        //NSLog(@"distance %f <--->nextDistance %f ===>distanceFilter %f",distance, nextDistance, distanceFilter);
        
        if (i< [nearbyUsers count]-1) {
            NSDictionary *nextUser = nearbyUsers[i+1];
            nextDistance = [[nextUser valueForKey:@"distance"] floatValue];
        }
        
        if (distance <= new_distance && nextDistance >= new_distance) {
            if (nextDistance == new_distance) {
                distanceFilter = nextDistance;
            }else{
                distanceFilter = distance;
            }
            //NSLog(@"%f <---> %f ===> %f",distance, nextDistance, distanceFilter);
            break;
        }
    }
    //NSLog(@"distance filter %f", distanceFilter);
    [self filterNearByUsersByDistance: distanceFilter];
}

// for this function to work, sorting of users data by distance in ASC order (nearest to farthest) is a must
-(void) filterNearByUsersByDistance: (float)maxDistance{
    for (id d in dots) {
        Dot *dot = (Dot *)d;
        float distance = MAX(65,[dot.userDistance floatValue] * 290.0 / maxDistance);
        [self translateDot:dot toBearing:[dot.bearing floatValue] atDistance: distance];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    float heading = newHeading.magneticHeading; //in degrees
    float headingAngle = -(heading*M_PI/180); //assuming needle points to top of iphone. convert to radians
    currentDeviceBearing = heading;
    //    circle.transform = CGAffineTransformMakeRotation(headingAngle);
    [self rotateArcsToHeading:headingAngle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissAllPopTipViews
{
    while ([self.visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:YES];
        [self.visiblePopTipViews removeObjectAtIndex:0];
    }
}

#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}
#pragma mark - UIViewController methods

- (void)willAnimateRotationToInterfaceOrientation:(__unused UIInterfaceOrientation)toInterfaceOrientation duration:(__unused NSTimeInterval)duration
{
    for (CMPopTipView *popTipView in self.visiblePopTipViews) {
        id targetObject = popTipView.targetObject;
        [popTipView dismissAnimated:NO];
        
        if ([targetObject isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)targetObject;
            [popTipView presentPointingAtView:button inView:self.view animated:NO];
        }
        else {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)targetObject;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    
    
    CLLocation * currentLocation = [locations lastObject];
    
    NSLog(@"Updated Lat %f",currentLocation.coordinate.longitude);
    NSLog(@"Updated Lang %f",currentLocation.coordinate.latitude);
    
    
    
}
@end
/*
  */
