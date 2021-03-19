//
//  LeftMenuVC.m
//  SC4App18
//
//  Created by stuart watts on 17/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "LeftMenuVC.h"
#import "LeftMenuCell.h"
#import "ComposeMsgVC.h"
#import "RadarViewController.h"
#import "SettingsVC.h"
#import "HomingVC.h"
#import "LocateVC.h"


@interface LeftMenuVC ()<FCAlertViewDelegate>
{
    NSInteger selectedIndex;
    NSMutableArray * filteredContacts;
   
    
}
@end

@implementation LeftMenuVC

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[APP_DELEGATE getbackgroundImage]];;
    [self.view addSubview:imgBack];
    
    UIImageView * img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"logo.png"];
    img.backgroundColor = [UIColor clearColor];
    [self.view addSubview:img];
    
    UIButton * btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin addTarget:self action:@selector(btnLoginClick) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnLogin];
    
    
    int headerhHeight = 64;
    if (IS_IPAD)
    {
        headerhHeight = 74;
        viewWidth = 320;
        imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
        imgBack.image = [UIImage imageNamed:@"left_bg.png"];
        img.frame = CGRectMake((viewWidth-244)/2,20+(headerhHeight-30)/2, 244, 47);
        btnLogin.frame = CGRectMake(0,0,viewWidth,headerhHeight+30);
        
    }
    else
    {
        headerhHeight = 64;
        if (IS_IPHONE_X)
        {
            headerhHeight = 88;
        }
        viewWidth = DEVICE_WIDTH-50;
        img.frame = CGRectMake((viewWidth-177)/2,20+(headerhHeight-30)/2, 177, 36);
        imgBack.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        btnLogin.frame = CGRectMake(0,0,viewWidth,headerhHeight+30);
    }
    
    [self setViewdData];
    
    tblContent = [[UITableView alloc] initWithFrame:CGRectMake(0, headerhHeight+60, viewWidth, DEVICE_HEIGHT-headerhHeight-60) style:UITableViewStylePlain];
    [tblContent setBackgroundColor:[UIColor clearColor]];
    [tblContent setShowsVerticalScrollIndicator:NO];
    tblContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblContent.delegate = self;
    tblContent.dataSource = self;
    [self.view addSubview:tblContent];
    
    if (IS_IPHONE)
    {
        tblContent.frame = CGRectMake(0, headerhHeight+40, viewWidth, DEVICE_HEIGHT-headerhHeight-40);
    }
    [self setBottomView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setBottomView
{
    UIImageView * bgLink = [[UIImageView alloc] init];
    bgLink.frame = CGRectMake(0, DEVICE_HEIGHT-180, viewWidth, 176);
    bgLink.image = [UIImage imageNamed:@"quicklink_bg.png"];
    [self.view addSubview:bgLink];
    
    UIImageView * imgQuick = [[UIImageView alloc] init];
    imgQuick.frame = CGRectMake(28, DEVICE_HEIGHT-200,264,176);
    imgQuick.image = [UIImage imageNamed:@"quicklink_full.png"];
    [self.view addSubview:imgQuick];
    
    if (IS_IPHONE)
    {
        imgQuick.frame = CGRectMake((viewWidth-220*approaxSize)/2, DEVICE_HEIGHT-160*approaxSize,220*approaxSize,143*approaxSize);
    }
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    [self.view addSubview:btn2];
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    [self.view addSubview:btn3];
    
    UIButton * btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    [self.view addSubview:btn4];
    
    UIButton * btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake((viewWidth-78)/2, DEVICE_HEIGHT-100, 78, 78);
    btnDelete.backgroundColor = [UIColor clearColor];
    btnDelete.layer.masksToBounds = YES;
    //    btnDelete.layer.borderWidth = 1;
    btnDelete.layer.cornerRadius = 39;
    btnDelete.tag = 5;
    //    btnDelete.layer.borderColor = [UIColor redColor].CGColor;
    [btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDelete];
    
    if (IS_IPHONE)
    {
        int yyyH = 0;
        if (IS_IPHONE_X)
        {
            bgLink.frame = CGRectMake(0, DEVICE_HEIGHT-180-44, viewWidth, 176);
            imgQuick.frame = CGRectMake(28, DEVICE_HEIGHT-200-44,264,176);
            yyyH =50;
        }
        CGRect rect1 = CGRectMake(25*approaxSize, (DEVICE_HEIGHT-85*approaxSize)-yyyH, 60*approaxSize, 60*approaxSize);
        [self setButtonFrame:rect1 forButton:btn1];
        
        CGRect  rect2 = CGRectMake(65*approaxSize, (DEVICE_HEIGHT-150*approaxSize)-yyyH, 60*approaxSize, 60*approaxSize);
        [self setButtonFrame:rect2 forButton:btn2];
        
        CGRect  rect3 = CGRectMake(145*approaxSize,(DEVICE_HEIGHT-150*approaxSize)-yyyH, 60*approaxSize, 60*approaxSize);
        [self setButtonFrame:rect3 forButton:btn3];
        
        CGRect  rect4 = CGRectMake(185*approaxSize, (DEVICE_HEIGHT-85*approaxSize)-yyyH, 60*approaxSize, 60*approaxSize);
        [self setButtonFrame:rect4 forButton:btn4];
        
        btnDelete.frame = CGRectMake((viewWidth-60*approaxSize)/2,( DEVICE_HEIGHT-80*approaxSize)-yyyH, 60*approaxSize, 60*approaxSize);
        btnDelete.layer.cornerRadius = 30*approaxSize;
    }
    else
    {
        CGRect rect1 = CGRectMake(25, DEVICE_HEIGHT-108, 78, 78);
        [self setButtonFrame:rect1 forButton:btn1];
        
        CGRect  rect2 = CGRectMake(70, DEVICE_HEIGHT-190, 78, 78);
        [self setButtonFrame:rect2 forButton:btn2];
        
        CGRect  rect3 = CGRectMake(169, DEVICE_HEIGHT-190, 78, 78);
        [self setButtonFrame:rect3 forButton:btn3];
        
        CGRect  rect4 = CGRectMake(220, DEVICE_HEIGHT-105, 78, 78);
        [self setButtonFrame:rect4 forButton:btn4];
    }
}
-(void)setButtonFrame:(CGRect)btnFrame forButton:(UIButton *)btn
{
    btn.frame = btnFrame;
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.masksToBounds = YES;
    //    btn.layer.borderColor = [UIColor redColor].CGColor;
    //    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(BtnHeatClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 39;
    if (IS_IPHONE)
    {
        btn.layer.cornerRadius = 30*approaxSize;
    }
}

-(void)setViewdData
{
    arrContent = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <6; i++)
    {
        NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] init];
        if (i==0)
        {
            [tempDict setValue:@"dashboard.png" forKey:@"image"];
            [tempDict setValue:@"Dashboard" forKey:@"name"];
        }
        else if (i==1)
        {
            [tempDict setValue:@"message.png" forKey:@"image"];
            [tempDict setValue:@"Compose Message" forKey:@"name"];
        }
        else if (i==2)
        {
            [tempDict setValue:@"diverioc8.png" forKey:@"image"];
            [tempDict setValue:@"Dirverloc8" forKey:@"name"];
        }
        else if (i==3)
        {
            [tempDict setValue:@"Locate.png" forKey:@"image"];
            [tempDict setValue:@"Locate Mode" forKey:@"name"];
        }
