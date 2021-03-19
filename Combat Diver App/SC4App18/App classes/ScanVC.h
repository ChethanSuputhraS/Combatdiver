//
//  ScanVC.h
//  SC4App18
//
//  Created by stuart watts on 27/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSegmentedControl.h"

@interface ScanVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int headerhHeight,viewWidth,kpCount;
    UITableView * tblView,*tblContact;
    NYSegmentedControl *blueSegmentedControl;
    long selectedIndex;
    UIView *viewOverLay;
    UIImageView *backContactView;
    NSMutableArray * contactArr,*compareContactArr;
    BOOL isCotactViewOpened,isSynced;
    CBPeripheral * lignLightPeripheral;
    NSTimer * acknowldgeTimer,*scanningForDeviceTimer;
    UILabel * lblScanning;
}
@end
