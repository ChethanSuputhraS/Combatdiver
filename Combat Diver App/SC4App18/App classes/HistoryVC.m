//
//  HistoryVC.m
//  SC4App18
//
//  Created by stuart watts on 08/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "HistoryVC.h"
#import "DashboardCell.h"
#import "ChatVC.h"
#import "SettingsVC.h"

@interface HistoryVC ()

@end

@implementation HistoryVC

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[APP_DELEGATE getbackgroundImage]];
    [self.view addSubview:imgBack];
    
    if (IS_IPAD)
    {
        viewWidth = 704;
        imgBack.frame = CGRectMake(0, 0, 704, DEVICE_HEIGHT);
        imgBack.image = [UIImage imageNamed:@"Ipadright_bg.png"];
        imgBack.image = [UIImage imageNamed:@"right_bg.png"];
    }
    else
    {
        viewWidth = DEVICE_WIDTH;
        imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
        [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
    }
    [self setupHeaderView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    tblView.hidden = NO;
    
    NSMutableArray * lastArr = [[NSMutableArray alloc]init];
    NSString * strMessage = [NSString stringWithFormat:@"SELECT * FROM NewChat"];
    [[DataBaseManager dataBaseManager] execute:strMessage resultsArray:lastArr];
    
    arrMessages = [[NSMutableArray alloc]init];//KP
    NSString * strUsers = [NSString stringWithFormat:@"select * from NewContact where msg != '' and time !=''"];
    [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:arrMessages];
    [tblView reloadData];
    
    if ([arrMessages count]==0)
    {
        tblView.hidden = YES;
    }
    else
    {
        tblView.hidden = NO;
        [tblView reloadData];
    }
}

-(void)refreshTableView
{
    NSMutableArray * lastArr = [[NSMutableArray alloc]init];
    NSString * strMessage = [NSString stringWithFormat:@"SELECT * FROM NewChat"];
    [[DataBaseManager dataBaseManager] execute:strMessage resultsArray:lastArr];
    
    lblSent.text = [NSString stringWithFormat:@"Sent - %lu",(unsigned long)[lastArr count]];
    
    
    arrMessages = [[NSMutableArray alloc] init];
    NSString * strUsers = [NSString stringWithFormat:@"select * from NewContact where msg != '' and time !=''"];
    [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:arrMessages];
    
    [tblView reloadData];
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
            fixedHeight = 88+45;
        }
    }
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, fixedHeight)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH,headerHeight)];
    lblBack.backgroundColor = [UIColor blackColor];
    lblBack.alpha = 0.4;
    [viewHeader addSubview:lblBack];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"History"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+1]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIImageView * backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20+12, 12, 20)];
    [backImg setImage:[UIImage imageNamed:@"back_icon.png"]];
    [backImg setContentMode:UIViewContentModeScaleAspectFit];
    backImg.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:backImg];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(0, 0, 140, headerHeight);
    btnBack.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnBack];
    
    UIImageView * imgDelete = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-40, 20+12, 20, 21)];
    [imgDelete setImage:[UIImage imageNamed:@"delete.png"]];
    [imgDelete setContentMode:UIViewContentModeScaleAspectFit];
    imgDelete.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:imgDelete];
    
    UIButton * btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.frame = CGRectMake(viewWidth-100, 0, 100, 64);
    btnDelete.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnDelete];
    
    
    UILabel * lblMsgStatics = [[UILabel alloc]init];
    lblMsgStatics.frame = CGRectMake(20, 64+12.5,viewWidth-100,120);
    [lblMsgStatics setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    lblMsgStatics.textColor = [UIColor whiteColor];
    lblMsgStatics.textAlignment = NSTextAlignmentLeft;
    lblMsgStatics.text =@"Message Statistics";
    [self.view addSubview:lblMsgStatics];
    
    UILabel * lblBottom = [[UILabel alloc] init];
    lblBottom.frame = CGRectMake(200+20, 64+10+12.5+50, 380, 2);
    lblBottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lblBottom];
    
    UIImageView * imgSent = [[UIImageView alloc] init];
    imgSent.frame = CGRectMake(350+20, 64+12.5, 120, 120);
    imgSent.image = [UIImage imageNamed:@"green_warning.png"];
    [self.view addSubview:imgSent];
    
    lblSent = [[UILabel alloc] init];
    lblSent.text = @"0";
    lblSent.font = [UIFont fontWithName:CGRegular size:textSize+3];
    lblSent.textAlignment = NSTextAlignmentCenter;
    lblSent.frame  = CGRectMake(0, 0, 120, 100);
    lblSent.textColor = [UIColor whiteColor];
    [imgSent addSubview:lblSent];
    
     NSMutableArray * arrMessages = [[NSMutableArray alloc]init];
    NSString * strUsers = [NSString stringWithFormat:@"select * from NewChat where from_name = 'Me' and status != 'Failed' group by time"];
    [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:arrMessages];
    if (arrMessages.count > 0)
    {
        lblSent.text =[NSString stringWithFormat:@"%lu",(unsigned long)arrMessages.count];
    }
    
    UILabel * lblHintSent = [[UILabel alloc] init];
    lblHintSent.text = @"Sent";
    lblHintSent.font = [UIFont fontWithName:CGRegular size:textSize-2];
    lblHintSent.textAlignment = NSTextAlignmentCenter;
    lblHintSent.frame  = CGRectMake(0, 55, 120, 20);
    lblHintSent.textColor = [UIColor whiteColor];
    [imgSent addSubview:lblHintSent];
    
    UIImageView * imgFailed = [[UIImageView alloc] init];
    imgFailed.frame = CGRectMake(380 + 150 + 20, 64+12.5, 120, 120);
    imgFailed.image = [UIImage imageNamed:@"red_warning.png"];
    [self.view addSubview:imgFailed];
    
    lblFailed = [[UILabel alloc] init];
    lblFailed.text = @"0";
    lblFailed.font = [UIFont fontWithName:CGRegular size:textSize+3];
    lblFailed.textAlignment = NSTextAlignmentCenter;
    lblFailed.frame  = CGRectMake(0, 0, 120, 100);
    lblFailed.textColor = [UIColor whiteColor];
    [imgFailed addSubview:lblFailed];
    
    arrMessages = [[NSMutableArray alloc]init];
    strUsers = [NSString stringWithFormat:@"select * from NewChat where from_name = 'Me' and status = 'Failed'  group by time"];
    [[DataBaseManager dataBaseManager] execute:strUsers resultsArray:arrMessages];
    if (arrMessages.count > 0)
    {
        lblFailed.text =[NSString stringWithFormat:@"%lu",(unsigned long)arrMessages.count];
    }
    
    UILabel * lblHintFailed = [[UILabel alloc] init];
    lblHintFailed.text = @"Failed";
    lblHintFailed.font = [UIFont fontWithName:CGRegular size:textSize-2];
    lblHintFailed.textAlignment = NSTextAlignmentCenter;
    lblHintFailed.frame  = CGRectMake(0, 55, 120, 20);
    lblHintFailed.textColor = [UIColor whiteColor];
    [imgFailed addSubview:lblHintFailed];
    
    fixedHeight = 64+120+12.5;
    
    tblView =[[UITableView alloc]initWithFrame:CGRectMake(0,fixedHeight,viewWidth, DEVICE_HEIGHT-fixedHeight)];
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.rowHeight=70;
    tblView.hidden=YES;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:tblView];
    
    if (IS_IPHONE)
    {
        [lblMsgStatics setFont:[UIFont fontWithName:CGRegular size:textSize]];
        
        lblMsgStatics.frame = CGRectMake(5, headerHeight+12.5,viewWidth-100,80);
        lblBottom.hidden = YES;
        
        imgSent.frame = CGRectMake(viewWidth-180, headerHeight+12.5, 80, 80);
        lblSent.frame  = CGRectMake(0, 0, 80, 70);
        lblHintSent.frame  = CGRectMake(0, 45, 80, 20);
        
        imgFailed.frame = CGRectMake(viewWidth-90, headerHeight+12.5, 80, 80);
        lblFailed.frame  = CGRectMake(0, 0, 80, 70);
        lblHintFailed.frame  = CGRectMake(0, 45, 80, 20);
        
        fixedHeight = headerHeight+80+14;
        
        tblView.frame = CGRectMake(0,fixedHeight,viewWidth, DEVICE_HEIGHT-fixedHeight);
        
        if (IS_IPHONE_X)
        {
            viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
            lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
            backImg.frame = CGRectMake(10, 12+44, 12, 20);
            btnBack.frame = CGRectMake(0, 0, 70, 88);
            imgDelete.frame = CGRectMake(viewWidth-40, 12+44, 20, 21);
            btnDelete.frame = CGRectMake(DEVICE_WIDTH-70, 0, 70, 88);
        }
    }
    else
    {
    }
    
}
#pragma mark - Button Methods
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnDeleteClick
{
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
              withSubtitle:@"Are you sure want to delete all message history ?"
           withCustomImage:[UIImage imageNamed:@"Subsea White 180.png"]
       withDoneButtonTitle:@"No" andButtons:nil];
    
}
-(void)deleteMessagesfromDatabase
{
    NSString * strDelete = [NSString stringWithFormat:@"Delete from NewChat"];//KP13-04-2015.
    [[DataBaseManager dataBaseManager]execute:strDelete];
    
    NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set msg = ''"];//KP13-04-2015.
    [[DataBaseManager dataBaseManager]execute:strUpdate];
    [tblView reloadData];
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
    //    return 7;
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
    
    if (![[APP_DELEGATE checkforValidString:[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"HR"]]isEqualToString:@"NA"] || [[APP_DELEGATE checkforValidString:[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"HR"]]isEqualToString:@"--"])
    {
        cell.lblHR.text = [NSString stringWithFormat:@"%@ BPM",[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"HR"]];
        //        cell.lblDistance.text = [NSString stringWithFormat:@"%@ BPM",[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"RR"]];
        //        cell.lblTemp.text = [NSString stringWithFormat:@"%@ °C",[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"temp"]];
        
    }
//    cell.imgBtry.image = [UIImage imageNamed:@"red_warning.png"];
//    if ([[APP_DELEGATE checkforValidString:[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Air"]]isEqualToString:@"NA"])
//    {
//        cell.lblAirValue.text = @"NA";
//        cell.lblAir.hidden = true;
//    }
//    else
//    {
//        int tmpValue = [[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Air"] intValue];
//        if (tmpValue > 20)
//        {
//            cell.imgBtry.image = [UIImage imageNamed:@"green_warning.png"];
//        }
//        cell.lblAirValue.text = [NSString stringWithFormat:@"%@%%",[[arrMessages objectAtIndex:indexPath.row]valueForKey:@"Air"]];
//        cell.lblAir.hidden = false;
//    }
    cell.lbldiviceid.hidden = true;
    cell.lblContact.hidden = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //sri
    cell.imgHR.hidden = true;
    cell.lblHR.hidden = true;
    cell.imgDistance.hidden = true;
    cell.lblDistance.hidden = true;
    cell.imgTemp.hidden = true;
    cell.lblTemp.hidden = true;
    cell.lblAirValue.text = @"NA";
    cell.lblAir.hidden = true;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    globalChatVC =[[ChatVC alloc]init];
    globalChatVC.userNano = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"id"];
    globalChatVC.userName = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"name"];
    globalChatVC.sc4NanoId = [[arrMessages objectAtIndex:indexPath.row] valueForKey:@"SC4_nano_id"];
    globalChatVC.isFrom = @"History";
    [self.navigationController pushViewController:globalChatVC animated:YES];
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

@end
/*
 2020-02-28 18:06:07.422 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0109 0c165c02 32>
 2020-02-28 18:06:07.423 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->0c165c02
 2020-02-28 18:06:12.030 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0109 71d7ad01 32>
 2020-02-28 18:06:12.031 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->71d7ad01
 2020-02-28 18:06:16.004 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0106 df5b6500 32>
 2020-02-28 18:06:16.006 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->df5b6500
 2020-02-28 18:06:20.198 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0107 a9391d00 32>
 2020-02-28 18:06:20.199 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->a9391d00
 2020-02-28 18:06:24.218 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0109 03cf9a05 32>
 2020-02-28 18:06:24.219 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->03cf9a05
 2020-02-28 18:06:28.328 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0106 effdb403 32>
 2020-02-28 18:06:28.329 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->effdb403
 2020-02-28 18:06:32.348 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0106 c7886302 32>
 2020-02-28 18:06:32.349 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->c7886302
 2020-02-28 18:06:36.428 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0102 b4d3d703 32>
 2020-02-28 18:06:36.429 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->b4d3d703
 2020-02-28 18:06:50.288 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<05060000 00000864>

 */
