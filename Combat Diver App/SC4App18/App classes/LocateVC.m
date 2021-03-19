//
//  LocateVC.m
//  SC4App18
//
//  Created by srivatsa s pobbathi on 06/09/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "LocateVC.h"
#import "LeftMenuCell.h"
#import "DeviceStatusVC.h"
@interface LocateVC ()<FCAlertViewDelegate,UITableViewDelegate, UITableViewDataSource>
{
    int headerhHeight,viewWidth;
    NSTimer *  msgTimer;
    NSInteger selectedIndex,kpCount;
    BOOL isEdited;
    NSMutableArray * arrContacts;
    UITableView * tblView;
  
}
@end

@implementation LocateVC

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
    [lblTitle setText:@"Locate Mode"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UILabel * lblHint = [[UILabel alloc] initWithFrame:CGRectZero];
    lblHint.backgroundColor = [UIColor clearColor];
    lblHint.frame=CGRectMake(0, 64, 707, 50);
    lblHint.font = [UIFont systemFontOfSize:18];
    lblHint.textAlignment = NSTextAlignmentCenter;
    lblHint.textColor = [UIColor whiteColor];
    [lblHint setFont:[UIFont fontWithName:CGRegular size:textSize+1]];
    lblHint.text = NSLocalizedString(@"Select any Diver from the list to know his location",@"");
    [self.view addSubview:lblHint];

    if (IS_IPHONE)
    {
        UIImageView * imgMenu = [[UIImageView alloc] init];
        imgMenu.frame = CGRectMake(10, 20+13.5, 24, 17);
        imgMenu.image = [UIImage imageNamed:@"menu_icon.png"];
        [self.view addSubview:imgMenu];
        
        UIButton * btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerhHeight, headerhHeight)];
        [btnMenu setBackgroundColor:[UIColor clearColor]];
        [btnMenu addTarget:self action:@selector(btnLeftMenuClicked) forControlEvents:UIControlEventTouchUpInside];
        lblHint.frame=CGRectMake(0, headerhHeight, viewWidth, 50);
        [self.view addSubview:btnMenu];

        if (IS_IPHONE_X)
        {
            viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
            lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
            imgMenu.frame = CGRectMake(10, 13.5+44, 24, 17);
            btnMenu.frame = CGRectMake(0, 0, 70, 88);
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

-(void)btnLeftMenuClicked
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}
-(void)setupMainContentView:(int)headerHeights
{
    arrContacts = [[NSMutableArray alloc] init];
    
    NSString * strQuery = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrContacts];
    if ([arrContacts count]==0)
    {
        NSArray * tmpArr = [[NSArray alloc] initWithObjects:@"Boat 1",@"Boat 2",@"Diver 1",@"Diver 2",@"Diver 3", nil];
        for (int i = 0; i<[tmpArr count]; i++)
        {
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewContact' ('name','nano') values ('%@','%d')",[tmpArr objectAtIndex:i],i+1];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        }
        NSString * strQuery = [NSString stringWithFormat:@"select * from NewCanned_message"];
        [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrContacts];
    }
    
    [arrContacts setValue:@"NO" forKey:@"isSelected"];
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, headerHeights, viewWidth-60, DEVICE_HEIGHT-headerHeights);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth-60, backView.frame.size.height-80)];
    tblView.rowHeight=80;
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    tblView.showsVerticalScrollIndicator = false;
    tblView.showsHorizontalScrollIndicator = false;
    [backView addSubview:tblView];
    
    
    if (IS_IPHONE)
    {
        backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights);
        tblView.frame = CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-50);
        
        if (IS_IPHONE_X)
        {
            backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights-40);
            tblView.frame = CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-50-40);
        }
    }
}
#pragma mark - All Button Click Events


    
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
    return  [arrContacts count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int vHeight = 65;
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
    cell.lblName.frame = CGRectMake(70, 0, viewWidth-40, vHeight/2);
    cell.lblName.text= [NSString stringWithFormat:@"Name : %@",[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"name"]];
    
    cell.lblNanoID.hidden = false;
    cell.lblNanoID.frame = CGRectMake(70, vHeight/2, viewWidth/2-70-30, vHeight/2);
    
    cell.lblIrridiumID.hidden = false;
    cell.lblIrridiumID.frame = CGRectMake(70, vHeight/2, viewWidth/2-70, vHeight/2);
    cell.lblIrridiumID.text = [NSString stringWithFormat:@"Irridium ID : %@",[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"irridium_id"]];
    
    cell.lblBack.frame = CGRectMake(0, 0, viewWidth, vHeight);
    cell.imgIcon.frame = CGRectMake(15, (vHeight-30)/2, 40, 30);
    cell.imgIcon.image = [UIImage imageNamed:@"diver_default.png"];
    cell.imgIcon.hidden = NO;
    cell.lblLine.hidden = YES;
    cell.imgArrow.hidden = YES;
    cell.lblBack.hidden = NO;
    cell.imgArrow.frame = CGRectMake(viewWidth-70-50, 15, 40, 40);
  
    if (IS_IPHONE)
    {
        cell.lblName.frame = CGRectMake(50, 5,100, 24);
        cell.lblName.text= [[arrContacts objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblContact.textAlignment = NSTextAlignmentRight;
        cell.lblContact.frame = CGRectMake(DEVICE_WIDTH-180, 5, 155, 24);
        cell.lblContact.text =[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"phone"];
        cell.lblNanoID.frame = CGRectMake(15, 30, viewWidth-40, 35/2);
        cell.lblIrridiumID.frame = CGRectMake(15, 30+(35/2), viewWidth-40, 35/2);
        cell.lblName.font = [UIFont fontWithName:CGRegular size:textSize-1];
        cell.lblContact.font = [UIFont fontWithName:CGRegular size:textSize-1];
        cell.lblNanoID.font = [UIFont fontWithName:CGRegular size:textSize-2];
        cell.lblIrridiumID.font = [UIFont fontWithName:CGRegular size:textSize-2];
        cell.imgIcon.frame = CGRectMake(15, 5, 33, 24);
        
        if (IS_IPHONE_5)
        {
            cell.lblNanoID.font = [UIFont fontWithName:CGRegular size:textSize-3];
            cell.lblIrridiumID.font = [UIFont fontWithName:CGRegular size:textSize-3];
        }
    }
    else
    {
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:cell.lblName.text];
        NSMutableAttributedString * string2 = [[NSMutableAttributedString alloc]initWithString:cell.lblContact.text];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,6)];
        [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,7)];
        
        [cell.lblName setAttributedText:string];
        [cell.lblContact setAttributedText:string2];
    }
    NSMutableAttributedString * string3 = [[NSMutableAttributedString alloc]initWithString:cell.lblNanoID.text];
    NSMutableAttributedString * string4 = [[NSMutableAttributedString alloc]initWithString:cell.lblIrridiumID.text];
    [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,9)];
    [string4 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,13)];
    [cell.lblNanoID setAttributedText:string3];
    [cell.lblIrridiumID setAttributedText:string4];
    
    cell.lblNanoID.hidden = true;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    globalDeviceStatusVC =  [[DeviceStatusVC alloc]init];
    globalDeviceStatusVC.previousDict = [arrContacts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:globalDeviceStatusVC animated:true];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
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
