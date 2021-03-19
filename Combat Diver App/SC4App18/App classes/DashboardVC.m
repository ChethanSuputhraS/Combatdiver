//
//  DashboardVC.m
//  SC4App18
//
//  Created by stuart watts on 17/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "DashboardVC.h"
#import "DashboardCell.h"
#import "ChatVC.h"
#import "ScanVC.h"
#import "ComposeMsgVC.h"
#import "SettingsVC.h"
#import "RadarViewController.h"
#import <Lottie/Lottie.h>
#import "CompassViewController.h"
#import "CompassVC.h"
#import "LocateVC.h"
#import "HomingVC.h"

@interface DashboardVC ()<UISplitViewControllerDelegate>
-(void)onListButtonAction:(id)sender;
-(UIBarButtonItem*)createBarButtonList;
@end

@implementation DashboardVC

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[APP_DELEGATE getbackgroundImage]];
    [self.view addSubview:imgBack];
    
    [pulseView removeFromSuperview];
    pulseView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, DEVICE_WIDTH, DEVICE_HEIGHT-240)];
    pulseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:pulseView];
    
    ripple = [[WZFlashButton alloc] initWithFrame:CGRectMake(pulseView.frame.size.width/2-100/2, pulseView.frame.size.height/2-100/2, 100, 100)];
    ripple.buttonType = WZFlashButtonTypeOuter;
    ripple.layer.cornerRadius = 50;
    ripple.flashColor = [UIColor colorWithRed:(20.0/255.0) green:(147.0/255.0) blue:(5.0/255.0) alpha:1];
    ripple.backgroundColor = [UIColor colorWithRed:(20.0/255.0) green:(147.0/255.0) blue:(5.0/255.0) alpha:1];
    ripple.backgroundColor = [UIColor clearColor];
    
    [pulseView addSubview:ripple];
    
    imgScanner = [[UIImageView alloc] init];
    imgScanner.image = [UIImage imageNamed:@"scan-icon.png"];
    imgScanner.frame= CGRectMake(pulseView.frame.size.width/2-187/2, pulseView.frame.size.height/2-200/2, 187, 200);
    imgScanner.backgroundColor = [UIColor clearColor];
    [pulseView addSubview:imgScanner];
    
    if (IS_IPAD)
    {
        viewWidth = 704;
        imgBack.frame = CGRectMake(0, 0, 704, DEVICE_HEIGHT);
        imgBack.image = [UIImage imageNamed:@"Ipadright_bg.png"];
        imgBack.image = [UIImage imageNamed:@"right_bg.png"];
        pulseView.frame = CGRectMake(0, 74+45, viewWidth, DEVICE_HEIGHT-74-45);
        ripple.frame = CGRectMake(pulseView.frame.size.width/2-150/2, pulseView.frame.size.height/2-150/2, 150, 150);
        ripple.layer.cornerRadius = 75;
        imgScanner.frame= ripple.frame;
    }
    else
    {
        viewWidth = DEVICE_WIDTH;
        imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
        [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
        
        pulseView.frame = CGRectMake(0, 74+65, viewWidth, DEVICE_HEIGHT-74-45);
        ripple.frame = CGRectMake(pulseView.frame.size.width/2-150/2, pulseView.frame.size.height/2-150/2, 150, 150);
        ripple.layer.cornerRadius = 75;
        imgScanner.frame= ripple.frame;
    }
    if (isAnimated)
    {
        btnScan.hidden=YES;
        imgScanner.hidden = YES;
        ripple.hidden=YES;
    }
    [self setupHeaderView];
    
    [self RegisterNotifications];
    
    arrMessages = [[NSMutableArray alloc]init];//KP
    NSString * strUsers = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:arrMessages];
    
    [arrMessages setValue:@"NA" forKey:@"HR"];
    [arrMessages setValue:@"NA" forKey:@"RR"];
    [arrMessages setValue:@"NA" forKey:@"temp"];
    [arrMessages setValue:@"NA" forKey:@"Air"];
    [arrMessages setValue:@"NA" forKey:@"Distance"];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
