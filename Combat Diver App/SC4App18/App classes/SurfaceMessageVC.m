//
//  SurfaceMessageVC.m
//  SC4App18
//
//  Created by stuart watts on 07/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "SurfaceMessageVC.h"
#import "LeftMenuCell.h"

@interface SurfaceMessageVC ()<FCAlertViewDelegate>
{
    NSTimer *  msgTimer;
    NSInteger selectedIndex,kpCount;
    BOOL isEdited;
    NSString * strUpdatedMsg;
}
@end

@implementation SurfaceMessageVC

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
    [lblTitle setText:@"Surface Message"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIImageView * imgAdd = [[UIImageView alloc] init];
    imgAdd.frame = CGRectMake(viewWidth-50, 20+9, 26, 25);
    imgAdd.image = [UIImage imageNamed:@"add.png"];
    [viewHeader addSubview:imgAdd];
    
    UIButton * btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(viewWidth-110, 0, 110, 64);
    [btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnAdd];
    
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
    
    UILabel * lblHint = [[UILabel alloc] initWithFrame:CGRectZero];
    lblHint.backgroundColor = [UIColor clearColor];
    lblHint.frame=CGRectMake(0, 64, 707, 50);
    lblHint.font = [UIFont systemFontOfSize:18];
    lblHint.textAlignment = NSTextAlignmentCenter;
    lblHint.textColor = [UIColor whiteColor];
    [lblHint setFont:[UIFont fontWithName:CGRegular size:textSize+1]];
    lblHint.text = NSLocalizedString(@"Sync Surface messages to device by tapping on SYNC button.",@"");
    [self.view addSubview:lblHint];
    
    UILabel * lblSubHint = [[UILabel alloc] initWithFrame:CGRectZero];
    lblSubHint.backgroundColor = [UIColor clearColor];
    lblSubHint.frame=CGRectMake(0, 64+32, 707, 25);
    lblSubHint.font = [UIFont systemFontOfSize:14];
    lblSubHint.textAlignment = NSTextAlignmentCenter;
    [lblSubHint setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
    lblSubHint.textColor = [UIColor whiteColor]; // change this color
    lblSubHint.text = NSLocalizedString(@"(Tap on any Message to Edit)",@"");
    [self.view addSubview:lblSubHint];
    
    if (IS_IPHONE)
    {
        imgAdd.frame = CGRectMake(viewWidth-40, 20+9, 26, 25);
        lblHint.frame=CGRectMake(0, headerhHeight, viewWidth, 50);
        lblSubHint.frame=CGRectMake(0, headerhHeight+32, viewWidth, 25);
        [lblHint setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [lblSubHint setFont:[UIFont fontWithName:CGRegular size:textSize-3]];
        lblHint.text = NSLocalizedString(@"Sync Surface messages to device",@"");


        if (IS_IPHONE_X)
        {
            imgAdd.frame = CGRectMake(viewWidth-40, 24+20+9, 26, 25);
            viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
            lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
            btnAdd.frame = CGRectMake(viewWidth-70, 0, 70, 88);
            backImg.frame = CGRectMake(10, 12+44, 12, 20);
            btnBack.frame = CGRectMake(0, 0, 70, 88);
        }
    }
    [self setupMainContentView:headerhHeight+44+16];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)setupMainContentView:(int)headerHeights
{
    arrMessages = [[NSMutableArray alloc] init];
    
    NSString * strQuery = [NSString stringWithFormat:@"select * from NewCanned_message"];
    [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrMessages];
    if ([arrMessages count]==0)
    {
        NSArray * fixArrArray = [[NSArray alloc] initWithObjects:@"Ok",@"Stop",@"Go",@"Acknowledged",@"Return to RV",@"Canned 6",@"Canned 7",@"Canned 8",@"Canned 9",@"Canned 10",@"Canned 11",@"Canned 12",@"Canned 13",@"Canned 14",@"Canned 15",@"Canned 16",@"Canned 17",@"Canned 18",@"Canned 19",@"Canned 20", nil];
        for (int i = 0; i<[fixArrArray count]; i++)
        {
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewCanned_message' ('Message','is_emergency','indexStr') values ('%@','No','%d')",[fixArrArray objectAtIndex:i],i+1];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        }
        NSString * strQuery = [NSString stringWithFormat:@"select * from NewCanned_message"];
        [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrMessages];
    }

    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, headerHeights, viewWidth-60, DEVICE_HEIGHT-headerHeights);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth-60, backView.frame.size.height)];
    tblView.rowHeight=80;
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    [backView addSubview:tblView];

//    [btnSync removeFromSuperview];
//    btnSync =[UIButton buttonWithType:UIButtonTypeCustom];
//    btnSync.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    [btnSync addTarget:self action:@selector(syncBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    btnSync.frame=CGRectMake(0, DEVICE_HEIGHT-60, 707, 60);
//    [btnSync setTitle:@"Update Messages" forState:UIControlStateNormal];
//    [btnSync setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    btnSync.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize+2];
//    [btnSync setTitleColor:[UIColor colorWithRed:39.0/255.0f green:174.0/255.0f blue:96.0/255.0f alpha:1.0] forState:UIControlStateNormal];
//    [self.view addSubview:btnSync];
    
    if (IS_IPHONE)
    {
        backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights);
        tblView.frame = CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-50);
        btnSync.frame=CGRectMake(0, DEVICE_HEIGHT-50, viewWidth, 50);
        
        if (IS_IPHONE_X)
        {
            backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights-40);
            btnSync.frame=CGRectMake(0, DEVICE_HEIGHT-50-40, viewWidth, 50);
            tblView.frame = CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-50-40);
        }
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tblView)
    {
        return 1;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [arrMessages count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int vHeight = 55;
    if (IS_IPHONE)
    {
        vHeight = 45;
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[LeftMenuCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblName.textColor=[UIColor whiteColor];
    cell.lblName.font = [UIFont fontWithName:CGRegular size:textSize+1];
    cell.lblName.frame = CGRectMake(70, 0, viewWidth-40, vHeight);
    
    cell.lblName.text= [NSString stringWithFormat:@"%@. %@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"indexStr"], [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"Message"]];;

    cell.lblBack.frame = CGRectMake(0, 0, viewWidth, vHeight);

    cell.imgIcon.frame = CGRectMake(15, (vHeight-24)/2, 33, 24);
    cell.imgIcon.image = [UIImage imageNamed:@"diver_Msg.png"];

    cell.lblBack.hidden = NO;
    cell.imgIcon.hidden = NO;
    cell.lblLine.hidden = YES;
    cell.imgArrow.hidden = YES;

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isEdited = YES;
    selectedIndex = indexPath.row;
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    alert.tag = 123;
    alert.colorScheme = [UIColor colorWithRed:44.0/255.0f green:62.0/255.0f blue:80.0/255.0f alpha:1.0];
    UITextField *customField = [[UITextField alloc] init];
    customField.tag = 123;
    customField.placeholder = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"Message"];
    customField.text = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"Message"];
    [alert addTextFieldWithCustomTextField:customField andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
        NSLog(@"Custom TextField Returns: %@", text); // Do what you'd like with the text returned from the field
        
        strUpdatedMsg = text;
    }];
    [alert addButton:@"Cancel" withActionBlock:^{
        NSLog(@"Custom Font Button Pressed");
        // Put your action here
    }];

    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:@"Update Surface Message"
           withCustomImage:nil
       withDoneButtonTitle:nil
                andButtons:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE)
    {
        return 50;
    }
    return 60;
}
-(void)btnAddClick
{
    isEdited = NO;
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    alert.tag = 123;
    alert.colorScheme = [UIColor colorWithRed:44.0/255.0f green:62.0/255.0f blue:80.0/255.0f alpha:1.0];
    UITextField *customField = [[UITextField alloc] init];
    customField.placeholder = @"Enter Surface Message";
    [alert addTextFieldWithCustomTextField:customField andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
        NSLog(@"Custom TextField Returns: %@", text); // Do what you'd like with the text returned from the field
        
        strUpdatedMsg = text;
    }];
    [alert addButton:@"Cancel" withActionBlock:^{
        NSLog(@"Custom Font Button Pressed");
        // Put your action here
    }];
    
    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:@"Enter Surface Message"
           withCustomImage:nil
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)ValidationforAddedMessage:(NSString *)text
{
    if ([[self checkforValidString:text] isEqualToString:@"NA"])
    {
        [self showErrorMessage:@"Please enter message."];
    }
    else
    {
        if ([text length] <=18)
        {
            if (isEdited)
            {
                NSString * updateIndx = [[arrMessages objectAtIndex:selectedIndex] valueForKey:@"indexStr"];
                NSString * strInsertCan = [NSString stringWithFormat:@"update NewCanned_message set Message ='%@' where indexStr = '%@'",text,updateIndx];
                
                strInsertCan = [NSString stringWithFormat:@"update NewCanned_message set Message ='%@' where indexStr = '%@'",text,updateIndx];
                [[DataBaseManager dataBaseManager] execute:strInsertCan];
                
                if ([arrMessages count]>=selectedIndex)
                {
                    [[arrMessages objectAtIndex:selectedIndex] setObject:text forKey:@"Message"];
                }
                [tblView reloadData];
            }
            else
            {
                int myInt =0;
                if ([arrMessages count]==0)
                {
                    
                }
                else
                {
                    myInt = [[[arrMessages objectAtIndex:[arrMessages count]-1] valueForKey:@"indexStr"] intValue];
                }
                
                NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewCanned_message' ('Message','is_emergency','indexStr') values ('%@','No','%@')",text,[NSString stringWithFormat:@"%d",myInt+1]];
                strInsertCan = [NSString stringWithFormat:@"insert into 'NewCanned_message' ('Message','is_emergency','indexStr') values ('%@','No','%@')",text,[NSString stringWithFormat:@"%d",myInt+1]];
                
                [[DataBaseManager dataBaseManager] execute:strInsertCan];
                
                NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] init];
                [tmpDict setObject:text forKey:@"Message"];
                [tmpDict setObject:[NSString stringWithFormat:@"%d",myInt+1] forKey:@"indexStr"];
                [arrMessages addObject:tmpDict];
                [tblView reloadData];
                
                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            //Set Device name code here....
        }
        else
        {
            [self showErrorMessage:@"Message should have 18 characters only."];

        }
    }
}
-(void)showErrorMessage:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)syncBtnClick
{
    /*
    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        [APP_DELEGATE startHudProcess:@"Syncing Messages..."];
        
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
        
        [msgTimer invalidate];
        kpCount = 0;
        msgTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendCandMsg) userInfo:nil repeats:YES];
    }
    else
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Device is disconnected. Please connect Surface device from Dashboard to send message."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
//        SetCannedMsgVC * setCanned = [[SetCannedMsgVC alloc] init];
//        setCanned.isFromCannee = YES;
//        setCanned.cannedMsgArr = [arrycaned mutableCopy];
//        setCanned.isfromScreen = msgType;
//        [self.navigationController pushViewController:setCanned animated:YES];
    }
     */
}

