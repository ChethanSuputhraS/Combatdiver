//
//  AddressBookVC.m
//  SC4App18
//
//  Created by stuart watts on 08/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "AddressBookVC.h"
#import "LeftMenuCell.h"

@interface AddressBookVC ()<FCAlertViewDelegate>
{
    NSTimer *  msgTimer;
    NSInteger selectedIndex,kpCount;
    BOOL isEdited;
    NSString * strUpdatedMsg,*strNanoID,*strGSMIrridium;
}

@end

@implementation AddressBookVC

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
    [lblTitle setText:@"Address Book"];
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
    lblHint.text = NSLocalizedString(@"Sync Contacts to device by tapping on SYNC button.",@"");
    [self.view addSubview:lblHint];
    
    UILabel * lblSubHint = [[UILabel alloc] initWithFrame:CGRectZero];
    lblSubHint.backgroundColor = [UIColor clearColor];
    lblSubHint.frame=CGRectMake(0, 64+32, 707, 25);
    lblSubHint.font = [UIFont systemFontOfSize:14];
    lblSubHint.textAlignment = NSTextAlignmentCenter;
    [lblSubHint setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
    lblSubHint.textColor = [UIColor whiteColor]; // change this color
    lblSubHint.text = NSLocalizedString(@"(Tap on any contact to Edit)",@"");
    [self.view addSubview:lblSubHint];
    
    if (IS_IPHONE)
    {
        imgAdd.frame = CGRectMake(viewWidth-40, 20+9, 26, 25);
        lblHint.frame=CGRectMake(0, headerhHeight, viewWidth, 50);
        lblSubHint.frame=CGRectMake(0, headerhHeight+32, viewWidth, 25);
        [lblHint setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [lblSubHint setFont:[UIFont fontWithName:CGRegular size:textSize-3]];
        lblHint.text = NSLocalizedString(@"Sync Contacts to device",@"");
        
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

    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(15, headerHeights, viewWidth-30, DEVICE_HEIGHT-headerHeights);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,  backView.frame.size.width, backView.frame.size.height)];
    tblView.rowHeight=80;
    tblView.delegate=self;
    tblView.dataSource=self;
    tblView.backgroundColor=[UIColor clearColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblView setSeparatorColor:[UIColor clearColor]];
    tblView.showsVerticalScrollIndicator = false;
    tblView.showsHorizontalScrollIndicator = false;
    [backView addSubview:tblView];
    
//    [btnSync removeFromSuperview];
//    btnSync =[UIButton buttonWithType:UIButtonTypeCustom];
//    btnSync.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    [btnSync addTarget:self action:@selector(syncBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    btnSync.frame=CGRectMake(0, DEVICE_HEIGHT-60, 707, 60);
//    [btnSync setTitle:@"Update Address Book" forState:UIControlStateNormal];
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
    cell.lblName.frame = CGRectMake(55, 0, viewWidth-40, vHeight/2);
    cell.lblName.text= [NSString stringWithFormat:@"Name : %@",[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"name"]];
    
    cell.lblNanoID.hidden = false;
    cell.lblNanoID.frame = CGRectMake(70, vHeight/2, viewWidth/2-70-30, vHeight/2);
//    cell.lblNanoID.text = [NSString stringWithFormat:@"Nano ID : %@",[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"nano"]];
    
    cell.lblContact.hidden = false;
    cell.lblContact.frame = CGRectMake(viewWidth-370, 0, 300, vHeight/2);
//    cell.lblContact.text =[NSString stringWithFormat:@"Ph No : %@",[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"phone"]];
    cell.lblContact.text = @"Ph No : **********";
    
    cell.lblIrridiumID.hidden = false;
    cell.lblIrridiumID.frame = CGRectMake(55, vHeight/2, viewWidth/2-70, vHeight/2);
    cell.lblIrridiumID.text = [NSString stringWithFormat:@"Irridium ID : %@",[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"irridium_id"]];
    
    
    cell.lblBack.frame = CGRectMake(0, 0, viewWidth, vHeight);
    cell.lblBack.hidden = NO;
    
    cell.imgIcon.frame = CGRectMake(10, (vHeight-24)/2, 33, 24);
    cell.imgIcon.image = [UIImage imageNamed:@"diver_default.png"];
    cell.imgIcon.hidden = NO;
    cell.lblLine.hidden = YES;
    
    cell.imgArrow.hidden = NO;
    cell.imgArrow.image = [UIImage imageNamed:@"UnSelected.png"];
    cell.imgArrow.frame = CGRectMake(viewWidth-45-30, 3, 40, 40);
    
    cell.lblRight.hidden = false;
    cell.lblRight.frame = CGRectMake(viewWidth-45-30, 40, 50, 20);
    cell.lblRight.text = @"";

    cell.lblGSMIrridiumID.hidden = false;
    cell.lblGSMIrridiumID.frame = CGRectMake(viewWidth-370, vHeight/2, 300, vHeight/2);
    cell.lblGSMIrridiumID.text =  [NSString stringWithFormat:@"GSM ID : %@",[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"gsm_irridium_id"]];
    if ([[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"isBoat"] isEqualToString:@"1"])
    {
        cell.imgArrow.image = [UIImage imageNamed:@"Selected.png"];
        cell.lblRight.text = @"Boat";
    }

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
    NSMutableAttributedString * string5 = [[NSMutableAttributedString alloc]initWithString:cell.lblGSMIrridiumID.text];

    [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,9)];
    [string4 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,13)];
    [string5 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,8)];

    [cell.lblNanoID setAttributedText:string3];
    [cell.lblIrridiumID setAttributedText:string4];
    [cell.lblGSMIrridiumID setAttributedText:string5];

    NSLog(@"arr info is %@",arrContacts);
    cell.lblNanoID.hidden = true;
    
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
}
#pragma mark - UITableViewDelegate
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        isEdited = YES;
                                        selectedIndex = indexPath.row;
                                        FCAlertView *alert = [[FCAlertView alloc] init];
                                        alert.delegate = self;
                                        alert.tag = 456;
                                        alert.colorScheme = [UIColor colorWithRed:44.0/255.0f green:62.0/255.0f blue:80.0/255.0f alpha:1.0];
                                        
                                        //    UITextField *customField1 = [[UITextField alloc] init];
                                        //    customField1.delegate = self;
                                        //    customField1.autocorrectionType = UITextAutocorrectionTypeNo;
                                        //    [self ChecktextwithValue:[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"nano"] withPlaceholderText:@"Enter Nano Modem ID" forText:customField1 ];
                                        //    customField1.tag = 0;
                                        //    customField1.keyboardType = UIKeyboardTypeDefault;
                                        //    [alert addTextFieldWithCustomTextField:customField1 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
                                        //        NSLog(@"Custom TextField NANO ID Returns: %@", text); // Do what you'd like with the text returned from the field
                                        //
                                        //        strNanoID = text;
                                        //    }];
                                        
                                        UITextField *customField2 = [[UITextField alloc] init];
                                        customField2.delegate = self;
                                        customField2.keyboardType = UIKeyboardTypePhonePad;
                                        customField2.autocorrectionType = UITextAutocorrectionTypeNo;
                                        customField2.tag = 0;
                                        [self ChecktextwithValue:[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"irridium_id"] withPlaceholderText:@"Enter Irridium ID" forText:customField2 ];
                                        [alert addTextFieldWithCustomTextField:customField2 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
                                            NSLog(@"Custom TextField Irridium ID Returns: %@", text); // Do what you'd like with the text returned from the field
                                            
                                            strIrridiumID = text;
                                        }];
                                        
                                      
                                        UITextField *customField5 = [[UITextField alloc] init];
                                        customField5.placeholder = @"Enter GSM Irridium ID";
                                        customField5.delegate = self;
                                        customField5.keyboardType = UIKeyboardTypePhonePad;
                                        customField5.autocorrectionType = UITextAutocorrectionTypeNo;
                                        customField5.tag = 1;
                                        [self ChecktextwithValue:[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"gsm_irridium_id"] withPlaceholderText:@"Enter GSM Irridium ID" forText:customField5 ];
                                        customField5.returnKeyType = UIReturnKeyNext;
                                        [alert addTextFieldWithCustomTextField:customField5 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
                                            NSLog(@"Custom TextField GSM ID Returns: %@", text); // Do what you'd like with the text returned from the field
                                            
                                            strGSMIrridium = text;
                                        }];
                                        
                                        UITextField *customField3 = [[UITextField alloc] init];
                                        customField3.delegate = self;
                                        customField3.tag = 2;
                                        customField3.autocorrectionType = UITextAutocorrectionTypeNo;
                                        [self ChecktextwithValue:[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"name"] withPlaceholderText:@"Enter name" forText:customField3 ];
                                        customField3.autocorrectionType = UITextAutocorrectionTypeNo;
                                        [alert addTextFieldWithCustomTextField:customField3 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
                                            NSLog(@"Custom TextField Returns: %@", text); // Do what you'd like with the text returned from the field
                                            
                                            strUpdatedMsg = text;
                                        }];
                                        
                                        
                                        
                                        UITextField *customField4 = [[UITextField alloc] init];
                                        customField4.delegate = self;
                                        customField4.autocorrectionType = UITextAutocorrectionTypeNo;
                                        customField4.tag = 3;
                                        customField4.keyboardType = UIKeyboardTypePhonePad;
                                        customField4.text = @"**********";  ////srivatsa november coz shubra told for this demo,disable phone number option,user should not be able to access phone number textfield
                                        customField4.userInteractionEnabled = false;
                                        [self ChecktextwithValue:[[arrContacts objectAtIndex:indexPath.row] valueForKey:@"phone"] withPlaceholderText:@"Enter Phone No" forText:customField4 ];
                                        [alert addTextFieldWithCustomTextField:customField4 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
                                            NSLog(@"Custom TextField PHONE NO Returns: %@", text); // Do what you'd like with the text returned from the field
                                            strPhoneNo = text;
                                        }];
                                        
                                        
                                        [alert addButton:@"Cancel" withActionBlock:^{
                                            NSLog(@"Custom Font Button Pressed");
                                            // Put your action here
                                        }];
                                        [alert showAlertInView:self
                                                     withTitle:@"Elite Operator"
                                                  withSubtitle:@"Update Contact"
                                               withCustomImage:nil
                                           withDoneButtonTitle:nil
                                                    andButtons:nil];
                                    }];
    
    
    return @[button]; //array with all the buttons you want. 1,2,3, etc...
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrContacts.count > 0)
    {
        [arrContacts setValue:@"0" forKey:@"isBoat"];
        [[arrContacts objectAtIndex:indexPath.row]setValue:@"1" forKey:@"isBoat"];
        [tblView reloadData];
    }
}

