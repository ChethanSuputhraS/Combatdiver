//
//  DeviceSetupVC.m
//  SC4App18
//
//  Created by stuart watts on 28/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "DeviceSetupVC.h"
#import "ScanviewCell.h"
#import "LeftMenuCell.h"
#import "MapClassVC.h"

@interface DeviceSetupVC ()<UITableViewDelegate,UITableViewDataSource,FCAlertViewDelegate>
{
    NSArray * listArr;
    NSMutableArray * arrContent;
}
@end

@implementation DeviceSetupVC
@synthesize isfromScreen;

- (void)viewDidLoad
{
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

    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, headerhHeight)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewWidth,headerhHeight)];
    lblBack.backgroundColor = [UIColor blackColor];
    lblBack.alpha = 0.4;
    [viewHeader addSubview:lblBack];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Surface  Setup"];
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
    
    arrContent = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <7; i++)
    {
        NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] init];
        if (i==0)
        {
            [tempDict setValue:@"addres_book.png" forKey:@"image"];
            [tempDict setValue:@"Sync Address Book" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"29" forKey:@"height"];
        }
        else if (i==1)
        {
            [tempDict setValue:@"messages.png" forKey:@"image"];
            [tempDict setValue:@"Sync Surface Mode Messages" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"22" forKey:@"height"];
        }
        else if (i==2)
        {
            [tempDict setValue:@"sync_diver.png" forKey:@"image"];
            [tempDict setValue:@"Sync Diver Mode Messages" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"22" forKey:@"height"];
        }
        else if (i==3)
        {
            [tempDict setValue:@"set_time.png" forKey:@"image"];
            [tempDict setValue:@"Set time" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"26" forKey:@"height"];
        }
        else if (i==4)
        {
            [tempDict setValue:@"sync_modem.png" forKey:@"image"];
            [tempDict setValue:@"Assign Name to connected SC4 device" forKey:@"name"];
            [tempDict setValue:@"27" forKey:@"width"];
            [tempDict setValue:@"27" forKey:@"height"];
        }
        else if (i==5)
        {
            [tempDict setValue:@"request_modem.png" forKey:@"image"];
            [tempDict setValue:@"Get GPS location" forKey:@"name"];
            [tempDict setValue:@"27" forKey:@"width"];
            [tempDict setValue:@"27" forKey:@"height"];
        }
        else if (i==6)
        {
            [tempDict setValue:@"request_modem.png" forKey:@"image"];
            [tempDict setValue:@"Get GPS location" forKey:@"name"];
            [tempDict setValue:@"27" forKey:@"width"];
            [tempDict setValue:@"27" forKey:@"height"];
        }
        [arrContent addObject:tempDict];
    }
    listArr = [[NSArray alloc] initWithObjects:@"Sync Address Book",@"Sync Surface Mode Messages",@"Sync Diver Mode Messages",@"Set time",@"Assign Name to connected SC4 device",@"Get GPS location", nil];
    
    [self setupMainContentView:headerhHeight];

    [self getDatafromDatabase];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetGPSLocation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetGPSLocation:) name:@"GetGPSLocation" object:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setupMainContentView:(int)headerHeights
{
    int bottomHeight = 60;
    if (IS_IPHONE_X)
    {
        bottomHeight = 60 + 45;
    }
    
    UIImageView * backView = [[UIImageView alloc] init];
    backView.frame = CGRectMake(30, headerHeights+40, viewWidth-60, DEVICE_HEIGHT);
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, backView.frame.size.width, DEVICE_HEIGHT)];
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    tblView.layer.masksToBounds = YES;
    [backView addSubview:tblView];
    
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds];
//    backView.layer.masksToBounds = NO;
//    backView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    backView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    backView.layer.shadowOpacity = 0.5f;
//    backView.layer.shadowPath = shadowPath.CGPath;
    if (IS_IPHONE)
    {
        backView.frame = CGRectMake(10, headerHeights+10, viewWidth-20, DEVICE_HEIGHT-headerHeights+10);
        tblView.frame = CGRectMake(0,0, backView.frame.size.width, DEVICE_HEIGHT-headerHeights+10);
    }
}