//    isScanforSC4 = YES;
    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        NSString * strName = strGlobalPeripheralName;
        if ([[APP_DELEGATE checkforValidString:strName] isEqualToString:@"NA"])
        {
            strName = globalPeripheral.name;
        }
        lblConnect.text = [NSString stringWithFormat:@"Connected to %@",strName];
        if ([globalPeripheral.name isEqualToString:@"SC4 Diver 2"])
        {
            lblConnect.text = [NSString stringWithFormat:@"Connected to Boat 1"];
        }
        else
        {
            lblConnect.text = [NSString stringWithFormat:@"Connected to %@",strName];
        }
        lblConnect.textColor = [UIColor greenColor];
        [btnSetup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblConnect.numberOfLines = 0;
    }
    else
    {
        lblConnect.text = @"Connect Device";
        lblConnect.textColor = [UIColor whiteColor];
        [btnSetup setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    tblView.hidden = NO;
    
    
    lblTotalUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[arrMessages count]];
    [tblView reloadData];
    
    if ([arrMessages count]==0)
    {
        tblView.hidden = YES;
    }
    else
    {
        tblView.hidden = NO;
        //        lblNoContacts.hidden = YES;
        [tblView reloadData];
    }
    NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
    tmpArr = [arrMessages mutableCopy];
    arrMessages = [[NSMutableArray alloc]init];//KP
    NSString * strUsers = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:arrMessages];
    for (int i =0; i<[tmpArr count]; i++)
    {
        if ([arrMessages count]>i)
        {
            [[arrMessages objectAtIndex:i] setObject:[self GetBioDatafromArr:[[tmpArr objectAtIndex:i]valueForKey:@"HR"]] forKey:@"HR"];
            [[arrMessages objectAtIndex:i] setObject:[self GetBioDatafromArr:[[tmpArr objectAtIndex:i]valueForKey:@"RR"]] forKey:@"RR"];
            [[arrMessages objectAtIndex:i] setObject:[self GetBioDatafromArr:[[tmpArr objectAtIndex:i]valueForKey:@"temp"]] forKey:@"temp"];
            [[arrMessages objectAtIndex:i] setObject:[self GetBioDatafromArr:[[tmpArr objectAtIndex:i]valueForKey:@"Air"]] forKey:@"Air"];
            [[arrMessages objectAtIndex:i] setObject:[self GetBioDatafromArr:[[tmpArr objectAtIndex:i]valueForKey:@"Distance"]] forKey:@"Distance"];
        }
    }
    [tblView reloadData];
}
-(NSString *)GetBioDatafromArr:(NSString *)strValue
{
    NSString * strReturn = strValue;
    if ([[APP_DELEGATE checkforValidString:strValue] isEqualToString:@"NA"])
    {
        strReturn = @"";
    }
    return strReturn;
}
-(void)setupHeaderView
{
    int headerHeight = 64 ;
    fixedHeight = 64+45;
    
    if (IS_IPAD)
    {
        headerHeight =64;
        fixedHeight = 204;
    }
    else
    {
        if (IS_IPHONE_X)
        {
            headerHeight = 88;
            fixedHeight = 88;
        }
    }
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, fixedHeight)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH,headerHeight)];
    lblBack.backgroundColor = [UIColor blackColor];
    lblBack.alpha = 0.4;
    [viewHeader addSubview:lblBack];
    
    UIImageView * imgMenu = [[UIImageView alloc] init];
    imgMenu.frame = CGRectMake(10, 20+13.5, 24, 17);
    imgMenu.image = [UIImage imageNamed:@"menu_icon.png"];
    [viewHeader addSubview:imgMenu];
    
    UIButton * btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerHeight, headerHeight)];
    [btnMenu setBackgroundColor:[UIColor clearColor]];
    [btnMenu addTarget:self action:@selector(btnLeftMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnMenu];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Dashboard"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+1]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    
    //USER COUNTS
    UIImageView * imgUsers = [[UIImageView alloc]init];
    imgUsers.frame = CGRectMake(viewWidth-70, 20+(headerHeight-20-30)/2, 27, 30);
    imgUsers.backgroundColor = [UIColor clearColor];
    imgUsers.image = [UIImage imageNamed:@"connected_user.png"];
    [viewHeader addSubview:imgUsers];
    
    lblTotalUserCount = [[UILabel alloc]init];
    lblTotalUserCount.frame = CGRectMake(viewWidth-40, 20+(headerHeight-20-30)/2, 40,30);
    [lblTotalUserCount setFont:[UIFont fontWithName:CGRegular size:textSize]];
    lblTotalUserCount.textColor = [UIColor greenColor];
    lblTotalUserCount.textAlignment = NSTextAlignmentLeft;
    lblTotalUserCount.text =@"100";
    [viewHeader addSubview:lblTotalUserCount];
    
    
    UILabel * lblfirst = [self addMainLabel:0];
    [self addimageView:imgConnect toLabel:lblfirst withCount:0];
    [self addLabels:lblConnect toLabel:lblfirst withCount:0];
    UIButton * btnConnect =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addButtons:btnConnect toLabel:lblfirst withCount:0];
    [btnConnect addTarget:self action:@selector(connectDevice) forControlEvents:UIControlEventTouchUpInside];
    [self addHorizontalLabels:1];
    
    UILabel * lblSecond = [self addMainLabel:1];
    [self addimageView:[UIImageView new] toLabel:lblSecond withCount:1];
    [self addLabels:lblBattery toLabel:lblSecond withCount:1];
    
    [self addHorizontalLabels:2];
    
    UILabel * lblThird = [self addMainLabel:2];
    [self addimageView:[UIImageView new] toLabel:lblThird withCount:2];
    [self addLabels:lblSetup toLabel:lblThird withCount:2];
    btnSetup =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addButtons:btnSetup toLabel:lblThird withCount:2];
    [btnSetup addTarget:self action:@selector(btnSetupClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addHorizontalLabels:3];
    
     UILabel * lblfourth  = [self addMainLabel:3];
    [self addimageView:[UIImageView new] toLabel:lblfourth withCount:3];
    [self addLabels:lblBattery toLabel:lblfourth withCount:3];
    UIButton * btnCompass =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addButtons:btnCompass toLabel:lblfourth withCount:3];
    [btnCompass addTarget:self action:@selector(btnCompassClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * lblBottom = [[UILabel alloc] init];
    lblBottom.frame = CGRectMake(0, 160+62, viewWidth, 0.5);
    lblBottom.backgroundColor = [UIColor colorWithRed:32/255.0f green:145/255.0f blue:236.0/255.0f alpha:1];
    [self.view addSubview:lblBottom];
    
    fixedHeight = 160+64;
    
    tblView =[[UITableView alloc]initWithFrame:CGRectMake(0,DEVICE_HEIGHT, viewWidth, DEVICE_HEIGHT-fixedHeight)];
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.rowHeight=70;
    tblView.hidden=YES;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:tblView];
    
    if (IS_IPAD)
    {
        imgMenu.hidden = true;
        btnMenu.hidden = YES;
    }
    else
    {
        fixedHeight = lblfirst.frame.size.height+lblfirst.frame.origin.y+15;
        
        lblBottom.frame = CGRectMake(0, lblfirst.frame.size.height+lblfirst.frame.origin.y+15, viewWidth, 0.5);
        imgUsers.frame = CGRectMake(viewWidth-50, 20+(headerHeight-20-15)/2, 20, 22);
        lblTotalUserCount.frame = CGRectMake(viewWidth-20, 25, 20,44);
        [lblTotalUserCount setFont:[UIFont fontWithName:CGRegular size:textSize]];
        if (IS_IPHONE_X)
        {
            lblTitle.frame = CGRectMake(0,40,viewWidth,44);
            imgUsers.frame = CGRectMake(viewWidth-50, 20+24+10, 20, 22);
            lblTotalUserCount.frame = CGRectMake(viewWidth-20, 45, 40,44);
            imgMenu.frame = CGRectMake(10, 40+13.5, 24, 17);
            [lblTotalUserCount setFont:[UIFont fontWithName:CGRegular size:textSize+1]];
            lblBottom.frame = CGRectMake(0, 220, viewWidth, 0.5);
            fixedHeight = 222;
            tblView.frame =CGRectMake(0,DEVICE_HEIGHT, viewWidth, DEVICE_HEIGHT-fixedHeight-40);
            
        }
    }
    if (isAnimated == NO)
    {
        [self performSelector:@selector(showTable) withObject:self afterDelay:4];
        isAnimated = YES;
    }
    else
    {
        tblView.frame = CGRectMake(0,fixedHeight, viewWidth, DEVICE_HEIGHT-fixedHeight);
        tblView.hidden = NO;
    }
}
#pragma mark - NSNotification Methhods
-(void)RegisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"healthRateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(healthRateNotification:) name:@"healthRateNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshMainTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainTableView) name:@"refreshMainTableView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MovetoDashboard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovetoDashboard) name:@"MovetoDashboard" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MovetoComposeMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovetoComposeMsg) name:@"MovetoComposeMsg" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MovetoRadar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovetoRadar) name:@"MovetoRadar" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MovetoHoming" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovetoHoming) name:@"MovetoHoming" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MoveLocateDevice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoveLocateDevice) name:@"MoveLocateDevice" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MovetoSettings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovetoSettings) name:@"MovetoSettings" object:nil];

    
}
-(void)healthRateNotification:(NSNotification *)notify
{
      NSDictionary * tmpDict = [notify object];
    NSLog(@"Received Health Rates From Device : %@",tmpDict);
    long selectedIndex;
    if (arrMessages.count>0)
    {
        if ([[arrMessages valueForKey:@"nano"] containsObject:[tmpDict valueForKey:@"nano"]])
        {
           selectedIndex = [[arrMessages valueForKey:@"nano"] indexOfObject:[tmpDict valueForKey:@"nano"]];
            if (selectedIndex < arrMessages.count)
            {
                [[arrMessages objectAtIndex:selectedIndex]setValue:[tmpDict valueForKey:@"HR"] forKey:@"HR"];
                [[arrMessages objectAtIndex:selectedIndex]setValue:[tmpDict valueForKey:@"RR"] forKey:@"RR"];
                [[arrMessages objectAtIndex:selectedIndex]setValue:[tmpDict valueForKey:@"temp"] forKey:@"temp"];
                [[arrMessages objectAtIndex:selectedIndex]setValue:[tmpDict valueForKey:@"Distance"] forKey:@"Distance"];
                [tblView reloadData];
            }
        }
    }
}
-(void)refreshMainTableView
{
    tblView.hidden = NO;
    
    arrMessages = [[NSMutableArray alloc]init];
    NSString * strUsers = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:arrMessages];
    
    lblTotalUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[arrMessages count]];
    [tblView reloadData];
    
    if ([arrMessages count]==0)
    {
        tblView.hidden = YES;
    }
    else
    {
        tblView.hidden = NO;
        lblNoContacts.hidden = YES;
        [tblView reloadData];
    }
}
#pragma mark - Button EVent
-(void)btnLeftMenuClicked:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
-(void)createAnimation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createAnimation" object:nil];
}
-(void)buttonTapped
{
    
}
-(void)showTable
{
    btnScan.hidden=YES;
    imgScanner.hidden = YES;
    [tblView reloadData];
    tblView.hidden=NO;
    ripple.hidden=YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    tblView.frame = CGRectMake(0,fixedHeight, viewWidth, DEVICE_HEIGHT-fixedHeight);
    [UIView commitAnimations];
    
    if ([arrMessages count]==0)
    {
        [lblNoContacts removeFromSuperview];
        lblNoContacts = [[UILabel alloc] initWithFrame:CGRectZero];
        lblNoContacts.backgroundColor = [UIColor clearColor];
        lblNoContacts.frame=CGRectMake(0,fixedHeight,viewWidth,DEVICE_HEIGHT-fixedHeight);
        lblNoContacts.font = [UIFont fontWithName:CGRegular size:textSize+5];
        lblNoContacts.textAlignment = NSTextAlignmentCenter;
        lblNoContacts.numberOfLines = 0;
        lblNoContacts.textColor = [UIColor whiteColor];
        lblNoContacts.text = NSLocalizedString(@"No data found.",@"");
        [self.view addSubview:lblNoContacts];
        tblView.hidden = YES;
    }
    else
    {
        tblView.hidden = NO;
        lblNoContacts.hidden = YES;
        [tblView reloadData];
    }
}
-(void)connectDevice
{
    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        lblConnect.text = @"Connect Device";
        [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
        lblConnect.textColor = [UIColor whiteColor];
    }
    else
    {
        ScanVC *detail = [[ScanVC alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
-(void)btnSetupClick
{
    //    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        globalDeviceSetup = [[DeviceSetupVC alloc] init];
        [self.navigationController pushViewController:globalDeviceSetup animated:YES];
    }
    //    else
    //    {
    //        FCAlertView *alert = [[FCAlertView alloc] init];
    //        alert.colorScheme = [UIColor blackColor];
    //        [alert makeAlertTypeCaution];
    //        [alert showAlertInView:self
    //                     withTitle:@"Combat Diver"
    //                  withSubtitle:@"Please connect Surface Device first."
    //               withCustomImage:[UIImage imageNamed:@"logo.png"]
    //           withDoneButtonTitle:nil
    //                    andButtons:nil];
    //    }
}
-(void)btnCompassClick
{
    CompassVC * vc = [[CompassVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableview Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE)
    {
        return 80;
    }
    else
    {
        return 110;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMessages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    DashboardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[DashboardCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *stringForCell;

    stringForCell= [arrMessages objectAtIndex:indexPath.row];
    cell.lblContact.hidden = false;
    cell.lblname.text=[NSString stringWithFormat:@"%@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"name"]];
    cell.lbldiviceid.text=[NSString stringWithFormat:@"ID : %@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"nano"]];
    cell.lblContact.text =[NSString stringWithFormat:@"Ph No : %@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"phone"]];
    cell.btnConnect.hidden = NO;
    
    if ([[NSString stringWithFormat:@"%@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]] length] ==0)
    {
        cell.lastMsg.text=@"Last Message : ";
        cell.lblLine.hidden = YES;
        cell.lbldiviceid.frame = CGRectMake(115+20+140,cell.lblname.frame.origin.y, 270, 25);

        if(IS_IPHONE)
        {
            cell.lastMsg.text=@" ";
            cell.lblname.frame = CGRectMake(60,12.5,100,25);
            cell.lbldiviceid.frame = CGRectMake(160,12.5, 90, 25);
            cell.lblContact.frame = CGRectMake(60,37.5,viewWidth-50-10-65-5, 25);
            cell.lbldiviceid.hidden = true;
        }
    }
    else
    {
        cell.lastMsg.text = [NSString stringWithFormat:@"Last Message : %@ (%@)",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"msg"],[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"time"]];
        cell.lblLine.hidden = NO;
        cell.lbldiviceid.frame = CGRectMake(115+20+140,cell.lblname.frame.origin.y, 200, 25);

        if(IS_IPHONE)
        {
            cell.lbldiviceid.hidden = true;
            cell.lblname.frame = CGRectMake(60,0,100,25);
            cell.lbldiviceid.frame = CGRectMake(160,0, 90, 25);
            cell.lblContact.frame = CGRectMake(60,25,viewWidth-50-10-65-5, 25);
            cell.lblLine.hidden = true;
            cell.lblLine.frame = CGRectMake(190, 25, 0.6, 30);
            cell.lastMsg.text=[NSString stringWithFormat:@"%@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]];
            cell.lastMsg.frame = CGRectMake(60, 50, viewWidth-50-5-60, 20);
        }
    }
    if ([[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"name"] rangeOfString:@"Boat"].location == NSNotFound)
    {
        if (IS_IPHONE)
        {
            cell.imgprof.frame = CGRectMake(10,14+5,40,37);
        }
        else
        {
            cell.imgprof.frame=CGRectMake(20+20, 10+5 , 73, 70);
        }
        cell.imgprof.image=[UIImage imageNamed:@"diver_default.png"];
    }
    else
    {
        if (IS_IPHONE)
        {
            cell.imgprof.frame = CGRectMake(10,26+2.5,40,18);
        }
        else
        {
            cell.imgprof.frame=CGRectMake(20+20, 10+22 , 72, 33);
        }
        cell.imgprof.image=[UIImage imageNamed:@"boat.png"];
    }
    if (IS_IPHONE)
    {
        cell.lbldiviceid.text = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"nano"];
        cell.lblname.text = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblContact.text =[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"phone"];
    }
    cell.imgTemp.hidden = false;
    cell.imgHR.hidden = false;
    cell.imgDistance.hidden = false;

    NSString * strCheckHR = [APP_DELEGATE checkforValidString:[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"HR"]];
    if (![strCheckHR isEqualToString:@"NA"] || [strCheckHR isEqualToString:@"--"])
    {
        cell.lblHR.text = [NSString stringWithFormat:@"%@ BPM",strCheckHR];
    }
    else
    {
        cell.lblHR.text  = @"--";
    }
    NSString * strCheckTemp = [APP_DELEGATE checkforValidString:[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"temp"]];
    if (![strCheckTemp isEqualToString:@"NA"] || [strCheckTemp isEqualToString:@"--"])
    {
        cell.lblTemp.text = [NSString stringWithFormat:@"%@ °C",strCheckTemp];
    }
    else
    {
        cell.lblTemp.text  = @"--";
    }
    
    NSString * strDistance = [APP_DELEGATE checkforValidString:[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Distance"]];
    if (![strDistance isEqualToString:@"NA"] || [strDistance isEqualToString:@"--"])
    {
        if ([strDistance isEqualToString:@"--"] || [strDistance isEqualToString:@"NA"])
        {
            cell.lblDistance.text = @"--";
        }
        else
        {
            cell.lblDistance.text = [NSString stringWithFormat:@"%@ m",strDistance];
        }
    }
    else
    {
        cell.lblDistance.text = @"--";
    }
    
    cell.imgBtry.image = [UIImage imageNamed:@"red_warning.png"];
    if ([[APP_DELEGATE checkforValidString:[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Air"]]isEqualToString:@"NA"])
    {
        cell.lblAirValue.text = @"NA";
        cell.lblAir.hidden = true;
        cell.lblAirValue.frame  = CGRectMake(0, 0, 80, 80);
    }
    else
    {
        cell.lblAirValue.frame  = CGRectMake(0, 0, 80, 50);
        int tmpValue = [[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Air"] intValue];
        if (tmpValue > 20)
        {
            cell.imgBtry.image = [UIImage imageNamed:@"green_warning.png"];
        }
        cell.lblAirValue.text = [NSString stringWithFormat:@"%@%%\nAir",[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Air"]];
        int airVal = [[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Air"] intValue]* 2;
        cell.lblAir.text = [NSString stringWithFormat:@"%d bar",airVal];

        cell.lblAir.hidden = false;
    }
    cell.lbldiviceid.hidden = true;
    cell.lblContact.hidden = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
//    cell.lblDistance.text = @"0.234000 m";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    globalChatVC =[[ChatVC alloc]init];
    globalChatVC.userNano = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"id"];
    globalChatVC.userName = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"name"];
    globalChatVC.sc4NanoId = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"SC4_nano_id"];
    [self.navigationController pushViewController:globalChatVC animated:YES];    
}


#pragma mark -
#pragma mark UISplitViewControllerDelegate

// Called when a button should be added to a toolbar for a hidden view controller
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc
{
    barButtonItem = [self createBarButtonList];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}
-(void)onListButtonAction:(id)sender
{
}
-(UIBarButtonItem *)createBarButtonList
{
    UIBarButtonItem * listbarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onListButtonAction:)];
    listbarBtn.tintColor = [UIColor whiteColor];
    return listbarBtn;
}
#pragma mark - Navigation Methods
-(void)MovetoDashboard
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)MovetoComposeMsg
{
    ComposeMsgVC * cmps = [[ComposeMsgVC alloc] init];
    [self.navigationController pushViewController:cmps animated:YES];
}
-(void)MovetoRadar
{
    RadarViewController * radar = [[RadarViewController alloc] init];
    [self.navigationController pushViewController:radar animated:YES];
}
-(void)MovetoSettings
{
    SettingsVC * settings = [[SettingsVC alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}
-(void)MoveLocateDevice
{
    LocateVC * settings = [[LocateVC alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}
-(void)MovetoHoming
{
    HomingVC * homingVC = [[HomingVC alloc] init];
    [self.navigationController pushViewController:homingVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Content adding Methods
-(UILabel *)addMainLabel:(NSInteger)repeeatCount
{
    int vHeight = 140;
    int yyy = 64;
    if (IS_IPHONE)
    {
        vHeight = 95*approaxSize;
        if (IS_IPHONE_X)
        {
            yyy = 88;
        }
    }
    UILabel * lblThird = [[UILabel alloc] init];
    lblThird.frame = CGRectMake((viewWidth/4)*repeeatCount, yyy, viewWidth/4, vHeight);
    //    lblThird.backgroundColor = [UIColor redColor];
    lblThird.userInteractionEnabled = YES;
    [self.view addSubview:lblThird];
    return lblThird;
}
-(void)addHorizontalLabels:(NSInteger)repeeatCount
{
    int vHeight = 120;
    int yyy = 64;
    
    if (IS_IPHONE)
    {
        vHeight = 85*approaxSize;
        if (IS_IPHONE_X)
        {
            yyy = 88;
            vHeight = vHeight;
        }
    }
    UILabel * hor2 = [[UILabel alloc] init];
    hor2.frame = CGRectMake((viewWidth/4)*repeeatCount, yyy + 15, 0.7, vHeight);
    hor2.backgroundColor = [UIColor colorWithRed:32/255.0f green:145/255.0f blue:236.0/255.0f alpha:0.6];
    [self.view addSubview:hor2];
}
-(void)addimageView:(UIImageView *)img toLabel:(UILabel *)lbl withCount:(NSInteger)repetCount
{
    int vHeight = 100;
    if (IS_IPHONE)
    {
        vHeight = 65*approaxSize;
        
    }
    img=[[UIImageView alloc]initWithFrame:CGRectMake((lbl.frame.size.width-vHeight)/2, 10, vHeight,vHeight)];
    [lbl addSubview:img];
    if (repetCount==0)
    {
        img.image=[UIImage imageNamed:@"connected.png"];
    }
    else if (repetCount==1)
    {
        img.image=[UIImage imageNamed:@"battery.png"];
    }
    else if (repetCount==2)
    {
        img.image=[UIImage imageNamed:@"sureface_setup.png"];
    }
    else if (repetCount==3)
    {
        img.image=[UIImage imageNamed:@"compass.png"];
    }
}
-(void)addLabels:(UILabel *)lblMain toLabel:(UILabel *)lbl withCount:(NSInteger)repetCount
{
    int vHeight = 120;
    
    lblMain =[[UILabel alloc] init];
    lblMain.backgroundColor=[UIColor clearColor];
    lblMain.textColor=[UIColor whiteColor];
    lblMain.font=[UIFont fontWithName:CGRegular size:textSize];
    lblMain.frame=CGRectMake(0, lbl.frame.size.height-30, lbl.frame.size.width, 50);
    lblMain.textAlignment=NSTextAlignmentCenter;
    lblMain.numberOfLines = 0;
    lblMain.text=@"Compass";
    [lbl addSubview:lblMain];
    
    if (IS_IPHONE)
    {
        int yyy = fixedHeight-30;
        if (IS_IPHONE_X)
        {
            yyy = 80;
        }
        lblMain.frame=CGRectMake(0, lbl.frame.size.height-30, lbl.frame.size.width, 50);
        lblMain.numberOfLines = 0;
        lblMain.font=[UIFont fontWithName:CGRegular size:textSize-1];
    }
    if (repetCount==0)
    {
        lblConnect = lblMain;
        lblMain.text=@"Connect Device";
    }
    else if (repetCount==1)
    {
        lblMain.text=@"--";
        lblBattery = lblMain;
    }
    else if (repetCount==2)
    {
        lblMain.text=@"Setup Surface  ";
    }
    else if (repetCount==3)
    {
        lblMain.text=@"Compass";
    }
}
-(void)addButtons:(UIButton *)btns toLabel:(UILabel *)lbl withCount:(NSInteger)repetCount
{
    int vHeight = 150;
    if (IS_IPHONE)
    {
        vHeight = 95*approaxSize;
    }
    btns.frame = CGRectMake(0, 0, lbl.frame.size.width, vHeight);
    [btns setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lbl addSubview:btns];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)UpdateMessagelistwithNanoID:(NSString *)strNanoID withValue:(NSString *)strValue withOpcode:(NSString *)strOpcode;
{
    NSString * strDistanceValue= @"--";
    NSInteger  indexx = [[arrMessages valueForKey:@"SC4_nano_id"] indexOfObject:strNanoID];
    if (indexx == NSNotFound)
    {
        indexx = [[arrMessages valueForKey:@"lignlight_nano_id"] indexOfObject:strNanoID];
    }
    if ([strOpcode isEqualToString:@"01"])
    {
        int msgVal = [strValue intValue]+1;
        NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
        NSString * strQuery = [NSString stringWithFormat:@"select NewContact.name, DiverMessage.Message from NewContact,DiverMessage where NewContact.SC4_nano_id = '%@' and DiverMessage.indexStr = '%@'",strNanoID,[NSString stringWithFormat:@"%d",msgVal]];
        [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:tmpArr];
        
        if (indexx != NSNotFound)
        {
            if (indexx < [arrMessages count])
            {
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSLog(@"generated date is %@",[dateFormatter stringFromDate:[NSDate date]]);
                
                [[arrMessages objectAtIndex:indexx]setValue:[[tmpArr objectAtIndex:0]valueForKey:@"Message"] forKey:@"msg"];
                [[arrMessages objectAtIndex:indexx]setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"time"];
            }
        }
        if ([tmpArr count]>0)
        {
            double dateStamp = [[NSDate date] timeIntervalSince1970];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString * timeStr =[dateFormatter stringFromDate:[NSDate date]];
            
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewChat' ('from_name','from_nano','to_name','to_nano','msg_id','msg_txt','time','status','timeStamp') values ('%@','%@','%@','%@','%@','%@','%@','%@','%f')",@"Other",strNanoID,@"Me",strNanoID,strValue,[[tmpArr objectAtIndex:0] valueForKey:@"Message"],timeStr,@"Receieved",dateStamp];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        
            NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set msg ='%@', time='%@' where SC4_nano_id='%@'",[[tmpArr objectAtIndex:0] valueForKey:@"Message"],timeStr,strNanoID];
            [[DataBaseManager dataBaseManager] execute:strUpdate];
            NSString * msgStr = [NSString stringWithFormat:@"%@ sent message - '%@'",[[tmpArr objectAtIndex:0] valueForKey:@"name"],[[tmpArr objectAtIndex:0] valueForKey:@"Message"]];

            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexx inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [tblView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationLeft];
            rowsToReload = nil;
            
            [APP_DELEGATE showPopupwithMessage:msgStr withOpcode:@"01"];
            
            if (globalChatVC)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:strNanoID forKey:@"nanoId"];
                [dict setObject:strValue forKey:@"MsgID"];
                [dict setObject:timeStr forKey:@"time"];
                [dict setObject:[[tmpArr objectAtIndex:0] valueForKey:@"Message"] forKey:@"msg_txt"];
                [globalChatVC GotMessagefromDiver:dict];
            }
          
        }
    }
    else if ([strOpcode isEqualToString:@"06"] || [strOpcode isEqualToString:@"07"])
    {
        if (indexx != NSNotFound)
        {
            if (indexx < [arrMessages count])
            {
                NSString * strPopup = [NSString stringWithFormat:@"%@ has high heart rate %@ BPM. Please check",[[arrMessages objectAtIndex:indexx] valueForKey:@"name"], strValue];
                if ([strOpcode isEqualToString:@"06"])
                {
                     strPopup = [NSString stringWithFormat:@"%@ has high heart rate %@ BPM. Please check",[[arrMessages objectAtIndex:indexx] valueForKey:@"name"], strValue];
                }
                else
                {
                    strPopup = [NSString stringWithFormat:@"%@ has low heart rate %@ BPM. Please check",[[arrMessages objectAtIndex:indexx] valueForKey:@"name"], strValue];
                }
                [APP_DELEGATE showPopupwithMessage:strPopup withOpcode:@"06"];
                
                [[arrMessages objectAtIndex:indexx] setObject:strValue forKey:@"HR"];
                NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexx inSection:0];
                NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                [tblView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationLeft];
                rowsToReload = nil;

            }
        }
    }
    else if ([strOpcode isEqualToString:@"08"])
    {
        lblBattery.text = [NSString stringWithFormat:@"%@%%",strValue];
    }
    else
    {
        NSString * strKey = @"Air";
        if ([strOpcode isEqualToString:@"02"])
        {
            strKey = @"Air";
        }
        else if ([strOpcode isEqualToString:@"03"])
        {
            strKey = @"temp";
        }
        else if ([strOpcode isEqualToString:@"04"])
        {
            strKey = @"HR";
        }
        else if ([strOpcode isEqualToString:@"05"])
        {
            strKey = @"HR";
        }
        else if ([strOpcode isEqualToString:@"09"])
        {
            strKey = @"Distance";
            strDistanceValue = strValue;
            if ([strValue rangeOfString:@"16777"].location != NSNotFound)
            {
                strValue = @"--";
            }
            else
            {
                float distanceFloat = [strValue floatValue];
                strValue = [NSString stringWithFormat:@"%f",distanceFloat/1000];
            }
        }
        if (indexx != NSNotFound)
        {
            if (indexx < [arrMessages count])
            {
                [[arrMessages objectAtIndex:indexx] setObject:strValue forKey:strKey];
                NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexx inSection:0];
                NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                [tblView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationLeft];
                rowsToReload = nil;
                if ([strOpcode isEqualToString:@"02"])
                {
                    int tmpValue = [strValue intValue];
                    if (tmpValue <= 20)
                    {
                        NSString * strPopup = [NSString stringWithFormat:@"%@ Air Bottle Pressure is less than 20%%. Please check",[[arrMessages objectAtIndex:indexx] valueForKey:@"name"]];
                        [APP_DELEGATE showPopupwithMessage:strPopup withOpcode:strOpcode];
                    }
                }
                else if ([strOpcode isEqualToString:@"09"])
                {
                    float distanceFloat = [strDistanceValue floatValue];
                    float tmpValue = distanceFloat/1000;
                    if ([strValue rangeOfString:@"16777"].location != NSNotFound)
                    {
                        NSString * strPopup = [NSString stringWithFormat:@"%@ is moving out of range.",[[arrMessages objectAtIndex:indexx] valueForKey:@"name"]];
                        [APP_DELEGATE showPopupwithMessage:strPopup withOpcode:strOpcode];
                    }
                    else if (tmpValue < 200)
                    {
                        NSString * strPopup = [NSString stringWithFormat:@"%@ is under 200 meter. Distance is %f",[[arrMessages objectAtIndex:indexx] valueForKey:@"name"],tmpValue];
                        [APP_DELEGATE showPopupwithMessage:strPopup withOpcode:strOpcode];
                    }
                    else if (tmpValue > 2000)
                    {
                        NSString * strPopup = [NSString stringWithFormat:@"%@ is moving out of range.",[[arrMessages objectAtIndex:indexx] valueForKey:@"name"]];
                        [APP_DELEGATE showPopupwithMessage:strPopup withOpcode:strOpcode];
                    }
                }
            }
        }
    }
}
//[arrMessages setValue:@"NA" forKey:@"HR"];
//[arrMessages setValue:@"NA" forKey:@"RR"];
//[arrMessages setValue:@"NA" forKey:@"temp"];
//[arrMessages setValue:@"NA" forKey:@"Air"];
//biometri
@end
