//
//  DashboardVC.h
//  SC4App18
//
//  Created by stuart watts on 17/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZFlashButton.h"

@interface DashboardVC : UIViewController<UISplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int viewWidth, headerHeight; int fixedHeight;
    UIButton * btnScan;
    UIView * pulseView;
    WZFlashButton * ripple;
    UILabel * lblTotalUserCount;
    
    UIImageView * imgConnect, * imgScanner;
    UILabel * lblConnect, * lblBattery, * lblNoContacts, * lblSetup;
    UIButton * btnSetup;
    
    UITableView * tblView;
    NSMutableArray * arrMessages;
    UILabel * lblBatteryValue;
}
-(void)UpdateMessagelistwithNanoID:(NSString *)strNano withValue:(NSString *)strValue withOpcode:(NSString *)strOpcode;
@end
