//
//  DeviceSetupVC.h
//  SC4App18
//
//  Created by stuart watts on 28/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceSetupVC : UIViewController
{
    UITableView * tblView, * tblContact;
    NSMutableArray * cannedMsgArr, * contactArr, * diversArr;
    NSTimer * msgTimer;
    NSInteger kpCount,selectedIndex;
    UIView *  viewOverLay, * pickerView;
    UILabel *  lblNoData;
    BOOL isDiver,isForSyncAddressBook,isSynced;
    int headerhHeight,viewWidth;
    
    UIImageView * backContactView;
    NSTimer * ackCheckTimer;
}
@property(nonatomic,strong) CBPeripheral * sentPeripheral;
@property(nonatomic,strong) NSString * isfromScreen;
-(void)SyncedAcknowlegmentfor:(NSString *)strType;

@end
