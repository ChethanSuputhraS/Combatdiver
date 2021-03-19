//
//  HeatMsgVC.m
//  SC4App18
//
//  Created by stuart watts on 14/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "HeatMsgVC.h"
#import "LeftMenuCell.h"

@interface HeatMsgVC ()<FCAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int headerhHeight,viewWidth;
    UITableView * tblView, * tblMessages;
    NSMutableArray * arrMessages, * arrHeatmsg;
    NSInteger selectedIndex;
    NSString * strSelectedHeatMsg;
    
}
@end

@implementation HeatMsgVC

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.userInteractionEnabled = YES;
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
    [lblTitle setText:@"Heat Messages"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];

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
    lblHint.text = NSLocalizedString(@"Tap on any diver message to assign as Heat messages. ",@"");
    [self.view addSubview:lblHint];
    
    if (IS_IPHONE)
    {
        lblHint.frame=CGRectMake(0, headerhHeight, DEVICE_WIDTH, 50);
        [lblHint setFont:[UIFont fontWithName:CGRegular size:textSize-1]];
        lblHint.numberOfLines = 0;

    }
    if (IS_IPHONE_X)
    {
        viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
        lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
        backImg.frame = CGRectMake(10, 12+44, 12, 20);
        btnBack.frame = CGRectMake(0, 0, 70, 88);
    }
    [self setupMainContentView:headerhHeight+10];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setupMainContentView:(int)headerHeights
{
    arrMessages = [[NSMutableArray alloc]init];
    NSString * strCanned = [NSString stringWithFormat:@"SELECT * FROM DiverMessage"];
    [[DataBaseManager dataBaseManager] execute:strCanned resultsArray:arrMessages];

    arrHeatmsg = [[NSMutableArray alloc] init];
    NSMutableArray *  heatArr = [[NSMutableArray alloc] init];
    NSString * strHeat = [NSString stringWithFormat:@"Select * from HeatMessage"];
    [[DataBaseManager dataBaseManager] execute:strHeat resultsArray:heatArr];
    if ([heatArr count]==0)
    {
        NSArray * tmpArr = [NSArray arrayWithObjects:@"Stop",@"Go",@"Report",@"Complete", nil];
        for (int i = 0; i<[tmpArr count]; i++)
        {
            NSString * strId = [NSString stringWithFormat:@"%d",i+1];
            NSString * strIndex = [NSString stringWithFormat:@"Heat %d",i+1];
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'HeatMessage' ('Msgid','Message','indexStr') values ('%@','%@','%@')",strId,[tmpArr objectAtIndex:i],strIndex];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        }
        
        NSString * strHeat = [NSString stringWithFormat:@"Select * from HeatMessage"];
        [[DataBaseManager dataBaseManager] execute:strHeat resultsArray:heatArr];
        arrHeatmsg = [heatArr mutableCopy];

    }
    else
    {
        arrHeatmsg = [heatArr mutableCopy];
    }
    
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, headerHeights, viewWidth-60, DEVICE_HEIGHT-headerHeights);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    backView.userInteractionEnabled = YES;
    
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
        backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights);
        tblView.frame= CGRectMake(0, 0, viewWidth-20, DEVICE_HEIGHT-headerHeights);
        if (IS_IPHONE_X)
        {
            backView.frame = CGRectMake(10, headerHeights, viewWidth-20, DEVICE_HEIGHT-headerHeights-40);
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
    if (tableView==tblMessages)
    {
        return [arrMessages count];
    }
    return  [arrHeatmsg count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int vHeight = 50;
    if (IS_IPHONE_4||IS_IPHONE_5)
    {
        vHeight  = 40;
    }
    if (tableView==tblMessages)
    {
        NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[LeftMenuCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSString * str = [NSString stringWithFormat:@"  %@. %@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"indexStr"],[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"Message"]];
        cell.lblName.text= str;
        cell.lblName.textColor=[UIColor whiteColor];
        cell.lblLine.hidden = YES;
        cell.lblName.frame= CGRectMake(0, 0, DEVICE_WIDTH, vHeight);
        
            cell.lblLine.font = [UIFont fontWithName:CGRegular size:textSize];
        return cell;
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
    cell.lblName.frame = CGRectMake(70, 0, viewWidth-40, 55);
    
    cell.imgIcon.frame = CGRectMake(15, 18, 33, 24);
    cell.imgIcon.image = [UIImage imageNamed:@"heat.png"];
    
    cell.lblName.text= [NSString stringWithFormat:@"%@. %@",[[arrHeatmsg objectAtIndex:indexPath.row] valueForKey:@"id"], [[arrHeatmsg objectAtIndex:indexPath.row] valueForKey:@"indexStr"]];;
    
    cell.lblBack.frame = CGRectMake(0, 0, viewWidth, 55);
    cell.imgIcon.frame = CGRectMake(15, 17, 26, 26);
    
    cell.lblBack.hidden = NO;
    cell.imgIcon.hidden = NO;
    cell.lblLine.hidden = NO;
    cell.imgArrow.hidden = YES;
    
    cell.lblLine.frame = CGRectMake(tableView.frame.size.width-160, 0, 160, 55);
    cell.lblLine.font = [UIFont fontWithName:CGRegular size:textSize];
    cell.lblLine.textColor = [UIColor lightGrayColor];
    cell.lblLine.backgroundColor = [UIColor clearColor];
    cell.lblLine.text = [[arrHeatmsg objectAtIndex:indexPath.row] valueForKey:@"Message"];
    
    if (IS_IPHONE)
    {
        cell.lblName.frame = CGRectMake(43, 0, viewWidth-40, 55);
        cell.imgIcon.frame = CGRectMake(10, 17, 26, 26);
        
        cell.lblLine.frame = CGRectMake(tableView.frame.size.width-120, 0, 100, 55);

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == tblMessages)
    {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
    }
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblMessages)
    {
        NSString * strMsgs = [NSString stringWithFormat:@"%@",[[arrMessages objectAtIndex:indexPath.row] valueForKey:@"Message"]];
        [[arrHeatmsg objectAtIndex:selectedIndex] setObject:strMsgs forKey:@"Message"];
        [tblView reloadData];
        
        [self hideMorePopUpView:YES];

        NSString * strUpdate = [NSString stringWithFormat:@"Update HeatMessage set Message='%@' where indexStr='%@'",strMsgs,strSelectedHeatMsg];
        [[DataBaseManager dataBaseManager] execute:strUpdate];
    }
    else
    {
        strSelectedHeatMsg = [[arrHeatmsg objectAtIndex:indexPath.row] valueForKey:@"indexStr"];
        selectedIndex = indexPath.row;
        [self showMessageList];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblMessages)
    {
        if (IS_IPHONE_4||IS_IPHONE_5)
        {
            return 40;
        }
        return 60;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IS_IPAD)
    {
        return 40.0;
    }
    else
    {
        return 40.0;
    }
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==tblMessages)
    {
        return @"Select any diver message to assign as Heat 1";
    }
    return @"";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    if (IS_IPAD)
    {
        frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    }
    else
    {
        frame = CGRectMake(0, 0, tableView.frame.size.width,40);
    }
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:CGRegular size:textSize+5];
    [label sizeToFit];
    label.center = view.center;
    label.font = [UIFont fontWithName:CGRegular size:textSize];
    label.backgroundColor = [UIColor colorWithRed:207/255.0 green:220/255.0 blue:252.0/255.0 alpha:1];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    
    if (tableView == tblMessages)
    {
        NSString * strTitle = [NSString stringWithFormat:@"Select message to assign as %@",strSelectedHeatMsg];
        label.text = strTitle;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor blackColor];
        
        label.frame = CGRectMake(20, 0, tableView.frame.size.width, 40);
        view.backgroundColor = [UIColor blackColor];
        
        UIFontDescriptor *fontDescriptor1 = [UIFontDescriptor fontDescriptorWithName:CGBold size:textSize];
        UIFontDescriptor *symbolicFontDescriptor1 = [fontDescriptor1 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        
        NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"* %@",strTitle]];
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
        if (IS_IPHONE_5 || IS_IPHONE_4)
        {
            label.frame = CGRectMake(3, 0, tableView.frame.size.width-6, 40);
            label.numberOfLines = 0;
        }
    }
    
    return view;
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
//        [self ValidationforAddedMessage:strSelectedHeatMsg];
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
-(void)btnCloseClick
{
    [self hideMorePopUpView:YES];
}
-(void)OverLayTaped:(id)sender
{
    NSLog(@"Tapped");
    [self hideMorePopUpView:YES];
}
-(void)msgSelectionClick
{
    [self showMessageList];
}

