//
//  ScanVC.m
//  SC4App18
//
//  Created by stuart watts on 27/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "ScanVC.h"
#import "ScanviewCell.h"
#import "SYCompassView.h"
#import "LeftMenuCell.h"
@interface ScanVC ()
{
    BOOL isConnected;
    NSTimer * timerOut;
    NSMutableArray * arrLignlightDevice;
    NSInteger lignDeviceIndex;
    NSInteger selectedContactIndex;
    BOOL isAppearedScanVC;
}
@end

@implementation ScanVC

- (void)viewDidLoad
{
    isScanForLignlight = false;
    [[[BLEManager sharedManager]foundDevices] removeAllObjects];
    arrLignlightDevice = [[NSMutableArray alloc]init];
    NSArray * tmpArr = [[NSArray alloc]initWithObjects:@"Dev 1",@"Dev 2",@"Dev 3",@"Dev 4", nil];
    int tmpID = 12345;
    for (int i = 0; i <tmpArr.count; i++)
    {
        NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[tmpArr objectAtIndex:i],@"deviceName",@"NA",@"isAssignedTo",[NSString stringWithFormat:@"%d",tmpID],@"address", nil];
        [arrLignlightDevice addObject:tmpDict];
        tmpID = tmpID+1;
    }
    NSLog(@"lignlight array is %@",arrLignlightDevice);
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
    [lblTitle setText:@"Scan Device"];
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
    btnBack.frame = CGRectMake(0, 0, 140, 64);
    btnBack.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnBack];
    
    UIImageView * imgRefresh = [[UIImageView alloc] init];
    imgRefresh.frame = CGRectMake(viewWidth-50, 20+9, 24, 26);
    imgRefresh.image = [UIImage imageNamed:@"MNMPullToRefreshIcon.png"];
    [viewHeader addSubview:imgRefresh];
    
    UIButton * btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRefresh.frame = CGRectMake(viewWidth-110, 0, 110, 64);
    [btnRefresh addTarget:self action:@selector(btnRefreshClick) forControlEvents:UIControlEventTouchUpInside];
    btnRefresh.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnRefresh];
    
    if (IS_IPHONE)
    {
        imgRefresh.frame = CGRectMake(viewWidth-40, 20+11, 20, 22);
        if (IS_IPHONE_X)
        {
            imgRefresh.frame = CGRectMake(viewWidth-40, 24+20+11, 20, 22);
            btnRefresh.frame = CGRectMake(viewWidth-70, 0, 70, 88);
            viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
            lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
            backImg.frame = CGRectMake(10, 12+44, 12, 20);
            btnBack.frame = CGRectMake(0, 0, 70, 88);
        }
    }
    
    //    UIImageView * imgUpper = [[UIImageView alloc] init];
    //    imgUpper.frame = CGRectMake((viewWidth-650)/2, 24+((DEVICE_HEIGHT-650)/2), 650, 650);
    //    imgUpper.image = [UIImage imageNamed:@"compass.png"];
    //    [self.view addSubview:imgUpper];
    
    //
    //    UILabel * lblSubHint = [[UILabel alloc] initWithFrame:CGRectZero];
    //    lblSubHint.backgroundColor = [UIColor clearColor];
    //    lblSubHint.frame=CGRectMake(0, 64+32, 707, 25);
    //    lblSubHint.font = [UIFont systemFontOfSize:14];
    //    lblSubHint.textAlignment = NSTextAlignmentCenter;
    //    [lblSubHint setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
    //    lblSubHint.textColor = [UIColor whiteColor]; // change this color
    //    lblSubHint.text = NSLocalizedString(@"(Tap on any Device to Connect)",@"");
    //    [self.view addSubview:lblSubHint];
    //
    //    SYCompassView *compassView = [SYCompassView sharedWithRect:CGRectMake(51, 51+64, 600, 600) radius:(600)/2];
    ////    compassView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    //    compassView.textColor = [UIColor whiteColor];
    //    compassView.calibrationColor = [UIColor whiteColor];
    //    compassView.horizontalColor = [UIColor redColor];
    //    compassView.layer.masksToBounds = YES;
    ////    compassView.layer.cornerRadius = 300;
    ////    compassView.layer.borderWidth = 0/5;
    //    [self.view addSubview:compassView];
    
    contactArr = [[NSMutableArray alloc] init];
    NSString * strcontQr = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strcontQr resultsArray:contactArr];
    for (int i=0; i<[contactArr count]; i++)
    {
        if ([[APP_DELEGATE checkforValidString:[[contactArr objectAtIndex:i] valueForKey:@"lignlight_Ble_Address"]] isEqualToString:@"NA"])
        {
            [[contactArr objectAtIndex:i] setObject:@"NA" forKey:@"isAssigned"];
        }
        else
        {
            [[contactArr objectAtIndex:i] setObject:@"YES" forKey:@"isAssigned"];
        }
    }
    
    [self setupMainContentView:headerhHeight+34];
    
    


    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setupMainContentView:(int)headerHeights
{
    //    int bottomHeight = 60;
    //    if (IS_IPHONE_X)
    //    {
    //        bottomHeight = 60 + 45;
    //    }
    //
    
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, headerHeights, viewWidth-60, DEVICE_HEIGHT-headerHeights);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    
    blueSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"SC4 Device",@"Lignlight Device"]];
    blueSegmentedControl.titleTextColor = [UIColor blackColor];
    blueSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    blueSegmentedControl.segmentIndicatorBackgroundColor = [UIColor blackColor];
    blueSegmentedControl.backgroundColor = [UIColor whiteColor];
    blueSegmentedControl.borderWidth = 0.0f;
    blueSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    blueSegmentedControl.segmentIndicatorInset = 2.0f;
    blueSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    blueSegmentedControl.cornerRadius = 20;
    blueSegmentedControl.usesSpringAnimations = YES;
    [blueSegmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        [blueSegmentedControl setFrame:CGRectMake(0,0, viewWidth-60, 50)];
    blueSegmentedControl.layer.cornerRadius = 20;
    blueSegmentedControl.layer.masksToBounds = YES;
    blueSegmentedControl.titleFont = [UIFont fontWithName:CGRegular size:textSize+1];
    blueSegmentedControl.selectedTitleFont = [UIFont fontWithName:CGRegular size:textSize+1];;
    [backView addSubview:blueSegmentedControl];
    
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, viewWidth-60, DEVICE_HEIGHT-50)];
    tblView.rowHeight=80;
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    [backView addSubview:tblView];
    
    if (IS_IPHONE)
    {
        backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights);
        tblView.frame=CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-60);
    }
    
    lblScanning = [[UILabel alloc] init];
    lblScanning.frame = CGRectMake(0, headerHeights, viewWidth, DEVICE_HEIGHT-headerHeights);
    lblScanning.font = [UIFont fontWithName:CGRegular size:textSize+2];
    lblScanning.textColor = [UIColor whiteColor];
    lblScanning.text = @"Scanning for Device....";
    lblScanning.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblScanning];
}
-(void)segmentClick:(NYSegmentedControl *) sender
{
    if (sender.selectedSegmentIndex==0)
    {
        isScanForLignlight = false;
    }
    else if (sender.selectedSegmentIndex==1)
    {
        compareContactArr = [[NSMutableArray alloc] init];
        NSString * strcontQr = [NSString stringWithFormat:@"select * from NewContact"];
        [[DataBaseManager dataBaseManager] execute:strcontQr resultsArray:compareContactArr];

        isScanForLignlight = true;
    }
    [[[BLEManager sharedManager]foundDevices]removeAllObjects];
    [[BLEManager sharedManager]rescan];
    [tblView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lignLightAssignAck" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lignLightAssignAck) name:@"lignLightAssignAck" object:nil];

    [self InitialBLE];

    [[[BLEManager sharedManager] foundDevices] removeAllObjects];
    [tblView reloadData];
    [[BLEManager sharedManager] rescan];

    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (isAppearedScanVC == NO)
    {
        NSArray * connectedArr = [[BLEManager sharedManager]getLastConnected];
        for (int i=0; i<connectedArr.count; i++)
        {
            CBPeripheral * p = [connectedArr objectAtIndex:i];
            [[BLEManager sharedManager]disconnectDevice:p];
        }
        isAppearedScanVC = YES;
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallNotificationforDiscover" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deviceDidConnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deviceDidDisConnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lignLightAssignAck" object:nil];
    
    [[BLEManager sharedManager]stopScan];
    [super viewWillDisappear:animated];
}
-(void)btnRefreshClick
{
    [[[BLEManager sharedManager] foundDevices] removeAllObjects];
    [tblView reloadData];
    [[BLEManager sharedManager] rescan];
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==tblContact)
    {
        return  [contactArr count];
    }
    else
    {
        if (isScanForLignlight)
        {
            return [[[BLEManager sharedManager] foundDevices] count];
        }
        else
        {
            return [[[BLEManager sharedManager] foundDevices] count];
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 60;
    if (IS_IPHONE)
    {
        height = 50;
    }
    
    if (tableView ==tblContact)
    {
        NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[LeftMenuCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.lblName.frame = CGRectMake(20, 0, viewWidth-40, height);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString * strName = [[contactArr objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblName.text= strName;
        
        cell.lblBiometrics.hidden = false;
        cell.lblBleAdd.hidden = false;
        cell.lblBiometrics.frame = CGRectMake(tblContact.frame.size.width-165, 0, 160, (height/2)+5);
        cell.lblBleAdd.frame = CGRectMake(tblContact.frame.size.width-165, (height/2), 160, (height/2)-5);
        
        if (![[APP_DELEGATE checkforValidString:[[contactArr objectAtIndex:indexPath.row]valueForKey:@"lignlight_Ble_Address"]]isEqualToString:@"NA"])
        {
            cell.lblBiometrics.text= [NSString stringWithFormat:@"%@ Biometrics",strName];
            cell.lblBleAdd.text= [NSString stringWithFormat:@"%@",[[contactArr objectAtIndex:indexPath.row]valueForKey:@"lignlight_Ble_Address"]];

        }
        
        cell.lblLine.hidden = YES;
        cell.imgArrow.hidden = YES;
        cell.lblBack.hidden = YES;

        return cell;
    }
    else
    {
        NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        ScanviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[ScanviewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblConnect.frame = CGRectMake(viewWidth-200,00, 120, 70);
        cell.lblname.frame = CGRectMake(20,10, viewWidth/2, 35);
        cell.lbldiviceid.frame = CGRectMake(20,35, 200, 35);

        NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
        arrayDevices =[[BLEManager sharedManager] foundDevices];
        if (isScanForLignlight == false)
        {
            cell.lblname.text= @"SC4 Device";
            if (isScanForLignlight)
            {
                cell.lblname.text= @"Lignlight Device";
            }
            if ([arrayDevices count]>0)
            {
                lblScanning.hidden = true;
                CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
                cell.lblname.text=p.name;
                if (![[APP_DELEGATE checkforValidString:[[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"deviceName"]] isEqualToString:@"NA"])
                {
                    cell.lblname.text=[[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"deviceName"];

                }
                [[[[BLEManager sharedManager] foundDevices] objectAtIndex:indexPath.row] setObject:p.name forKey:@"Assigned_name"];
                if ([[contactArr valueForKey:@"SC4_Ble_address"]containsObject:[[arrayDevices objectAtIndex:indexPath.row]valueForKey:@"address"]])
                {
                    long tempID = [[contactArr valueForKey:@"SC4_Ble_address"]indexOfObject:[[arrayDevices objectAtIndex:indexPath.row]valueForKey:@"address"]];
                    if (tempID != NSNotFound)
                    {
                        if (tempID < contactArr.count)
                        {
                            cell.lblname.text = [[contactArr objectAtIndex:tempID]valueForKey:@"name"];
                            [[[[BLEManager sharedManager] foundDevices] objectAtIndex:indexPath.row] setObject:[[contactArr objectAtIndex:tempID]valueForKey:@"name"] forKey:@"Assigned_name"];
                        }
                    }
                }
                cell.lbldiviceid.text = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"address"];
                if (p.state == CBPeripheralStateConnected)
                {
                    cell.lblConnect.text= @"Disconnect";
                }
                else
                {
                    cell.lblConnect.text= @"Connect";
                }
            }
            else
            {
                lblScanning.hidden = false;
            }
        }
        else
        {
            NSMutableArray * deviceArr = [[BLEManager sharedManager] foundDevices];
            if (deviceArr.count > 0)
            {
                lblScanning.hidden = true;
                cell.lbldiviceid.text = [[deviceArr objectAtIndex:indexPath.row] valueForKey:@"address"];
                if ([[APP_DELEGATE checkforValidString:[[deviceArr objectAtIndex:indexPath.row] valueForKey:@"isAssignedTo"]]isEqualToString:@"NA"])
                {
                    cell.lblname.text=[[deviceArr objectAtIndex:indexPath.row] valueForKey:@"deviceName"];
                    
                    if ([[compareContactArr valueForKey:@"lignlight_Ble_Address"] containsObject:[[deviceArr objectAtIndex:indexPath.row]valueForKey:@"address"]])
                    {
                        if (compareContactArr.count >= indexPath.row)
                        {
                            long tempID = [[compareContactArr valueForKey:@"lignlight_Ble_Address"] indexOfObject:[[deviceArr objectAtIndex:indexPath.row]valueForKey:@"address"]];
                            cell.lblname.text = [NSString stringWithFormat:@"%@ Biometrics",[[compareContactArr objectAtIndex:tempID]valueForKey:@"name"]];
                            CBPeripheral * p = [[deviceArr objectAtIndex:indexPath.row] objectForKey:@"peripheral"];
                            if (p.state == CBPeripheralStateConnected)
                            {
                                cell.lblConnect.text = @"Connected";
                            }
                            else
                            {
                                cell.lblConnect.text = @"Connect";
                            }
                        }
                    }
                }
                else
                {
                    cell.lblname.text=[NSString stringWithFormat:@"%@ Biometrics",[[deviceArr objectAtIndex:indexPath.row] valueForKey:@"isAssignedTo"]];
                    cell.lblConnect.text = @"Connected";
//                    cell.userInteractionEnabled = false;

                }
            }
            else
            {
                lblScanning.hidden = false;
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == tblContact)
    {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
    }
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblContact)
    {
        return 60;
    }
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblContact)
    {
        NSString * strAssign = [APP_DELEGATE checkforValidString:[[contactArr objectAtIndex:indexPath.row]valueForKey:@"isAssigned"]];
//        if ([strAssign isEqualToString:@"NA"] || [strAssign isEqualToString:@"NO"])
        {
            isSynced = false;
            [APP_DELEGATE startHudProcess:@"Assigning Nano Modem Id..."];
            [acknowldgeTimer invalidate];
            acknowldgeTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(acknowldgeTimer) userInfo:nil repeats:NO];
            selectedContactIndex = indexPath.row;
            [self SyncNanoIdtoLignlight];
        }
        [self hideMorePopUpView:YES];
    }
    else
    {
        if(isScanForLignlight == false)
        {
            [timerOut invalidate];
            timerOut = nil;
            timerOut = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkConnected) userInfo:nil repeats:NO];
            
            //    [self performSelector:@selector(checkConnected) withObject:nil afterDelay:5];
            NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
            arrayDevices =[[BLEManager sharedManager] foundDevices];
            if ([arrayDevices count]>indexPath.row)
            {
                CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
                strGlobalSC4BLEAddress = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"address"];
                strGlobalPeripheralName = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"Assigned_name"];
                globalPeripheral = p;
                if (p.state == CBPeripheralStateConnected)
                {
                    [APP_DELEGATE endHudProcess];
                    [APP_DELEGATE startHudProcess:@"Disconnecting...."];
                    [self onDisconnectWithDevice:p];
                }
                else
                {
                    [APP_DELEGATE endHudProcess];
                    [APP_DELEGATE startHudProcess:@"Connecting...."];
                    [self onConnectWithDevice:p];
                }
            }
            else
            {
                [self btnRefreshClick];
            }
        }
        else
        {
            
            [timerOut invalidate];
            timerOut = nil;
            timerOut = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkConnected) userInfo:nil repeats:NO];

            NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
            arrayDevices =[[BLEManager sharedManager] foundDevices];
            lignDeviceIndex = indexPath.row;
            if ([arrayDevices count]>indexPath.row)
            {
                CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
                strGlobalSC4BLEAddress = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"address"];
                lignLightPeripheral = p;
                if (p.state == CBPeripheralStateConnected)
                {
                    isConnected = YES;
                    [[BLEService sharedInstance] sendNotifications:lignLightPeripheral withType:NO];
                    selectedIndex = lignDeviceIndex;
                    isCotactViewOpened = true;
                    [self setupConctactTable];
                }
                else
                {
                    [APP_DELEGATE endHudProcess];
                    [APP_DELEGATE startHudProcess:@"Connecting...."];
                    [[BLEManager sharedManager] connectDevice:p];
                }
            }
            else
            {
                [self btnRefreshClick];
            }
        }
    }
}
-(void)SyncNanoIdtoLignlight
{
//    NSLog(@"contact=%@  and index=%ld",contactArr,(long)selectedContactIndex);
    NSInteger intCmnd = 1;
    NSData  * cmdData = [[NSData alloc] initWithBytes:&intCmnd length:1];
    
    NSInteger intLength = [@"08" integerValue];
    NSData * lengthData = [[NSData alloc] initWithBytes:&intLength length:1];
    
    NSInteger sc4Int = [[[contactArr objectAtIndex:selectedContactIndex] valueForKey:@"SC4_nano_id"] integerValue];//this is selected contact's sc4_nano_id
    NSData * sc4NanoData = [[NSData alloc] initWithBytes:&sc4Int length:4];
    
    NSInteger lineLightInt = [[[contactArr objectAtIndex:selectedContactIndex] valueForKey:@"lignlight_nano_id"] integerValue];//this is selected contact's lignlight_nano_id
    NSData * lineLightNanoData = [[NSData alloc] initWithBytes:&lineLightInt length:4];
    
    NSMutableData *completeData = [cmdData mutableCopy];
    [completeData appendData:lengthData];
    [completeData appendData:sc4NanoData];
    [completeData appendData:lineLightNanoData];
    NSLog(@"complete data is %@",completeData);
    [[BLEService sharedInstance] SendDatatodevice:completeData withPeripheral:lignLightPeripheral];
}
-(void)lignLightAssignAck
{
    NSString * strSelectedBLE = [[[[BLEManager sharedManager] foundDevices] objectAtIndex:selectedIndex]valueForKey:@"address"];
    isCotactViewOpened = false;
    [[[[BLEManager sharedManager] foundDevices] objectAtIndex:selectedIndex]setValue:[[contactArr objectAtIndex:selectedContactIndex]valueForKey:@"name"] forKey:@"isAssignedTo"];
    
    for (int i=0; i<[contactArr count]; i++)
    {
        if ([[[contactArr objectAtIndex:i] valueForKey:@"lignlight_Ble_Address"] isEqualToString:strSelectedBLE])
        {
            [[contactArr objectAtIndex:i] setObject:@"" forKey:@"lignlight_Ble_Address"];
            [[contactArr objectAtIndex:i] setObject:@"" forKey:@"isAssignedTo"];
            [[contactArr objectAtIndex:i] setObject:@"NO" forKey:@"isAssigned"];
        }
    }
    [[contactArr objectAtIndex:selectedContactIndex]setValue:@"YES" forKey:@"isAssigned"];
    [[contactArr objectAtIndex:selectedContactIndex]setValue:strSelectedBLE forKey:@"lignlight_Ble_Address"];

    NSString * strClear = [NSString stringWithFormat:@"Update NewContact set lignlight_Ble_Address='' where lignlight_Ble_Address ='%@'",strSelectedBLE];
    [[DataBaseManager dataBaseManager] execute:strClear];
    
    NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set lignlight_Ble_Address = '%@' where id = '%@'",strSelectedBLE,[[contactArr objectAtIndex:selectedContactIndex]valueForKey:@"id"]];
    [[DataBaseManager dataBaseManager] execute:strUpdate];
    
    isSynced = true;
    [APP_DELEGATE endHudProcess];
    [acknowldgeTimer invalidate];
    [[BLEManager sharedManager]disconnectDevice:lignLightPeripheral];
    [[BLEManager sharedManager] rescan];
    [tblView reloadData];
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeSuccess];
    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:@"Diver assigned successfully to Lignlight device."
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];


}
#pragma mark - View for Choosing Contacts
-(void)setupConctactTable
{
    [viewOverLay removeFromSuperview];
    viewOverLay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT)];
    [viewOverLay setBackgroundColor:[UIColor colorWithRed:97/255.0f green:97/255.0f blue:97/255.0f alpha:0.5]];
    viewOverLay.userInteractionEnabled = YES;
    [self.view addSubview:viewOverLay];
    
    backContactView = [[UIImageView alloc] init];
    backContactView.frame = CGRectMake(80, DEVICE_HEIGHT, viewWidth-160, 600);
    backContactView.image = [UIImage imageNamed:@"pop_up_bg.png"];
    backContactView.userInteractionEnabled = YES;
    [self.view addSubview:backContactView];
    
    UILabel * lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(0, 30, backContactView.frame.size.width, 50);
    lblTitle.font = [UIFont fontWithName:CGRegular size:textSize];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text = @"Select Contact";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [backContactView addSubview:lblTitle];
    
    UILabel * lblline = [[UILabel alloc] init];
    lblline.frame = CGRectMake(34, 30+49, backContactView.frame.size.width-68, 0.5);
    lblline.backgroundColor = [UIColor lightGrayColor];
    [backContactView addSubview:lblline];
    
    UIButton * btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(20, 30, 120, 50);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-1];
    [btnCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
    [backContactView addSubview:btnCancel];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(backContactView.frame.size.width-130, 30, 100, 50);
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-1];
    [btnDone setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
//    [backContactView addSubview:btnDone];
    
    tblContact=[[UITableView alloc]init];
    tblContact.delegate=self;
    tblContact.dataSource=self;
    tblContact.frame = CGRectMake(27, 80, backContactView.frame.size.width-54, backContactView.frame.size.height-60-60);
    tblContact.backgroundColor=[UIColor clearColor];
    [tblContact setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblContact setSeparatorColor:[UIColor clearColor]];
    [backContactView addSubview:tblContact];
    
    if (IS_IPHONE)
    {
        backContactView.image = [UIImage imageNamed:@" "];
        backContactView.backgroundColor = [UIColor blackColor];
        backContactView.layer.cornerRadius = 10;
        backContactView.layer.borderWidth = 1.0;
        backContactView.layer.masksToBounds = YES;
        backContactView.frame = CGRectMake(10, DEVICE_HEIGHT, viewWidth-20, DEVICE_HEIGHT-80);
        lblTitle.frame = CGRectMake(0, 0, backContactView.frame.size.width, 50);
        lblline.frame = CGRectMake(10, 49, backContactView.frame.size.width-20, 0.5);
        btnCancel.frame = CGRectMake(0, 0, 60, 50);
        btnDone.frame = CGRectMake(backContactView.frame.size.width-60, 0, 60, 50);
        tblContact.frame = CGRectMake(0, 50, backContactView.frame.size.width-0, 400-50);
    }
    
    [self hideMorePopUpView:NO];
    
    
}
-(void)hideMorePopUpView:(BOOL)isHide
{
    if (isHide == YES)
    {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionOverrideInheritedCurve
                         animations:^{
                             if (IS_IPHONE)
                             {
                                 backContactView.frame = CGRectMake(10, DEVICE_HEIGHT, viewWidth-20, DEVICE_WIDTH-80);
                             }
                             else
                             {
                                 backContactView.frame = CGRectMake(80, DEVICE_HEIGHT, viewWidth-160, 600);
                             }
                         }
                         completion:^(BOOL finished){
                             [viewOverLay removeFromSuperview];
                             [backContactView removeFromSuperview];
                             [tblContact removeFromSuperview];
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionOverrideInheritedCurve
                         animations:^{
                             if (IS_IPHONE)
                             {
                                 backContactView.frame = CGRectMake(10, (DEVICE_HEIGHT-400)/2, viewWidth-20, 400);
                             }
                             else
                             {
                                 backContactView.frame = CGRectMake(80, 84, viewWidth-160, 600);
                             }
                         }
                         completion:^(BOOL finished){
                         }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - All Button Click Methods
-(void)btnCloseClick
{
    [[BLEManager sharedManager] disconnectDevice:lignLightPeripheral];
    isCotactViewOpened = false;
    [self hideMorePopUpView:YES];
}
#pragma mark - BLE Methods

-(void)InitialBLE
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallNotificationforDiscover" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deviceDidDisConnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deviceDidConnectNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverPeripheralNotification:) name:@"CallNotificationforDiscover" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDidConnectNotification:) name:@"deviceDidConnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDidDisConnectNotification:) name:@"deviceDidDisConnectNotification" object:nil];
}
-(void)onConnectButton:(id)sender//Connect & DisconnectClicked
{
    NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
    arrayDevices =[[BLEManager sharedManager] foundDevices];
    if ([[[BLEManager sharedManager] foundDevices] count]>0)
    {
        CBPeripheral * p = [arrayDevices objectAtIndex:[sender tag]];
        globalPeripheral = p;
        if (p.state == CBPeripheralStateConnected)
        {
            [APP_DELEGATE endHudProcess];
            [APP_DELEGATE startHudProcess:@"Disconnecting...."];
            [self onDisconnectWithDevice:p];
        }
        else
        {
            [APP_DELEGATE endHudProcess];
            [APP_DELEGATE startHudProcess:@"Connecting...."];
            [self onConnectWithDevice:p];
        }
    }
}
#pragma mark - Ble device Disconnect method
-(void)onDisconnectWithDevice:(CBPeripheral*)peripheral
{
    [timerOut invalidate];
    [[BLEManager sharedManager] disconnectDevice:peripheral];
}
#pragma mark - Ble device Connect method