-(void)sendCandMsg
{
    if (kpCount >= [arrMessages count])
    {
        NSLog(@"its done=%ld",(long)kpCount);
        [APP_DELEGATE endHudProcess];
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
        
        FCAlertView *alert = [[FCAlertView alloc] init];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Surface messages synced successfully."
               withCustomImage:nil
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
    else
    {
        NSString * msgStr = [NSString stringWithFormat:@"%@",[[arrMessages objectAtIndex:kpCount] valueForKey:@"Message"]];
        NSString * indexStr = [NSString stringWithFormat:@"%@",[[arrMessages objectAtIndex:kpCount] valueForKey:@"indexStr"]];
        
        [[BLEService sharedInstance] sendingTestToDeviceCanned:msgStr with:globalPeripheral withIndex:indexStr];
        kpCount = kpCount +1;
    }
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Helper Methods

- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    NSLog(@"Button Clicked: %ld Title:%@", (long)index, title);
    
    if (alertView.tag == 123)
    {
        
    }
}

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView
{
    NSLog(@"Done Button Clicked");
    if (alertView.tag == 123)
    {
        [self ValidationforAddedMessage:strUpdatedMsg];
    }
}

- (void)FCAlertViewDismissed:(FCAlertView *)alertView
{
    NSLog(@"Alert Dismissed");
}

- (void)FCAlertViewWillAppear:(FCAlertView *)alertView
{
    NSLog(@"Alert Will Appear");
}
-(NSString *)checkforValidString:(NSString *)strRequest
{
    NSString * strValid;
    if (![strRequest isEqual:[NSNull null]])
    {
        if (strRequest != nil && strRequest != NULL && ![strRequest isEqualToString:@""])
        {
            strValid = strRequest;
        }
        else
        {
            strValid = @"NA";
        }
    }
    else
    {
        strValid = @"NA";
    }
    return strValid;
}
- (void)didReceiveMemoryWarning
{
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

@end