//        else if (i==4)
//        {
//            [tempDict setValue:@"Home.png" forKey:@"image"];
//            [tempDict setValue:@"Homing Mode" forKey:@"name"];
//        }
        else if (i==4)
        {
            [tempDict setValue:@"settings.png" forKey:@"image"];
            [tempDict setValue:@"Settings" forKey:@"name"];
        }
        else if (i==5)
               {
                   [tempDict setValue:@"wifi.png" forKey:@"image"];
                   [tempDict setValue:@"WI-FI" forKey:@"name"];
                   
                   
                   
               }
        [arrContent addObject:tempDict];
    }
}

#pragma mark - Tableview Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD)
    {
        return 60;
    }
    else
    {
        return 50;
    }
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrContent count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = nil;
    
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblLine.hidden = YES;
    cell.imgArrow.hidden = YES;
    
    cell.lblName.text = [[arrContent objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.imgIcon.image = [UIImage imageNamed:[[arrContent objectAtIndex:indexPath.row] valueForKey:@"image"]];
   
    if (indexPath.row == selectedIndex)
    {
        cell.lblName.font = [UIFont fontWithName:CGBold size:textSize];
    }
    else
    {
        cell.lblName.font = [UIFont fontWithName:CGRegular size:textSize];
    }
    if (IS_IPAD)
    {
        cell.lblLine.frame = CGRectMake(0, 69.5, viewWidth,0.5);
        [cell.lblName setFrame:CGRectMake(50, 0,viewWidth-50,60)];
        [cell.imgIcon setFrame:CGRectMake(10, 17, 26, 26)];
        
        if (indexPath.row == 4)
        {
            [cell.imgIcon setFrame:CGRectMake(10, 15, 30, 30)];
        }
        
        if (indexPath.row == 5)
              {
                  [cell.wifiSwitch setOn:NO];
                  cell.wifiSwitch.hidden = false;
                  cell.selectionStyle = UITableViewCellSelectionStyleNone;
                  cell.wifiSwitch.tag = 123;
                  
                  if (cell.wifiSwitch.tag == 0)
                 {
                     cell.wifiSwitch.on = YES;
                 }
                  else
                  {
                      cell.wifiSwitch.on = NO;
                  }
                  
                  [cell.wifiSwitch addTarget:self action:@selector(wifiSwitchClick:) forControlEvents:UIControlEventValueChanged];
              }
    }
    else
    {
        cell.lblLine.frame = CGRectMake(0, 49.5, viewWidth, 0.5);
        [cell.lblName setFrame:CGRectMake(40, 0,viewWidth-50,50)];
        [cell.imgArrow setFrame:CGRectMake(viewWidth-20, 17.5, 15, 15)];
        [cell.imgIcon setFrame:CGRectMake(10, 15, 20, 20)];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == indexPath.row)
    {
        if (indexPath.row ==3 || indexPath.row ==4)
        {
            if (isAllowtoPush == NO)
            {
                return;
            }
        }
        else
        {
            return;
        }
    }
    selectedIndex = indexPath.row;
    [tableView reloadData];
    if (IS_IPHONE)
    {
        if (indexPath.row ==0)
        {
            DashboardVC *demoController = [[DashboardVC alloc] init];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else if (indexPath.row==1)
        {
            ComposeMsgVC *demoController = [[ComposeMsgVC alloc] init];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else if (indexPath.row==2)
        {
            RadarViewController *demoController = [[RadarViewController alloc] init];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else if (indexPath.row==3)
        {
            LocateVC *demoController = [[LocateVC alloc] init];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
//        else if (indexPath.row==4)
//        {
//            HomingVC *demoController = [[HomingVC alloc] init];
//            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//            NSArray *controllers = [NSArray arrayWithObject:demoController];
//            navigationController.viewControllers = controllers;
//            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//        }
        else if (indexPath.row==4)
        {
            SettingsVC *demoController = [[SettingsVC alloc] init];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else if (indexPath.row==5)
        {
         
            
 
            
        }
    }
    else
    {
        if (indexPath.row ==0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MovetoDashboard" object:nil];
        }
        else if (indexPath.row==1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MovetoComposeMsg" object:nil];
        }
        else if (indexPath.row==2)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MovetoRadar" object:nil];
        }
        else if (indexPath.row==3)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveLocateDevice" object:nil];
        }
//        else if (indexPath.row==4)
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MovetoHoming" object:nil];
//        }
        else if (indexPath.row==4)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MovetoSettings" object:nil];
        }
        else if (indexPath.row==5)
                 {
                     
                     
                     
                 }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == selectedIndex)
    {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"active_left_menus.png"]];
        //        cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    if (indexPath.row == 5)
    {
         cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"left_menu_bg.png"]];
    }
}

