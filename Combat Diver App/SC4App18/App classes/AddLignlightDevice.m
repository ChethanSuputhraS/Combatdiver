//
//  AddLignlightDevice.m
//  SC4App18
//
//  Created by srivatsa s pobbathi on 06/11/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "AddLignlightDevice.h"
#import "ScanviewCell.h"
#import "LeftMenuCell.h"
@interface AddLignlightDevice ()

@end

@implementation AddLignlightDevice

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
//    arrayLignlightDevices = [[NSMutableArray alloc]init];
    arrayLignlightDevices = [[NSMutableArray alloc]initWithObjects:@"check 1",@"check 2",@"check 3",@"check 4", nil];

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
    [lblTitle setText:@"Scan Lignlight Device"];
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
    [self setupMainContentView:headerhHeight+34];

    contactArr = [[NSMutableArray alloc] init];
    NSString * strcontQr = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strcontQr resultsArray:contactArr];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self InitialBLE];
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
    
    tblContent=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth-60, DEVICE_HEIGHT-headerHeights-60)];
    tblContent.rowHeight=80;
    tblContent.delegate=self;
    tblContent.dataSource=self;
    tblContent.backgroundColor=[UIColor clearColor];
    [tblContent setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblContent setSeparatorColor:[UIColor clearColor]];
    [backView addSubview:tblContent];
//
    if (IS_IPHONE)
    {
        backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights);
        tblContent.frame=CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-60);
    }
}
#pragma mark - TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==tblContact)
    {
        if (IS_IPHONE)
        {
            return 50;
        }
        return 60;
    }
    else
    {
        return 75;
    }
    return 0;
}

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
        return 4;
        //    return [[[BLEManager sharedManager] foundDevices] count];
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
        
        NSString * strName = [NSString stringWithFormat:@"%@.  %@",[[contactArr objectAtIndex:indexPath.row] valueForKey:@"nano"],[[contactArr objectAtIndex:indexPath.row] valueForKey:@"name"]];
        cell.lblName.text= strName;
        
        cell.lblLine.hidden = YES;
        cell.imgArrow.hidden = YES;
        
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
        /*
        NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
        arrayDevices =[[BLEManager sharedManager] foundDevices];
        
        cell.lblname.text= @"Lignlight Device";
        
        if ([arrayDevices count]>0)
        {
            //        address
            //peripheral
            CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
            cell.lblname.text=p.name;
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
         */
        return cell;
    }
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setupConctactTable];

    /*
    [timerOut invalidate];
    timerOut = nil;
    timerOut = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkConnected) userInfo:nil repeats:NO];
    
    //    [self performSelector:@selector(checkConnected) withObject:nil afterDelay:5];
    NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
    arrayDevices =[[BLEManager sharedManager] foundDevices];
    
    CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
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
     */
}
#pragma mark - All Button Click Events
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnRefreshClick
{
    [[[BLEManager sharedManager] foundDevices] removeAllObjects];
    [tblContent reloadData];
    [[BLEManager sharedManager] rescan];
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
    [[BLEManager sharedManager] disconnectDevice:peripheral];
}
#pragma mark - Ble device Connect method

-(void)onConnectWithDevice:(CBPeripheral*)peripheral
{
    [[BLEManager sharedManager] connectDevice:peripheral];
}
-(void)didDiscoverPeripheralNotification:(NSNotification*)notification//Update peripheral
{
    [tblContent reloadData];
}
-(void)DeviceDidConnectNotification:(NSNotification*)notification//Connect periperal
{
    [APP_DELEGATE endHudProcess];
    isConnected = YES;
    [[BLEService sharedInstance] sendNotifications:globalPeripheral withType:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)DeviceDidDisConnectNotification:(NSNotification*)notification//Disconnect periperal
{
    [tblContent reloadData];
}
-(void)checkConnected
{
    [APP_DELEGATE endHudProcess];
    if (isConnected)
    {
    }
    else
    {
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
    [backContactView addSubview:btnDone];
    
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
-(void)btnCloseClick
{
    [self hideMorePopUpView:true];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
