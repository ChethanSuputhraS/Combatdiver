//
//  ComposeMsgVC.m
//  SC4App18
//
//  Created by stuart watts on 28/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "ComposeMsgVC.h"
#import "ScanviewCell.h"
#import "LeftMenuCell.h"

@interface ComposeMsgVC ()<UITableViewDelegate,UITableViewDataSource,FCAlertViewDelegate>
{
    BOOL isforAll;

}
@end

@implementation ComposeMsgVC

#pragma mark - View Cycle

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
    [lblTitle setText:@"Compose Message"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UILabel * lblHint = [[UILabel alloc] initWithFrame:CGRectMake(20, headerhHeight, viewWidth, 44)];
    [lblHint setBackgroundColor:[UIColor clearColor]];
    [lblHint setText:@"Select Message to send."];
    [lblHint setFont:[UIFont fontWithName:CGRegular size:textSize]];
    [lblHint setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lblHint];
    
    UIFontDescriptor *fontDescriptor1 = [UIFontDescriptor fontDescriptorWithName:CGBold size:textSize];
    UIFontDescriptor *symbolicFontDescriptor1 = [fontDescriptor1 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:@"* Select diver message to send"];
    UIFont *fontWithDescriptor = [UIFont fontWithDescriptor:fontDescriptor1 size:textSize+3];
    UIFont *fontWithDescriptor1 = [UIFont fontWithDescriptor:symbolicFontDescriptor1 size:textSize];
    UIFont *fontWithDescriptor2 = [UIFont fontWithDescriptor:symbolicFontDescriptor1 size:textSize];
    
    [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor1, NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, hintText.length)];
    [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor, NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
    [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor2, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(8, 15)];
    
    [lblHint setAttributedText:hintText];
    lblHint.textAlignment = NSTextAlignmentLeft;
    lblHint.font = [UIFont fontWithName:CGRegular size:textSize];
    
    [self setupMainContentView:headerhHeight+44];
    
    [self getDatafromDatabase];
    
    if (IS_IPHONE)
    {
        UIImageView * imgMenu = [[UIImageView alloc] init];
        imgMenu.frame = CGRectMake(10, 20+13.5, 24, 17);
        imgMenu.image = [UIImage imageNamed:@"menu_icon.png"];
        [viewHeader addSubview:imgMenu];
        
        UIButton * btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerhHeight, headerhHeight)];
        [btnMenu setBackgroundColor:[UIColor clearColor]];
        [btnMenu addTarget:self action:@selector(btnLeftMenuClicked) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnMenu];
        
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
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)setupMainContentView:(int)headerHeights
{
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, headerHeights, viewWidth-60, DEVICE_HEIGHT-headerHeights-10);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth-60, DEVICE_HEIGHT-headerHeights-10)];
    tblView.rowHeight=80;
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    [backView addSubview:tblView];
    
    if (IS_IPHONE)
    {
        backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights-10);
        tblView.frame = CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-10);
        if (IS_IPHONE_X)
        {
            tblView.frame = CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights-10-40);
        }
    }
//
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds];
//    backView.layer.masksToBounds = NO;
//    backView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    backView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    backView.layer.shadowOpacity = 0.5f;
//    backView.layer.shadowPath = shadowPath.CGPath;
}
#pragma mark - Button Click Methods
-(void)btnLeftMenuClicked
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}
-(void)btnCloseClick
{
    [self hideMorePopUpView:YES];
}
-(void)btnCancelClick
{
    
}
-(void)btnDoneClick
{
    
}
-(void)btnSendtoAll
{
    isforAll = YES;
    [self MessageSend];
}