-(void)btnAddClick
{
    isEdited = NO;
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    alert.tag = 456;
    alert.colorScheme = [UIColor colorWithRed:44.0/255.0f green:62.0/255.0f blue:80.0/255.0f alpha:1.0];
    
//    UITextField *customField1 = [[UITextField alloc] init];
//    customField1.placeholder = @"Enter Nano Modem ID";
//    customField1.delegate = self;
//    customField1.keyboardType = UIKeyboardTypeDefault;
//    customField1.autocorrectionType = UITextAutocorrectionTypeNo;
//    customField1.tag = 0;
//    [alert addTextFieldWithCustomTextField:customField1 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
//        NSLog(@"Custom TextField NANO ID Returns: %@", text); // Do what you'd like with the text returned from the field
//
//        strNanoID = text;
//    }];
    
    UITextField *customField2 = [[UITextField alloc] init];
    customField2.placeholder = @"Enter Irridium ID";
    customField2.delegate = self;
    customField2.keyboardType = UIKeyboardTypePhonePad;
    customField2.autocorrectionType = UITextAutocorrectionTypeNo;
    customField2.tag = 0;
    [alert addTextFieldWithCustomTextField:customField2 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
        NSLog(@"Custom TextField Irridium ID Returns: %@", text); // Do what you'd like with the text returned from the field
        
        strIrridiumID = text;
    }];
    
    UITextField *customField5 = [[UITextField alloc] init];
    customField5.placeholder = @"Enter GSM Irridium ID";
    customField5.delegate = self;
    customField5.keyboardType = UIKeyboardTypePhonePad;
    customField5.autocorrectionType = UITextAutocorrectionTypeNo;
    customField5.tag = 1;
    customField5.returnKeyType = UIReturnKeyNext;
    [alert addTextFieldWithCustomTextField:customField5 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
        NSLog(@"Custom TextField GSM ID Returns: %@", text); // Do what you'd like with the text returned from the field
        
        strGSMIrridium = text;
    }];
    
    UITextField *customField3 = [[UITextField alloc] init];
    customField3.placeholder = @"Enter Name";
    customField3.delegate = self;
    customField3.tag = 2;
    customField3.autocorrectionType = UITextAutocorrectionTypeNo;
    [alert addTextFieldWithCustomTextField:customField3 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
        NSLog(@"Custom TextField NAME Returns: %@", text); // Do what you'd like with the text returned from the field
        
        strUpdatedMsg = text;
    }];
    
    
 
    
    UITextField *customField4 = [[UITextField alloc] init];
    customField4.placeholder = @"Enter Phone No";
    customField4.keyboardType = UIKeyboardTypePhonePad;
    customField4.autocorrectionType = UITextAutocorrectionTypeNo;
    customField4.delegate = self;
    customField4.tag = 3;
    customField4.text = @"**********";  ////srivatsa november coz shubra told for this demo,disable phone number option,user should not be able to access phone number textfield
    customField4.userInteractionEnabled = false;
    [alert addTextFieldWithCustomTextField:customField4 andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
        NSLog(@"Custom TextField PHONE NO Returns: %@", text); // Do what you'd like with the text returned from the field
        
        strPhoneNo = text;
    }];
    
    [alert addButton:@"Cancel" withActionBlock:^{
        NSLog(@"Custom Font Button Pressed");
        // Put your action here
    }];
    
    [alert showAlertInView:self
                 withTitle:@"Elite Operator"
              withSubtitle:@"Add Contact"
           withCustomImage:nil
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)ChecktextwithValue:(NSString *)strValue withPlaceholderText:(NSString *)strPlaceholder forText:(UITextField *)txtfield
{
    if ([[self checkforValidString:strValue] isEqualToString:@"NA"])
    {
        txtfield.placeholder =  strPlaceholder;
    }
    else
    {
        txtfield.text = strValue;
    }
}
-(void)ValidationforAddedMessage:(NSString *)text
{
    if ([[self checkforValidString:strGSMIrridium] isEqualToString:@"NA"])
    {
        [self showErrorMessage:@"Please enter GSM Irridium ID."];
    }
    else if ([strGSMIrridium length] <= 13)
    {
        [self showErrorMessage:@"GSM Irridium ID should be atleast 14 characters."];
    }
    else if ([strGSMIrridium length] >= 19)
    {
        [self showErrorMessage:@"GSM Irridium ID can consist upto 18 characters only."];
    }
    else if ([[self checkforValidString:text] isEqualToString:@"NA"])
    {
        [self showErrorMessage:@"Please enter Name."];
    }
    else if ([text length] >8)
    {
        [self showErrorMessage:@"name should have a maximum of 8 characters only."];
        
    }
    else if ([[self checkforValidString:strPhoneNo] isEqualToString:@"NA"])
    {
        [self showErrorMessage:@"Please enter Phone No."];
    }
    else if ([strPhoneNo length] <= 9)
    {
        [self showErrorMessage:@"Phone No should have atleast 10 characters."];
    }
    else if ([strPhoneNo length] >= 16)
    {
        [self showErrorMessage:@"Phone No should have a maximum of 15 characters only."];
    }
    else
    {
        NSMutableArray* arrTmp3 = [[NSMutableArray alloc]init];
        NSString * strQuery3 = [NSString stringWithFormat:@"select * from NewContact where gsm_irridium_id = '%@'",strGSMIrridium];
        [[DataBaseManager dataBaseManager] execute:strQuery3 resultsArray:arrTmp3];
        
        
        if (isEdited)
        {
            NSString * strTmpID = [[arrContacts objectAtIndex:selectedIndex]valueForKey:@"id"];
            
            if (arrTmp3.count > 0)
            {
                if (![[[arrTmp3 objectAtIndex:0]valueForKey:@"gsm_irridium_id"]isEqualToString:[[arrContacts objectAtIndex:selectedIndex]valueForKey:@"gsm_irridium_id"]])
                {
                    [self showErrorMessage:@"GSM Irridium No has already been taken,Please try with different No."];
                    return;
                }
            }
        
            NSString * strInsertCan = [NSString stringWithFormat:@"update NewContact set irridium_id = '%@', name ='%@' ,phone ='%@',gsm_irridium_id = '%@' where id = '%@'",strIrridiumID,text,strPhoneNo,strGSMIrridium,strTmpID];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
            
            if ([arrContacts count]>=selectedIndex)
            {
                [[arrContacts objectAtIndex:selectedIndex] setObject:text forKey:@"name"];
                [[arrContacts objectAtIndex:selectedIndex] setObject:strPhoneNo forKey:@"phone"];
//                [[arrContacts objectAtIndex:selectedIndex] setObject:strNanoID forKey:@"nano"];
                [[arrContacts objectAtIndex:selectedIndex] setObject:strIrridiumID forKey:@"irridium_id"];
                [[arrContacts objectAtIndex:selectedIndex] setObject:strGSMIrridium forKey:@"gsm_irridium_id"];

            }
            [tblView reloadData];
        }
        else
        {
            if (arrTmp3.count > 0)
            {
                [self showErrorMessage:@"GSM Irridium No has already been taken,Please try with different No."];
                return;
            }
            int myInt =0;
            if ([arrContacts count]==0)
            {
            }
            else
            {
                myInt = [[[arrContacts objectAtIndex:[arrContacts count]-1] valueForKey:@"id"] intValue];
            }
            NSString * strSC4NanoID = [self GetUniqueNanoModemId];
            NSString * strLignNanoID = [self GetUniqueNanoModemId];

            
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewContact' ('name','phone','irridium_id','SC4_nano_id','lignlight_nano_id','gsm_irridium_id','isBoat') values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",text,strPhoneNo,strIrridiumID,strSC4NanoID,strLignNanoID,strGSMIrridium,@"0"];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
            
            NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] init];
            [tmpDict setObject:text forKey:@"name"];
            [tmpDict setObject:strPhoneNo forKey:@"phone"];
//            [tmpDict setObject:strNanoID forKey:@"nano"];
            [tmpDict setObject:strIrridiumID forKey:@"irridium_id"];
            [tmpDict setObject:strGSMIrridium forKey:@"gsm_irridium_id"];

            [tmpDict setObject:[NSString stringWithFormat:@"%u",myInt+1] forKey:@"id"];
            
            [arrContacts addObject:tmpDict];
            [tblView reloadData];
            
            [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrContacts.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
        
        
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
-(void)showErrorMessage:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert showAlertInView:self
                 withTitle:@"Elite Operator"
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
        [APP_DELEGATE startHudProcess:@"Syncing Contacts..."];
        
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
        msgTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendAddressbook) userInfo:nil repeats:YES];
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