-(void)getDatafromDatabase
{
    cannedMsgArr = [[NSMutableArray alloc] init];
    NSString * strQuery = [NSString stringWithFormat:@"select * from NewCanned_message"];
    [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:cannedMsgArr];
    
    diversArr = [[NSMutableArray alloc] init];
    NSString * strQuery1 = [NSString stringWithFormat:@"select * from DiverMessage"];
    [[DataBaseManager dataBaseManager] execute:strQuery1 resultsArray:diversArr];
    
    contactArr = [[NSMutableArray alloc] init];
    NSString * strcontQr = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strcontQr resultsArray:contactArr];
//    NSLog(@"data=%@",contactArr);
    if (![[contactArr valueForKey:@"SC4_Ble_address"] containsObject:strGlobalSC4BLEAddress])
    {
        if(globalPeripheral.state == CBPeripheralStateConnected)
        {
            [self setupConctactTable];
        }
    }
}

#pragma mark - Button Click Methods
-(void)btnBackClick
{
    if ([isfromScreen isEqualToString:@"Home"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveToScreen" object:nil];
    }
    else
    {
//        [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)btnCloseClick
{
    [self hideMorePopUpView:YES];
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
        return  [listArr count];
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
        cell.lblContact.hidden = YES;
        if (![[APP_DELEGATE checkforValidString:[[contactArr objectAtIndex:indexPath.row] valueForKey:@"SC4_Ble_address"]] isEqualToString:@"NA"])
        {
            cell.lblContact.hidden = NO;
            cell.lblContact.frame = CGRectMake(tableView.frame.size.width-185, 0, 180, height);
            [cell.lblContact setTextAlignment:NSTextAlignmentRight];
            cell.lblContact.text = [[contactArr objectAtIndex:indexPath.row] valueForKey:@"SC4_Ble_address"];
            cell.lblContact.textColor = UIColor.lightGrayColor;
        }
//
        cell.lblLine.hidden = YES;
        cell.imgArrow.hidden = YES;

        return cell;
    }
    else
    {

        NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[LeftMenuCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.lblLine.hidden = YES;
        cell.imgArrow.hidden = YES;
        
        cell.lblName.text = [[arrContent objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.imgIcon.image = [UIImage imageNamed:[[arrContent objectAtIndex:indexPath.row] valueForKey:@"image"]];
        
        int WW = [[[arrContent objectAtIndex:indexPath.row] valueForKey:@"width"] intValue];
        int HH = [[[arrContent objectAtIndex:indexPath.row] valueForKey:@"height"] intValue];
        
        cell.imgIcon.frame = CGRectMake(10,(60-HH)/2, WW, HH);
        cell.lblName.frame = CGRectMake(WW + 30, 0, viewWidth-40, height);
        cell.lblBack.frame = CGRectMake(0, 0, viewWidth, height);
        cell.lblBack.hidden = NO;


        return cell;
    }
}

#pragma mark - UITableViewDelegate

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
        if (IS_IPHONE)
        {
            return 60;
        }
    }
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (IS_IPAD)
    {
        return 50.0;
    }
    else
    {
        return 40.0;
    }
    return 40.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    if (IS_IPAD)
    {
        frame = CGRectMake(0, 0, tableView.frame.size.width, 50);
    }
    else
    {
        frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    }
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @" Surface setup options";
    label.frame = frame;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:CGRegular size:textSize+2];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    if (tableView == tblContact)
    {
        label.text = @"Select contact to sync modem Id";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.frame = CGRectMake(20, 0, tableView.frame.size.width, frame.size.height);
        view.backgroundColor = [UIColor blackColor];
        
        UIFontDescriptor *fontDescriptor1 = [UIFontDescriptor fontDescriptorWithName:CGBold size:textSize];
        UIFontDescriptor *symbolicFontDescriptor1 = [fontDescriptor1 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        
        NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:@"* Select contact to sync modem Id"];
        UIFont *fontWithDescriptor = [UIFont fontWithDescriptor:fontDescriptor1 size:textSize+3];
        UIFont *fontWithDescriptor1 = [UIFont fontWithDescriptor:symbolicFontDescriptor1 size:textSize];
        UIFont *fontWithDescriptor2 = [UIFont fontWithDescriptor:symbolicFontDescriptor1 size:textSize];
        
        [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor1, NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, hintText.length)];
        [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor, NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
        [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor2, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(8, 9)];
        
        [label setAttributedText:hintText];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:CGRegular size:textSize];

        view.backgroundColor = [UIColor blackColor];
    }
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"table select method clicked");
    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        if (tableView == tblView)
        {
            if (indexPath.row == 0)
            {
                NSMutableArray * contactArr = [[NSMutableArray alloc]init];
                NSString * strUsers = [NSString stringWithFormat:@"select * from NewContact"];
                [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:contactArr];
                NSLog(@"New Contact Arr=%@",contactArr);

                if ([[contactArr valueForKey:@"irridium_id"]containsObject:@""] || [[contactArr valueForKey:@"irridium_id"]containsObject:[NSNull null]])
                {
                    NSLog(@"found irridium id null,hence not letting user to sync");
                    
                    FCAlertView *alert = [[FCAlertView alloc] init];
                    alert.colorScheme = [UIColor blackColor];
                    [alert makeAlertTypeCaution];
                    [alert showAlertInView:self
                                 withTitle:@"Combat Diver"
                              withSubtitle:@"Please update irridum ID in your Addrebook to Sync Addressbook."
                           withCustomImage:[UIImage imageNamed:@"logo.png"]
                       withDoneButtonTitle:nil
                                andButtons:nil];
                }
                else
                {
                    isSynced = false;
                    [APP_DELEGATE startHudProcess:@"Syncing..."];
                    NSInteger firstInt = [@"06" integerValue];
                    NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
                    
                    NSInteger secondInt = [@"01" integerValue];
                    NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
                    
                    NSInteger thirdInt = [@"01" integerValue];
                    NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
                    
                    NSMutableData *completeData = [firstData mutableCopy];
                    [completeData appendData:secondData];
                    [completeData appendData:thirdData];
                    
                    [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
                    kpCount= 0;
                    [msgTimer invalidate];
                    msgTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendAddressbook) userInfo:nil repeats:YES];
                }
            }
            else if (indexPath.row == 1)
            {
                isDiver = NO;
                isSynced = false;

                [APP_DELEGATE startHudProcess:@"Syncing..."];
                NSInteger firstInt = [@"06" integerValue];
                NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
                
                NSInteger secondInt = [@"01" integerValue];
                NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
                
                NSInteger thirdInt = [@"02" integerValue];
                NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
                
                NSMutableData *completeData = [firstData mutableCopy];
                [completeData appendData:secondData];
                [completeData appendData:thirdData];
                [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
                
                kpCount= 0;
                
                [msgTimer invalidate];
                msgTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendCandMsg) userInfo:nil repeats:YES];
            }
            else if (indexPath.row == 2)
            {
                isSynced = false;
                [APP_DELEGATE startHudProcess:@"Syncing..."];
                NSInteger firstInt = [@"06" integerValue];
                NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
                
                NSInteger secondInt = [@"01" integerValue];
                NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
                
                NSInteger thirdInt = [@"03" integerValue];  ////srivatsa november changed @"01" to @"03" coz shubra told
                NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
                
                NSMutableData *completeData = [firstData mutableCopy];
                [completeData appendData:secondData];
                [completeData appendData:thirdData];
                [[BLEService sharedInstance] writeValuetoDeviceDiverMsg:completeData with:globalPeripheral];
                
                isDiver = YES;
                kpCount= 0;
                
                [msgTimer invalidate];
                msgTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(syncDiverMessages) userInfo:nil repeats:YES];
            }
            else if (indexPath.row == 3)
            {
                [[BLEService sharedInstance] sendTimeToDevice:globalPeripheral];

                FCAlertView *alert = [[FCAlertView alloc] init];
                alert.colorScheme = [UIColor blackColor];
                [alert makeAlertTypeSuccess];
                [alert showAlertInView:self
                             withTitle:@"Combat Diver"
                          withSubtitle:@"Time set successfully."
                       withCustomImage:[UIImage imageNamed:@"logo.png"]
                   withDoneButtonTitle:nil
                            andButtons:nil];
            }
            else if (indexPath.row == 4)
            {
                selectedIndex = indexPath.row;
                [self setupConctactTable];
            }
            else if (indexPath.row == 5)//For GPS location
            {
                NSInteger firstInt = [@"10" integerValue];
                NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];

                NSInteger secondInt = [@"01" integerValue];
                NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];

                NSInteger thirdInt = [@"01" integerValue];
                NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];

                NSMutableData *completeData = [firstData mutableCopy];
                [completeData appendData:secondData];
                [completeData appendData:thirdData];

                [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
              
            }
            else if (indexPath.row == 6)
            {
                NSInteger firstInt = [@"10" integerValue];
                NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
                
                NSInteger secondInt = [@"01" integerValue];
                NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
                
                NSInteger thirdInt = [@"01" integerValue];
                NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
                
                NSMutableData *completeData = [firstData mutableCopy];
                [completeData appendData:secondData];
                [completeData appendData:thirdData];
                
                [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
            }
        }
        else
        {
//            if ([[APP_DELEGATE checkforValidString:[[contactArr objectAtIndex:indexPath.row] valueForKey:@"SC4_Ble_address"]] isEqualToString:@"NA"])
            {
                NSString * strId = [[contactArr objectAtIndex:indexPath.row] valueForKey:@"id"];
                NSString * strClear = [NSString stringWithFormat:@"Update NewContact set SC4_Ble_address='' where SC4_Ble_address ='%@'",strGlobalSC4BLEAddress];
                [[DataBaseManager dataBaseManager] execute:strClear];

                NSString * strUpdate = [NSString stringWithFormat:@"Update NewContact set SC4_Ble_address='%@' where id ='%@'",strGlobalSC4BLEAddress, strId];
                [[DataBaseManager dataBaseManager] execute:strUpdate];
                for (int i=0; i<[contactArr count]; i++)
                {
                    if ([[[contactArr objectAtIndex:i] valueForKey:@"SC4_Ble_address"] isEqualToString:strGlobalSC4BLEAddress])
                    {
                        [[contactArr objectAtIndex:i] setObject:@"" forKey:@"SC4_Ble_address"];
                    }
                }
                [[contactArr objectAtIndex:indexPath.row] setObject:strGlobalSC4BLEAddress forKey:@"SC4_Ble_address"];
                strGlobalPeripheralName = [[contactArr objectAtIndex:indexPath.row] valueForKey:@"name"];
                FCAlertView *alert = [[FCAlertView alloc] init];
                alert.colorScheme = [UIColor blackColor];
                [alert makeAlertTypeSuccess];
                [alert showAlertInView:self
                             withTitle:@"Combat Diver"
                          withSubtitle:@"Name assigned successfully."
                       withCustomImage:[UIImage imageNamed:@"logo.png"]
                   withDoneButtonTitle:nil
                            andButtons:nil];
                [self hideMorePopUpView:YES];

            }
        }
    }
    else
    {
//        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Device is disconnected. Please connect again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        alert.tag = 222;
//        [alert show];
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
        alert.delegate = self;
        alert.tag = 222;
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Device is disconnected. Please connect again."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == tblView)
    {
        
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
    }
}


