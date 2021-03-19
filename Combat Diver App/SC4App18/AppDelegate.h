//
//  AppDelegate.h
//  SC4App18
//
//  Created by stuart watts on 17/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardVC.h"
#import "DeviceSetupVC.h"
#import "ChatVC.h"
#import "DeviceStatusVC.h"
#import <ExternalAccessory/ExternalAccessory.h>

int textSize;
int screenWidth;
CGFloat approaxSize;
BOOL isAnimated, restrictRotation, isAllowtoPush, isScanForLignlight;
CBPeripheral * globalPeripheral;
EAAccessory * globalSelectedAccessory;
NSDate * globalDownloadDate;
NSString * strCurrentScreen;
NSString * strSelectedOperation;
NSString * strGlobalSC4BLEAddress;//KP0711
NSString * globalSequence;
DashboardVC * globalDashboard;//KP0711
DeviceSetupVC * globalDeviceSetup;//KP0711
ChatVC * globalChatVC;
DeviceStatusVC * globalDeviceStatusVC;

NSString * strGlobalPeripheralName;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UISplitViewController * splitViewController;
    NSInteger selectedECG;
}
@property (strong, nonatomic) UIWindow *window;

-(UIColor *) colorWithHexString:(NSString *)stringToConvert;
-(UIImage *)imageFromColor:(UIColor *)color;
-(void)startHudProcess:(NSString *)text;
-(void)endHudProcess;
-(NSString *)getbackgroundImage;
-(void)DashboardforIPAD;
-(void)DashboardforIphone;
-(void)MoveToSplash;
-(NSString *)checkforValidString:(NSString *)strRequest;
-(void)showPopupwithText:(NSString *)strMessage withView:(UIViewController *)inView;
-(void)showPopupwithMessage:(NSString *)strMessage withOpcode:(NSString *)strOpcode;
-(BOOL)isNetworkreachable;

@end

