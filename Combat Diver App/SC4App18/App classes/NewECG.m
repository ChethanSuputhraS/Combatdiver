//
//  NewECG.m
//  SC4App18
//
//  Created by srivatsa s pobbathi on 10/10/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "NewECG.h"
#import "DiverBiometricCell.h"
#import "SRMedGraphController.h"

#import <ExternalAccessory/ExternalAccessory.h>

@interface NewECG ()<EAAccessoryDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * arrValues;
    UITableView *tblContent;

}
@end

@implementation NewECG

- (void)viewDidLoad {
    
    [self setUpHeaderView];
    [self GetConnectedDevices];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setUpHeaderView
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
    [lblTitle setText:@"Record ECG"];
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
    btnBack.frame = CGRectMake(0, 0, 140 + 40, headerhHeight);
    btnBack.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnBack];
    
    UIButton * btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMenu addTarget:self action:@selector(btnMenuclick) forControlEvents:UIControlEventTouchUpInside];
    btnMenu.frame = CGRectMake(viewWidth-100, 0, headerhHeight + 40, headerhHeight);
    btnMenu.backgroundColor = [UIColor redColor];
    [viewHeader addSubview:btnMenu];

    
    if (IS_IPHONE_X)
    {
        viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
        lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
        backImg.frame = CGRectMake(10, 12+44, 12, 20);
        btnBack.frame = CGRectMake(0, 0, 70, 88);
    }
    [self setUpMainViewFrames];
}

-(void)setUpMainViewFrames
{
    int yy = 64;
    if (IS_IPHONE_X)
    {
        yy = 84;
    }
    tblContent =[[UITableView alloc]initWithFrame:CGRectMake(20, yy+10, viewWidth-40, DEVICE_HEIGHT-yy-10)];
    tblContent.delegate=self;
    tblContent.dataSource=self;
    tblContent.rowHeight=70;
    tblContent.backgroundColor=[UIColor clearColor];
    [tblContent setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblContent setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:tblContent];
}


-(void)GetConnectedDevices
{
    arrValues = [[NSMutableArray alloc] init];
    NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    for (EAAccessory *obj in accessories)
    {
        BOOL available = false;
        NSString * strProtocol = @"NA";
        NSLog(@"connected %@ %@ %@ %@ %@ %@", [obj name], [obj manufacturer], [obj modelNumber], [obj serialNumber], [obj firmwareRevision], [obj hardwareRevision]);
        if ([[obj protocolStrings] containsObject:@"de.sr-med"])
        {
            available = true;
            strProtocol = @"de.sr-med";
        }
        else if ([[obj protocolStrings] containsObject:@"DE.SR-MED"])
        {
            available = true;
            strProtocol = @"DE.SR-MED";
        }
        if (available)
        {
            NSString *strSerialNo = [APP_DELEGATE checkforValidString:[[[obj serialNumber] componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
            NSString * strQuery = [NSString stringWithFormat:@"select * from NewContact where serial_no LIKE '%%%@%%'",strSerialNo];
            NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
            [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:tmpArr];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:strSerialNo forKey:@"serial_no"];
            [dict setObject:strProtocol forKey:@"protocol"];

            if ([tmpArr count]>0)
            {
                dict = [tmpArr objectAtIndex:0];
                [dict setObject:obj forKey:@"accessory"];
                [arrValues addObject:dict];
            }
            else
            {
                [dict setObject:obj forKey:@"accessory"];
                [dict setObject:[NSString stringWithFormat:@"%@ %@",[obj name], [obj serialNumber]] forKey:@"name"];
                [arrValues addObject:dict];
            }
        }
    }
    NSLog(@"final values=%@",arrValues);
    [tblContent reloadData];
}
#pragma mark - Button EVent
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableview Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE)
    {
        return 55;
    }
    return 70;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrValues.count;
    //    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 60;
    if (IS_IPHONE)
    {
        height = 50;
    }
    static NSString *cellIdentifier = @"cellID";
    DiverBiometricCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[DiverBiometricCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.btnSerialNo.hidden = YES;
    cell.lblTap.hidden = true;
    cell.btnSerialNo.backgroundColor = [UIColor clearColor];
    if (arrValues.count > 0)
    {
        cell.lblName.text = [[arrValues objectAtIndex:indexPath.row]valueForKey:@"name"];
        cell.lblNano.text = [[arrValues objectAtIndex:indexPath.row]valueForKey:@"serial_no"];
        cell.lblName.frame = CGRectMake(50, 0,viewWidth-170-50-20,30);
        cell.lblNano.frame = CGRectMake(50, 30,viewWidth-170-50-20,30);
        cell.lblEcgSerial.text = @"Download";
        cell.lblEcgSerial.frame =  CGRectMake(viewWidth-170, 0, 120, height);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EAAccessory * tmpObj = [[arrValues objectAtIndex:indexPath.row] objectForKey:@"accessory"];
    globalSelectedAccessory = tmpObj;
    strGlobalSerialNo = [[arrValues objectAtIndex:indexPath.row] objectForKey:@"serial_no"];
    
    SRMedGraphController *controller = [[SRMedGraphController alloc] init];
    controller.diverDict = [arrValues objectAtIndex:indexPath.row];
    if (IS_IPAD) {
        UINavigationController * navView = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentViewController:navView animated:YES completion:nil];
    } else {
        [self presentViewController:controller animated:YES completion:nil];
    }
}
-(void)btnMenuclick
{
    UIDocumentPickerViewController* documentPicker =
    [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                           inMode:UIDocumentPickerModeImport];
    
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    
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