#pragma mark - Button event Methods
-(void)BtnHeatClick:(id)sender
{
    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        filteredContacts = [[NSMutableArray alloc]init];
        NSString * strContat = [NSString stringWithFormat:@"select * from NewContact"];
        [[DataBaseManager dataBaseManager] execute:strContat resultsArray:filteredContacts];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, d MMMM yyyy"];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm:ss"];
        NSString * myTime= [timeFormatter stringFromDate:date];
        
        NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
        if ([sender tag] == 1)
        {
            [dict setObject:myTime forKey:@"time"];
            [dict setObject:@"Heat1" forKey:@"button_title"];
            [[DataBaseManager dataBaseManager]insertErrorLogDetail:dict];
            
            [self sendMessagetoAll:@"1" withMsg:@"Stop"];
        }
        else if ([sender tag] == 2)
        {
            [dict setObject:myTime forKey:@"time"];
            [dict setObject:@"Heat2" forKey:@"button_title"];
            [[DataBaseManager dataBaseManager]insertErrorLogDetail:dict];
            
            [self sendMessagetoAll:@"2" withMsg:@"Go"];
        }
        
        else if ([sender tag] == 3)
        {
            [dict setObject:myTime forKey:@"time"];
            [dict setObject:@"Heat3" forKey:@"button_title"];
            [[DataBaseManager dataBaseManager]insertErrorLogDetail:dict];
            
            [self sendMessagetoAll:@"3" withMsg:@"Report"];
        }
        else if ([sender tag] == 4)
        {
            [dict setObject:myTime forKey:@"time"];
            [dict setObject:@"Heat4" forKey:@"button_title"];
            [[DataBaseManager dataBaseManager]insertErrorLogDetail:dict];
            
            [self sendMessagetoAll:@"4" withMsg:@"Complete"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"errorLogRefresh" object:nil];
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
    }
}
-(void)btnDeleteClick
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, d MMMM yyyy"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    NSString * myTime= [timeFormatter stringFromDate:date];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
    [dict setObject:myTime forKey:@"time"];
    [dict setObject:@"Delete" forKey:@"button_title"];
    [[DataBaseManager dataBaseManager]insertErrorLogDetail:dict];
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert addButton:@"Yes" withActionBlock:^{
        NSLog(@"Custom Font Button Pressed");
        // Put your action here
        [self deleteMessagesfromDatabase];
    }];
    alert.firstButtonCustomFont = [UIFont fontWithName:CGRegular size:textSize];
    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:@"Are you sure want to delete message history ?"
           withCustomImage:[UIImage imageNamed:@"Subsea White 180.png"]
       withDoneButtonTitle:@"No" andButtons:nil];
}
-(void)btnLoginClick
{
    [APP_DELEGATE MoveToSplash];
}
-(void)sendMessagetoAll:(NSString *)sentIndex withMsg:(NSString *)sentMsg
{
    NSInteger cmdInt = [@"05" integerValue]; //Command
    NSData * cmdData = [[NSData alloc] initWithBytes:&cmdInt length:1];
    
    NSInteger lengthInt = [@"06" integerValue]; //length of Message
    NSData * lengthData = [[NSData alloc] initWithBytes:&lengthInt length:1];

    long long nanoInt = 4294967295; //Nano Modem ID
    NSData * nanoData = [[NSData alloc] initWithBytes:&nanoInt length:4];

    NSInteger opcodeInt = [@"01" integerValue]; //Opcode
    NSData * opcodeData = [[NSData alloc] initWithBytes:&opcodeInt length:1];
    
    NSInteger dataInt=  [sentIndex integerValue]; // Message data
    NSData * dataData = [[NSData alloc] initWithBytes:&dataInt length:1];
    
    NSInteger sequenceInt =  0; // Sequence data
    NSData * sequenceData = [[NSData alloc] initWithBytes:&sequenceInt length:4];

    NSMutableData *completeData = [cmdData mutableCopy];
    [completeData appendData:lengthData];
    [completeData appendData:nanoData];
    [completeData appendData:opcodeData];
    [completeData appendData:dataData];
    [completeData appendData:sequenceData];

    [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
    
    {
        double dateStamp = [[NSDate date] timeIntervalSince1970];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString * timeStr =[dateFormatter stringFromDate:[NSDate date]];
        {
            for (int i=0; i<[filteredContacts count]; i++)
            {
                NSString * strName = [[filteredContacts objectAtIndex:i] valueForKey:@"name"];
                NSString * strNano = [[filteredContacts objectAtIndex:i] valueForKey:@"SC4_nano_id"];
                
                NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewChat' ('from_name','from_nano','to_name','to_nano','msg_id','msg_txt','time','status','timeStamp','sequence') values ('%@','%@','%@','%@','%@','%@','%@','%@','%f','%d')",@"Me",@"Me",strName,strNano,sentIndex,sentMsg,timeStr,@"Broadcast",dateStamp,sequenceInt];
                [[DataBaseManager dataBaseManager] execute:strInsertCan];
                
                NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set msg ='%@', time='%@' where SC4_nano_id='%@'",sentMsg,timeStr,strNano];
                [[DataBaseManager dataBaseManager] execute:strUpdate];
            }
        }
    }
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeSuccess];
    [alert showAlertInView:self
                 withTitle:@"Combat Diver"
              withSubtitle:@"Message has been sent successfully."
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMainTableView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"historyRefresh" object:nil];
    
    
    [APP_DELEGATE endHudProcess];
}
-(void)deleteMessagesfromDatabase
{
    NSString * strDelete = [NSString stringWithFormat:@"Delete from NewChat"];//KP13-04-2015.
    [[DataBaseManager dataBaseManager]execute:strDelete];
    
    NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set msg = ''"];//KP13-04-2015.
    [[DataBaseManager dataBaseManager]execute:strUpdate];
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
-(void)wifiSwitchClick:(id)sender
{
    UISwitch * tmpswtch = (UISwitch *)[self.view viewWithTag:123];
    
    int valueSwitch = 0;
    if(globalPeripheral.state == CBPeripheralStateConnected)
    {
        NSString *strText = [[NSString alloc]init];

        if (tmpswtch.on)
        {
            valueSwitch = 1;
            strText =  @"Are you sure want turn on WIFI";
        }
        else
        {
            valueSwitch = 0 ;
            strText = @"Are you sure want to turn off WIFI";
        }
       
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.tag = 55;
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeCaution];
        alert.delegate = self;

        [alert addButton:@"Yes" withActionBlock:^{
        NSLog(@"Yes Button Pressed");

            // Put yes action here

               NSInteger cmdInt = [@"160" integerValue]; //Command
               NSData * cmdData = [[NSData alloc] initWithBytes:&cmdInt length:1];

               NSInteger lengthInt = [@"01" integerValue]; //length of Message
               NSData * lengthData = [[NSData alloc] initWithBytes:&lengthInt length:1];

               NSInteger dataInt =  valueSwitch; // Message data 01 to ON, 00 to off WIFI
               NSData * dataData = [[NSData alloc] initWithBytes:&dataInt length:1];

               NSMutableData *completeData = [cmdData mutableCopy];
               [completeData appendData:lengthData];
               [completeData appendData:dataData];
               [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
        }];
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:strText
                  withCustomImage:[UIImage imageNamed:@"logo.png"]
                  withDoneButtonTitle:@"No"
         
                    andButtons:nil];
      }
    else
        {
            tmpswtch.on = NO;
            FCAlertView *alert = [[FCAlertView alloc] init];
            alert.colorScheme = [UIColor blackColor];
            [alert makeAlertTypeWarning];
            [alert showAlertInView:self
                         withTitle:@"Combat Diver"
                      withSubtitle:@"Device is disconnected. Please connect Surface device from Dashboard to turn on/off WIFI."
                   withCustomImage:[UIImage imageNamed:@"logo.png"]
               withDoneButtonTitle:nil
                        andButtons:nil];
      }
}
#pragma mark - Helper Methods

- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    NSLog(@"Button Clicked: %ld Title:%@", (long)index, title);
  
    if (alertView.tag == 55)
    {
  
   }
}
- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView
{
    NSLog(@"Done Button Clicked");
    if (alertView.tag == 55)
    {
        UISwitch * tmpswtch = (UISwitch *)[self.view viewWithTag:123];
        if (tmpswtch.on == YES)
        {
            NSLog(@"%@", tmpswtch.on = NO);

        }
        else
        {
            tmpswtch.on = true;
            
        }
    }
}

@end