-(void)sendAddressbook
{
    if (kpCount >= [arrContacts count])
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
                  withSubtitle:@"Contacts synced successfully."
               withCustomImage:nil
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
    else
    {
        NSString * strName = [NSString stringWithFormat:@"%@",[[arrContacts objectAtIndex:kpCount] valueForKey:@"name"]];
        NSString * indexStr = [NSString stringWithFormat:@"%@",[[arrContacts objectAtIndex:kpCount] valueForKey:@"nano"]];
        
        NSInteger firstInt = [@"03" integerValue];
        NSData * firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
        
        NSInteger secondInt = kpCount +1;;
        NSData  *secondData = [[NSData alloc] initWithBytes:&secondInt length:1];
        
        NSInteger thirdInt = [@"01" integerValue];
        NSData * thirdData = [[NSData alloc] initWithBytes:&thirdInt length:1];
        
        NSInteger nanoInt = [indexStr integerValue];
        NSData * fourthData = [[NSData alloc] initWithBytes:&nanoInt length:2];
        
        NSString * str = [self hexFromStr:strName];
        NSData * msgData = [self dataFromHexString:str];
        
        //        NSMutableData *completeData = [firstData mutableCopy];
        NSMutableData *completeData = [secondData mutableCopy];
        //        [completeData appendData:secondData];
        [completeData appendData:thirdData];
        [completeData appendData:fourthData];
        [completeData appendData:msgData];
        
        [[BLEService sharedInstance] SendDatatodevice:completeData withPeripheral:globalPeripheral];
        [self performSelector:@selector(SyncPhonePart) withObject:nil afterDelay:0.2];

    }
}
-(void)SyncPhonePart
{
    if (kpCount < [arrContacts count])
    {
        NSString * phoneStr = [NSString stringWithFormat:@"%@",[[arrContacts objectAtIndex:kpCount] valueForKey:@"phone"]];
        
        NSInteger firstInt = [@"03" integerValue];
        NSData * firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
        
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

        kpCount = kpCount +1;
        
    }
}
-(void)SyncIrridiumPart
{
    if (kpCount < [arrContacts count])
    {
        NSString * strIrridium = [NSString stringWithFormat:@"%@",[[arrContacts objectAtIndex:kpCount] valueForKey:@"irridium_id"]];
        
        NSInteger firstInt = [@"03" integerValue];
        NSData * firstData = [[NSData alloc] initWithBytes:&firstInt length:1];
        
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
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Helper Methods

- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    NSLog(@"Button Clicked: %ld Title:%@", (long)index, title);
    
    if (alertView.tag == 456)
    {
        
    }
}

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView
{
    NSLog(@"Done Button Clicked");
    if (alertView.tag == 456)
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
