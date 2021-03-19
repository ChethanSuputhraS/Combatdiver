//
//  SettingsVC.m
//  SC4App18
//
//  Created by stuart watts on 07/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "SettingsVC.h"
#import "SettingCell.h"
#import "DeviceSetupVC.h"
#import "SurfaceMessageVC.h"
#import "DiverMessageVC.h"
#import "AddressBookVC.h"
#import "HistoryVC.h"
#import "UserManualVC.h"
#import "HeatMsgVC.h"

@interface SettingsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * strBtryValue;
}
@end

@implementation SettingsVC

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

    strBtryValue = @"20";
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, headerhHeight)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewWidth,headerhHeight)];
    lblBack.backgroundColor = [UIColor blackColor];
    lblBack.alpha = 0.4;
    [viewHeader addSubview:lblBack];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Settings"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];

    [self setupMainContentView:headerhHeight];
    
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

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    isAllowtoPush = NO;
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    isAllowtoPush = YES;
    [super viewWillDisappear:animated];
}
-(void)setupMainContentView:(int)headerHeights
{
    arrContent = [[NSMutableArray alloc] init];
    for (int i = 0; i <7; i++)
    {
        NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] init];
        if (i==0)
        {
            [tempDict setValue:@"preference.png" forKey:@"image"];
            [tempDict setValue:@"Setup for devices" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"25" forKey:@"height"];
        }
        else if (i==1)
        {
            [tempDict setValue:@"surfaceMsg.png" forKey:@"image"];
            [tempDict setValue:@"Surface Messages" forKey:@"name"];
            [tempDict setValue:@"27" forKey:@"width"];
            [tempDict setValue:@"27" forKey:@"height"];
        }
        else if (i==2)
        {
            [tempDict setValue:@"diver_default.png" forKey:@"image"];
            [tempDict setValue:@"Diver Messages" forKey:@"name"];
            [tempDict setValue:@"27" forKey:@"width"];
            [tempDict setValue:@"26" forKey:@"height"];
        }
        else if (i==3)
        {
            [tempDict setValue:@"addres_book.png" forKey:@"image"];
            [tempDict setValue:@"Address Book" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"29" forKey:@"height"];
        }
        else if (i==4)
        {
            [tempDict setValue:@"history.png" forKey:@"image"];
            [tempDict setValue:@"History" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"23" forKey:@"height"];
        }
        else if (i==5)
        {
            [tempDict setValue:@"user_manual.png" forKey:@"image"];
            [tempDict setValue:@"User Manual" forKey:@"name"];
            [tempDict setValue:@"26" forKey:@"width"];
            [tempDict setValue:@"25" forKey:@"height"];
        }
        else if (i==6)
        {
            [tempDict setValue:@"heat.png" forKey:@"image"];
            [tempDict setValue:@"Heat Messages" forKey:@"name"];
            [tempDict setValue:@"27" forKey:@"width"];
            [tempDict setValue:@"27" forKey:@"height"];
        }
        [arrContent addObject:tempDict];
    }
    
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, headerHeights + 10, viewWidth-60, DEVICE_HEIGHT-headerHeights);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth-60, DEVICE_HEIGHT-headerHeights)];
    tblView.rowHeight=80;
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    [backView addSubview:tblView];
    
    if (IS_IPHONE)
    {
        backView.frame = CGRectMake(10, headerHeights + 10, viewWidth-20, DEVICE_HEIGHT-headerHeights);
        tblView.frame = CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights);
    }
    
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds];
//    backView.layer.masksToBounds = NO;
//    backView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    backView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    backView.layer.shadowOpacity = 0.5f;
//    backView.layer.shadowPath = shadowPath.CGPath;
}
-(void)btnLeftMenuClicked
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
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
    return  8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int heghtt = 60;
    if (IS_IPHONE)
    {
        heghtt = 50;
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[SettingCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblName.textColor=[UIColor whiteColor];
    cell.lblName.font = [UIFont fontWithName:CGRegular size:textSize+1];
    cell.lblName.frame = CGRectMake(70, 0, viewWidth-40, heghtt);
    
    cell.imgIcon.frame = CGRectMake(15, (heghtt-24)/2, 33, 24);

    if (indexPath.row==7)
    {
        cell.btrySlider.frame = CGRectMake(20, 50, viewWidth-200, 44);
        cell.lblBack.frame = CGRectMake(0, 0, viewWidth, 110);
        
        cell.btrySlider.hidden = NO;
        cell.lblValue.hidden = NO;

        cell.lblName.text= @"Set Battery Level";
        
        cell.lblValue.frame = CGRectMake(viewWidth-140, 43, 50, 50);
        [cell.btrySlider addTarget:self action:@selector(changeBatteryValue:) forControlEvents:UIControlEventValueChanged];
        cell.lblValue.text = strBtryValue;
        
        if (IS_IPHONE)
        {
            cell.lblName.frame = CGRectMake(20, 0, viewWidth-40, heghtt);
            cell.btrySlider.frame = CGRectMake(10, 44, viewWidth-60, 44);
            cell.lblBack.frame = CGRectMake(0, 0, viewWidth, 90);
            cell.lblValue.frame = CGRectMake(175, 10, 40, 40);
            cell.lblValue.layer.cornerRadius = 20;
        }
    }
    else
    {
        cell.imgArrow.frame = CGRectMake(tableView.frame.size.width-20, (heghtt-15)/2, 9, 15);
        cell.imgArrow.image = [UIImage imageNamed:@"arrow.png"];
        cell.imgIcon.image = [UIImage imageNamed:[[arrContent objectAtIndex:indexPath.row] valueForKey:@"image"]];
        
        NSString * strName = [NSString stringWithFormat:@"%@",[[arrContent objectAtIndex:indexPath.row]valueForKey:@"name"]];
        cell.lblName.text= strName;
        
        int WW = [[[arrContent objectAtIndex:indexPath.row] valueForKey:@"width"] intValue];
        int HH = [[[arrContent objectAtIndex:indexPath.row] valueForKey:@"height"] intValue];
        
        cell.imgIcon.frame = CGRectMake(10,(heghtt-HH)/2, WW, HH);
        cell.lblName.frame = CGRectMake(WW + 30, 0, viewWidth-40, heghtt);
        cell.lblBack.frame = CGRectMake(0, 0, viewWidth, heghtt);
        cell.btrySlider.hidden = YES;
        cell.lblValue.hidden = YES;
    }
   
    cell.lblBack.hidden = NO;
    cell.imgIcon.hidden = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        globalDeviceSetup = [[DeviceSetupVC alloc] init];
        [self.navigationController pushViewController:globalDeviceSetup animated:YES];
    }
    else if (indexPath.row==1)
    {
        SurfaceMessageVC * surfaceMessage = [[SurfaceMessageVC alloc] init];
        [self.navigationController pushViewController:surfaceMessage animated:YES];
    }
    else if (indexPath.row==2)
    {
        DiverMessageVC * diverMessage = [[DiverMessageVC alloc] init];
        [self.navigationController pushViewController:diverMessage animated:YES];
    }
    else if (indexPath.row==3)
    {
        AddressBookVC * address = [[AddressBookVC alloc] init];
        [self.navigationController pushViewController:address animated:YES];
    }
    else if (indexPath.row==4)
    {
        HistoryVC * address = [[HistoryVC alloc] init];
        [self.navigationController pushViewController:address animated:YES];
    }
    else if (indexPath.row==5)
    {
        UserManualVC * manualVC = [[UserManualVC alloc] init];
        [self.navigationController pushViewController:manualVC animated:YES];
    }
    else if (indexPath.row==6)
    {
        HeatMsgVC * manualVC = [[HeatMsgVC alloc] init];
        [self.navigationController pushViewController:manualVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==7)
    {
        if (IS_IPHONE)
        {
            return 100;
        }
        return 120;
    }
    if (IS_IPHONE)
    {
        return 55;
    }
    return 70;
}

- (void)changeBatteryValue:(UISlider *)sender
{
    strBtryValue = [NSString stringWithFormat:@"%.f",sender.value];
    NSLog(@"Changed Value==%f",sender.value);
    SettingCell *cell = (SettingCell *)[(UITableView *)tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    cell.lblValue.text = [NSString stringWithFormat:@"%@",strBtryValue];
//    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:7 inSection:0], nil]
//                   withRowAnimation:UITableViewRowAnimationNone];

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