#pragma mark - Database methods
-(void)getDatafromDatabase
{
    cannedMsgArr = [[NSMutableArray alloc] init];
    
    NSString * strQuery = [NSString stringWithFormat:@"select * from DiverMessage"];
    [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:cannedMsgArr];
    if ([cannedMsgArr count]==0)
    {
        NSArray * fixArrArray = [[NSArray alloc] initWithObjects:@"Stop",@"Go",@"Report",@"Complete",@"Low Air",@"Training Complete",@"Canned 7",@"Canned 8",@"Canned 9",@"Canned 10",@"Canned 11",@"Canned 12",@"Canned 13",@"Canned 14",@"Canned 15",@"Canned 16",@"Canned 17",@"Canned 18",@"Canned 19",@"Canned 20", nil];
        for (int i = 0; i<[fixArrArray count]; i++)
        {
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'DiverMessage' ('Message','is_emergency','indexStr') values ('%@','No','%d')",[fixArrArray objectAtIndex:i],i+1];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        }
        NSString * strQuery = [NSString stringWithFormat:@"select * from DiverMessage"];
        [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:cannedMsgArr];
    }

    contactArr = [[NSMutableArray alloc] init];
    NSString * strcontQr = [NSString stringWithFormat:@"select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strcontQr resultsArray:contactArr];
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
    if (tableView ==tblContact)
    {
        return  [contactArr count];
    }
    else
    {
        return  [cannedMsgArr count];
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
        cell.imgArrow.frame = CGRectMake(tableView.frame.size.width-30, (height-20)/2, 20, 20);

        NSString * strName = [NSString stringWithFormat:@"%@.  %@",[[contactArr objectAtIndex:indexPath.row] valueForKey:@"nano"],[[contactArr objectAtIndex:indexPath.row] valueForKey:@"name"]];
        cell.lblName.text= strName;
        cell.lblName.textColor=[UIColor whiteColor];
        
        cell.lblContact.hidden = false;
        cell.lblContact.frame = CGRectMake(viewWidth-375, 0, 300, height);
        cell.lblContact.text =[[contactArr objectAtIndex:indexPath.row] valueForKey:@"phone"];
        if (IS_IPHONE)
        {
            cell.lblContact.frame = CGRectMake(DEVICE_WIDTH-200, 0, 155, height);
            cell.lblContact.textAlignment = NSTextAlignmentRight;
            if (IS_IPHONE_5) {
                cell.lblContact.frame = CGRectMake(DEVICE_WIDTH-200, 0, 175, height);

            }
        }
        
        cell.lblBack.hidden = YES;
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

        NSString * strName = [NSString stringWithFormat:@"%@",[[cannedMsgArr objectAtIndex:indexPath.row]valueForKey:@"Message"]];
        cell.lblName.text= strName;
        cell.lblName.textColor=[UIColor whiteColor];
        cell.lblName.font = [UIFont fontWithName:CGRegular size:textSize+1];
        cell.lblName.frame = CGRectMake(70, 0, viewWidth-40, height);
        cell.lblBack.frame = CGRectMake(0, 0, viewWidth, height);

        cell.imgIcon.frame = CGRectMake(15, (height-24)/2, 33, 24);
        cell.imgIcon.image = [UIImage imageNamed:@"diver_Msg.png"];
        
        cell.imgArrow.frame = CGRectMake(tableView.frame.size.width-50, (height-26)/2, 30, 26);
        cell.imgArrow.image = [UIImage imageNamed:@"send.png"];

        cell.lblBack.hidden = NO;
        cell.imgIcon.hidden = NO;
        cell.lblLine.hidden = YES;

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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblView)
    {
        sentMsg = [NSString stringWithFormat:@"%@",[[cannedMsgArr objectAtIndex:indexPath.row] valueForKey:@"Message"]];
        sentIndex = [NSString stringWithFormat:@"%@",[[cannedMsgArr objectAtIndex:indexPath.row] valueForKey:@"indexStr"]];
        
        [self setupConctactTable];
    }
    else
    {
        [self hideMorePopUpView:YES];

        isforAll = NO;
        
        sentUserName = [NSString stringWithFormat:@"%@",[[contactArr objectAtIndex:indexPath.row] valueForKey:@"name"]];
        sentUserNano = [NSString stringWithFormat:@"%@",[[contactArr objectAtIndex:indexPath.row] valueForKey:@"SC4_nano_id"]];
        [self MessageSend];
    }
}
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
            return 55;
        }
    }
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView ==tblView)
    {
        return 1;
    }
    if (IS_IPAD)
    {
        return 50.0;
    }
    else
    {
        return 40;
    }
    return 40.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     if (tableView ==tblView)
     {
         return [UIView new];
     }
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
    label.frame = frame;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:CGRegular size:textSize+2];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    if (tableView == tblContact)
    {
        label.frame = CGRectMake(20, 0, tableView.frame.size.width, frame.size.height);
        view.backgroundColor = [UIColor blackColor];

        UIFontDescriptor *fontDescriptor1 = [UIFontDescriptor fontDescriptorWithName:CGBold size:textSize];
        UIFontDescriptor *symbolicFontDescriptor1 = [fontDescriptor1 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];

        NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:@"* Select contact to send message"];
        if (IS_IPHONE)
        {
            hintText = [[NSMutableAttributedString alloc] initWithString:@"* Select contact"];
        }
        UIFont *fontWithDescriptor = [UIFont fontWithDescriptor:fontDescriptor1 size:textSize+3];
        UIFont *fontWithDescriptor1 = [UIFont fontWithDescriptor:symbolicFontDescriptor1 size:textSize];
        UIFont *fontWithDescriptor2 = [UIFont fontWithDescriptor:symbolicFontDescriptor1 size:textSize];

        [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor1, NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, hintText.length)];
        [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor, NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
        if (IS_IPAD)
        {
            [hintText setAttributes:@{NSFontAttributeName:fontWithDescriptor2, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(8, 9)];
        }

        [label setAttributedText:hintText];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:CGRegular size:textSize];
        
        UIButton * btnSendAll = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSendAll.frame = CGRectMake(tableView.frame.size.width-130, 0, 130, frame.size.height);
        [btnSendAll addTarget:self action:@selector(btnSendtoAll) forControlEvents:UIControlEventTouchUpInside];
        [btnSendAll setTitle:@"Send to All" forState:UIControlStateNormal];
        [btnSendAll setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnSendAll.backgroundColor = [UIColor clearColor];
        [view addSubview:btnSendAll];
        if (IS_IPHONE)
        {
            label.frame = CGRectMake(5, 0, tableView.frame.size.width, frame.size.height);
            label.font = [UIFont fontWithName:CGRegular size:textSize-2];
            btnSendAll.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-2];
            btnSendAll.frame = CGRectMake(view.frame.size.width-100, 0, 100, frame.size.height);
//            btnSendAll.backgroundColor= [UIColor greenColor];
        }
    }
    return view;
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
        backContactView.frame = CGRectMake(20, DEVICE_HEIGHT, viewWidth-40, DEVICE_HEIGHT-80);
        lblTitle.frame = CGRectMake(0, 0, backContactView.frame.size.width, 50);
        lblline.frame = CGRectMake(10, 49, backContactView.frame.size.width-20, 0.5);
        btnCancel.frame = CGRectMake(0, 0, 60, 50);
        btnDone.frame = CGRectMake(backContactView.frame.size.width-60, 0, 60, 50);
        tblContact.frame = CGRectMake(0, 50, backContactView.frame.size.width-0, 400-50);
        if (IS_IPHONE_5 || IS_IPHONE_4)
        {
            backContactView.frame = CGRectMake(10, DEVICE_HEIGHT, viewWidth-20, DEVICE_HEIGHT-80);
            tblContact.frame = CGRectMake(0, 50, backContactView.frame.size.width-0, DEVICE_HEIGHT-80-50);
        }
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
                                 if (IS_IPHONE_5 || IS_IPHONE_4)
                                 {
                                     backContactView.frame = CGRectMake(10, DEVICE_HEIGHT, viewWidth-20, DEVICE_WIDTH-80);
                                 }
                                 else
                                 {
                                     backContactView.frame = CGRectMake(20, DEVICE_HEIGHT, viewWidth-40, DEVICE_WIDTH-80);
                                 }
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
                                 if (IS_IPHONE_5 || IS_IPHONE_4)
                                 {
                                     backContactView.frame = CGRectMake(10, 40, viewWidth-20, DEVICE_HEIGHT-80);
                                 }
                                 else
                                 {
                                     backContactView.frame = CGRectMake(20, 40, viewWidth-40, DEVICE_HEIGHT-80);
                                 }
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
        ScanVC * scanVc = [[ScanVC alloc] init];
        [self.navigationController pushViewController:scanVc animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE Methods
-(void)MessageSend
{
    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        NSInteger cmdInt = [@"05" integerValue]; //Command
        NSData * cmdData = [[NSData alloc] initWithBytes:&cmdInt length:1];
        
        NSInteger lengthInt = [@"06" integerValue]; //length of Message
        NSData * lengthData = [[NSData alloc] initWithBytes:&lengthInt length:1];

        NSInteger nanoInt = [sentUserNano integerValue]; //Nano Modem ID
        NSData * nanoData = [[NSData alloc] initWithBytes:&nanoInt length:4];
        
        NSInteger sequenceInt = [[self GetUniqueNanoModemId] integerValue];
        if (isforAll)
        {
            long long nanoInt = 4294967295; //Nano Modem ID
            nanoData = [[NSData alloc] initWithBytes:&nanoInt length:4];
            sequenceInt = 0;
        }

        NSInteger opcodeInt = [@"01" integerValue]; //Opcode
        NSData * opcodeData = [[NSData alloc] initWithBytes:&opcodeInt length:1];

        NSInteger dataInt=  [sentIndex integerValue]; // Message data
        NSData * dataData = [[NSData alloc] initWithBytes:&dataInt length:1];
        
        NSData * sequenceData = [[NSData alloc] initWithBytes:&sequenceInt length:4];

        NSMutableData *completeData = [cmdData mutableCopy];
        [completeData appendData:lengthData];
        [completeData appendData:nanoData];
        [completeData appendData:opcodeData];
        [completeData appendData:dataData];
        [completeData appendData:sequenceData];

        NSData * sequencData = [[NSData alloc] initWithBytes:&sequenceInt length:4];
        NSString * strSqnc = [NSString stringWithFormat:@"%@",sequencData];
        strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@" " withString:@""];
        strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@"<" withString:@""];
        strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@">" withString:@""];

        [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
        {
            double dateStamp = [[NSDate date] timeIntervalSince1970];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString * timeStr =[dateFormatter stringFromDate:[NSDate date]];
            if (isforAll)
            {
                for (int i=0; i<[contactArr count]; i++)
                {
                    NSString * strName = [[contactArr objectAtIndex:i] valueForKey:@"name"];
                    NSString * strNano = [[contactArr objectAtIndex:i] valueForKey:@"SC4_nano_id"];
                    
                    NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewChat' ('from_name','from_nano','to_name','to_nano','msg_id','msg_txt','time','status','timeStamp','sequence') values ('%@','%@','%@','%@','%@','%@','%@','%@','%f','%@')",@"Me",@"Me",strName,strNano,sentIndex,sentMsg,timeStr,@"Broadcast",dateStamp,strSqnc];
                    [[DataBaseManager dataBaseManager] execute:strInsertCan];
                    
                    NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set msg ='%@', time='%@' where SC4_nano_id='%@'",sentMsg,timeStr,strNano];
                    [[DataBaseManager dataBaseManager] execute:strUpdate];
                }
            }
            else
            {
                NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewChat' ('from_name','from_nano','to_name','to_nano','msg_id','msg_txt','time','status','timeStamp','sequence') values ('%@','%@','%@','%@','%@','%@','%@','%@','%f','%@')",@"Me",@"Me",sentUserName,sentUserNano,sentIndex,sentMsg,timeStr,@"Broadcast",dateStamp,strSqnc];
                [[DataBaseManager dataBaseManager] execute:strInsertCan];
                
                NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set msg ='%@', time='%@' where SC4_nano_id='%@'",sentMsg,timeStr,sentUserNano];
                [[DataBaseManager dataBaseManager] execute:strUpdate];
            }
        }
        if (isforAll)
        {
            [self hideMorePopUpView:YES];
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
    
        
        [APP_DELEGATE endHudProcess];
    }
    else
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
//        alert.delegate = self;
//        alert.tag = 222;
        [alert showAlertInView:self
                     withTitle:@"Combat Diver"
                  withSubtitle:@"Device is disconnected. Please connect and try again."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];

    }
}
-(NSString *)GetUniqueNanoModemId
{
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    NSString * strTime = [NSString stringWithFormat:@"%f",timeInSeconds];
    strTime = [strTime stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * strData ;
    if ([strTime length]>=16)
    {
        strTime = [strTime substringWithRange:NSMakeRange([strTime length]-8, 8)];
        int intVal = [strTime intValue];
        NSData * lineLightNanoData = [[NSData alloc] initWithBytes:&intVal length:4];
        strData = [NSString stringWithFormat:@"%@",lineLightNanoData];
        strData = [strTime stringByReplacingOccurrencesOfString:@" " withString:@""];
        strData = [strTime stringByReplacingOccurrencesOfString:@"<" withString:@""];
        strData = [strTime stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        NSLog(@"got starData=%@",strData);
        
        if([[strData substringWithRange:NSMakeRange(0,2)] isEqualToString:@"00"])
        {
            strTime = [NSString stringWithFormat:@"88%@",[strTime substringWithRange:NSMakeRange(2,6)]];
        }
        else if([[strData substringWithRange:NSMakeRange(6,2)] isEqualToString:@"00"])
        {
            strTime = [NSString stringWithFormat:@"%@99",[strTime substringWithRange:NSMakeRange(0,6)]];
        }
    }
    return strTime;
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