#pragma mark - View for Choosing Contacts
-(void)showMessageList
{
    [viewOverLay removeFromSuperview];
    viewOverLay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT)];
    [viewOverLay setBackgroundColor:[UIColor colorWithRed:97/255.0f green:97/255.0f blue:97/255.0f alpha:0.5]];
    viewOverLay.userInteractionEnabled = YES;
    [self.view addSubview:viewOverLay];
    
    backContactView = [[UIImageView alloc] init];
    backContactView.frame = CGRectMake(80, DEVICE_HEIGHT, viewWidth-160, 660);
    backContactView.image = [UIImage imageNamed:@"pop_up_bg.png"];
    backContactView.userInteractionEnabled = YES;
    [self.view addSubview:backContactView];
    
    UILabel * lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(0, 30, backContactView.frame.size.width, 50);
    lblTitle.font = [UIFont fontWithName:CGRegular size:textSize];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text = @"Select Message";
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
    
    tblMessages=[[UITableView alloc]init];
    tblMessages.delegate=self;
    tblMessages.dataSource=self;
    tblMessages.frame = CGRectMake(27, 80, backContactView.frame.size.width-54, backContactView.frame.size.height-60-60);
    tblMessages.backgroundColor=[UIColor clearColor];
    [tblMessages setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblMessages setSeparatorColor:[UIColor clearColor]];
    [backContactView addSubview:tblMessages];
    
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
        tblMessages.frame = CGRectMake(0, 50, backContactView.frame.size.width-0, DEVICE_HEIGHT-80-50);
        if (IS_IPHONE_5 || IS_IPHONE_4)
        {
            backContactView.frame = CGRectMake(10, DEVICE_HEIGHT, viewWidth-20, DEVICE_HEIGHT-80);
            tblMessages.frame = CGRectMake(0, 50, backContactView.frame.size.width-0, DEVICE_HEIGHT-80-50);
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
                             }                         }
                         completion:^(BOOL finished){
                             [viewOverLay removeFromSuperview];
                             [backContactView removeFromSuperview];
                             [tblMessages removeFromSuperview];
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
                                 backContactView.frame = CGRectMake(80, 54, viewWidth-160, 660);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