#pragma mark - BLE Command Methods

-(void)sendCandMsg
{
    if (kpCount >= [cannedMsgArr count])
    {
        NSLog(@"its done=%ld",(long)kpCount);
//        [APP_DELEGATE endHudProcess];
        
        [msgTimer invalidate];
        
        NSInteger firstInt = [@"09" integerValue];
        NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
        
        NSInteger secondInt = [@"01" integerValue];
        NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"02" integerValue];////srivatsa november changed @"01" to @"02" coz shubra told
        NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSMutableData *completeData = [firstData mutableCopy];
        [completeData appendData:secondData];
        [completeData appendData:thirdData];
        [[BLEService sharedInstance] writeValuetoDeviceDiverMsg:completeData with:globalPeripheral];
        
        [ackCheckTimer invalidate];
        ackCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(CheckAddressBookSyncedAck) userInfo:nil repeats:NO];

        
    }
    else
    {
        NSString * msgStr = [NSString stringWithFormat:@"%@",[[cannedMsgArr objectAtIndex:kpCount] valueForKey:@"Message"]];
        NSString * indexStr = [NSString stringWithFormat:@"%@",[[cannedMsgArr objectAtIndex:kpCount] valueForKey:@"indexStr"]];
        [[BLEService sharedInstance] sendingTestToDeviceCanned:msgStr with:globalPeripheral withIndex:indexStr];
        kpCount = kpCount +1;
    }
}
-(void)syncDiverMessages
{
    
    if (kpCount >= [diversArr count])
    {
        NSLog(@"its done=%ld",(long)kpCount);
//        [APP_DELEGATE endHudProcess];
        [msgTimer invalidate];
        
        NSInteger firstInt = [@"09" integerValue];
        NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
        
        NSInteger secondInt = [@"01" integerValue];
        NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"03" integerValue];////srivatsa november changed @"01" to @"03" coz shubra told
        NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSMutableData *completeData = [firstData mutableCopy];
        [completeData appendData:secondData];
        [completeData appendData:thirdData];
        [[BLEService sharedInstance] writeValuetoDeviceDiverMsg:completeData with:globalPeripheral];
        
        
        [ackCheckTimer invalidate];
        ackCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(CheckAddressBookSyncedAck) userInfo:nil repeats:NO];

        
    }
    else
    {
        NSString * msgStr = [NSString stringWithFormat:@"%@",[[diversArr objectAtIndex:kpCount] valueForKey:@"Message"]];
        NSString * indexStr = [NSString stringWithFormat:@"%@",[[diversArr objectAtIndex:kpCount] valueForKey:@"indexStr"]];
        [[BLEService sharedInstance] syncDiverMessage:msgStr with:globalPeripheral withIndex:indexStr];
        kpCount = kpCount +1;
    }
}