-(void)onConnectWithDevice:(CBPeripheral*)peripheral
{
    [[BLEManager sharedManager] connectDevice:peripheral];
}
-(void)didDiscoverPeripheralNotification:(NSNotification*)notification//Update peripheral
{
    if (isScanForLignlight)
    {
        
    }
    [tblView reloadData];
}
-(void)DeviceDidConnectNotification:(NSNotification*)notification//Connect periperal
{
    [APP_DELEGATE endHudProcess];
    [timerOut invalidate];
    isConnected = YES;
    if (isScanForLignlight)
    {
        [[BLEService sharedInstance] sendNotifications:lignLightPeripheral withType:NO];
            selectedIndex = lignDeviceIndex;
            isCotactViewOpened = true;
            [self setupConctactTable];
    }
    else
    {
        [[BLEService sharedInstance] sendNotifications:globalPeripheral withType:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)DeviceDidDisConnectNotification:(NSNotification*)notification//Disconnect periperal
{
    NSLog(@"device got disconnect");
    [tblView reloadData];
}
-(void)checkConnected
{
    [APP_DELEGATE endHudProcess];
    if (isConnected)
    {
    }
    else
    {
        if (isScanForLignlight)
        {
            [[BLEManager sharedManager] disconnectDevice:lignLightPeripheral];
        }
        else
        {
            [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
        }
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeCaution];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Something went wrong. Please try again to connect."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
        
    }
}
-(void)acknowldgeTimer
{
    [APP_DELEGATE endHudProcess];
    if (isSynced == false)
    {
        [[BLEManager sharedManager] disconnectDevice:lignLightPeripheral];
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeCaution];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Something went wrong. Please try again to Sync."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
}
-(void)scanningForDeviceTimerMethod
{
    [APP_DELEGATE endHudProcess];
    //ask kp if its for sc4 or lignlight
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeCaution];
    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:@"Something went wrong. Please try again to Connect."
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];

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