-(void)sendAddressbook
{
    if (kpCount >= [contactArr count])
    {
        NSLog(@"its done=%ld",(long)kpCount);
//        [APP_DELEGATE endHudProcess];
        [msgTimer invalidate];
        
        NSInteger firstInt = [@"09" integerValue];
        NSData *firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
        
        NSInteger secondInt = [@"01" integerValue];
        NSData *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"01" integerValue];
        NSData *thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSMutableData *completeData = [firstData mutableCopy];
        [completeData appendData:secondData];
        [completeData appendData:thirdData];
        [[BLEService sharedInstance] writeValuetoDeviceDiverMsg:completeData with:globalPeripheral];
        
        [ackCheckTimer invalidate];
        ackCheckTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(CheckAddressBookSyncedAck) userInfo:nil repeats:NO];

        /*FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeSuccess];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Contacts synced successfully."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];*/
    }
    else
    {
        NSInteger serialNo = kpCount +1;;
        NSData  * serialNoData = [[NSData alloc] initWithBytes:&serialNo length:1];
        
        NSInteger packetInt = [@"01" integerValue];
        NSData * packetData = [[NSData alloc] initWithBytes:&packetInt length:1];

        NSString * strName = [NSString stringWithFormat:@"%@",[[contactArr objectAtIndex:kpCount] valueForKey:@"name"]];
        NSData * nameData = [self dataFromHexString:[self hexFromStr:strName]];
        
        NSMutableData *completeData = [serialNoData mutableCopy];
        [completeData appendData:packetData];
        [completeData appendData:nameData];
        
        [[BLEService sharedInstance] SendDatatodevice:completeData withPeripheral:globalPeripheral];
        [self performSelector:@selector(SyncPhonePart) withObject:nil afterDelay:0.2];
    }
}
-(void)SyncPhonePart
{
    if (kpCount < [contactArr count])
    {
        NSString * phoneStr = [NSString stringWithFormat:@"%@",[[contactArr objectAtIndex:kpCount] valueForKey:@"phone"]];
        
//        NSInteger firstInt = [@"03" integerValue];
//        NSData * firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
        
        NSInteger secondInt = kpCount+1;
        NSData  *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"02" integerValue];
        NSData * thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSString * str = [self hexFromStr:phoneStr];
        NSData * msgData = [self dataFromHexString:str];
        
        //    NSMutableData *completeData = [firstData mutableCopy];
        NSMutableData *completeData = [secondData mutableCopy];
        //    [completeData appendData:secondData];
        [completeData appendData:thirdData];
        [completeData appendData:msgData];
        [[BLEService sharedInstance] SendDatatodevice:completeData withPeripheral:globalPeripheral];
        
        [self SyncIrridiumPart];  //srivatsa november added this method coz shubra told nano id should also be sent
        // if i use sync irridiumpart method with delay 0.2 seconds,he didnt get data in proper indexes. so i just called method directly
        
        
    }
}
-(void)SyncIrridiumPart
{
    if (kpCount < [contactArr count])
    {
        NSString * strIrridium = [NSString stringWithFormat:@"%@",[[contactArr objectAtIndex:kpCount] valueForKey:@"irridium_id"]];
        
        NSInteger secondInt = kpCount+1;
        NSData  *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"03" integerValue];
        NSData * thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSString * str = [self hexFromStr:strIrridium];
        NSData * msgData = [self dataFromHexString:str];
        
        //    NSMutableData *completeData = [firstData mutableCopy];
        NSMutableData *completeData = [secondData mutableCopy];
        //    [completeData appendData:secondData];
        [completeData appendData:thirdData];
        [completeData appendData:msgData];
        [[BLEService sharedInstance] SendDatatodevice:completeData withPeripheral:globalPeripheral];
        
    }
    [self SyncNanoModemIds];

}
-(void)SyncNanoModemIds
{
    if (kpCount < [contactArr count])
    {
        NSInteger secondInt = kpCount+1;
        NSData  *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"04" integerValue];
        NSData * thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSInteger sc4Int = [[[contactArr objectAtIndex:kpCount] valueForKey:@"SC4_nano_id"] integerValue];
        NSData * sc4NanoData = [[NSData alloc] initWithBytes:&sc4Int length:4];

        NSInteger lineLightInt = [[[contactArr objectAtIndex:kpCount] valueForKey:@"lignlight_nano_id"] integerValue];
        NSData * lineLightNanoData = [[NSData alloc] initWithBytes:&lineLightInt length:4];
        
        NSMutableData *completeData = [secondData mutableCopy];
        [completeData appendData:thirdData];
        [completeData appendData:sc4NanoData];
        [completeData appendData:lineLightNanoData];
        if ([[[contactArr objectAtIndex:kpCount] valueForKey:@"isBoat"] isEqualToString:@"1"])
        {
            NSLog(@"Yes Boat=%d",kpCount);
            NSInteger isBoatInt = [@"01" integerValue];
            NSData * isBoatData = [[NSData alloc] initWithBytes:&isBoatInt length:1];
            [completeData appendData:isBoatData];
        }
        else
        {
            NSInteger isBoatInt = [@"00" integerValue];
            NSData * isBoatData = [[NSData alloc] initWithBytes:&isBoatInt length:1];
            [completeData appendData:isBoatData];
        }
        [[BLEService sharedInstance] SendDatatodevice:completeData withPeripheral:globalPeripheral];
    }
    [self SyncGSMIMEI];
}
-(void)SyncGSMIMEI
{
    if (kpCount < [contactArr count])
    {
        NSString * strIrridium = [NSString stringWithFormat:@"%@",[[contactArr objectAtIndex:kpCount] valueForKey:@"gsm_irridium_id"]];
        
        NSInteger secondInt = kpCount+1;
        NSData  *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"05" integerValue];
        NSData * thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSString * str = [self hexFromStr:strIrridium];
        NSData * msgData = [self dataFromHexString:str];
        
        NSMutableData *completeData = [secondData mutableCopy];
        [completeData appendData:thirdData];
        [completeData appendData:msgData];
        [[BLEService sharedInstance] SendDatatodevice:completeData withPeripheral:globalPeripheral];
        
    }
    kpCount = kpCount +1;
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
#pragma mark - Helper Methods

- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    NSLog(@"Button Clicked: %ld Title:%@", (long)index, title);
}

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView
{
    if (alertView.tag == 222)
    {
        [self.navigationController popViewControllerAnimated:YES];
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
-(void)GetGPSLocation:(NSNotification *)notify
{
    NSMutableDictionary *dict = [notify object];
    NSLog(@"Here in Setupsurfae got the lat=%@ and long",dict);

    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeSuccess];
    [alert addButton:@"See on Map" withActionBlock:^{
        NSLog(@"Custom Font Button Pressed");
        MapClassVC * mapClass = [[MapClassVC alloc] init];
        mapClass.detailsDict = dict;
        [self.navigationController pushViewController:mapClass animated:YES];
    }];
    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:@"Got GPS location successfully."
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
-(void)SyncedAcknowlegmentfor:(NSString *)strType
{
    isSynced = YES;
    [APP_DELEGATE endHudProcess];
    [ackCheckTimer invalidate];
    ackCheckTimer = nil;
    NSString * strMsg;
    if ([strType isEqualToString:@"01"])
    {
        strMsg = @"Address Book has been synced successfully";
    }
    else if ([strType isEqualToString:@"02"])
    {
        strMsg = @"Surface Canned messages has been synced successfully";
    }
    else if ([strType isEqualToString:@"03"])
    {
        strMsg = @"Diver Canned messages has been synced successfully";
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
-(void)CheckAddressBookSyncedAck
{
    [APP_DELEGATE endHudProcess];

    if (isSynced == NO)
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Somethig went wrong. Please try again."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
        
    }
}
@end
