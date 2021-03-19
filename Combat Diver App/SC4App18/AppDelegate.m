//
//  AppDelegate.m
//  SC4App18
//
//  Created by stuart watts on 17/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuVC.h"
#import "MFSideMenuContainerViewController.h"
#import "SplashVC.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Reachability.h"
#import "KPTrilaterator.h"

@interface AppDelegate ()
{
    MBProgressHUD * HUD;
    FCAlertView * alerts;
}
@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    strGlobalSC4BLEAddress = @"ABCDE1234";
//    [self tempMethod];
    float mainv = 234;
    float tempDistance = (mainv/1000);
    NSLog(@"Value distance=%f",tempDistance);
//    [self latlongcal];
//    strValue = [NSString stringWithFormat:@"%f",tempDistance];

//    [self TestingMethod:strGlobalSerialNo];
//    NSString * str = [NSString stringWithFormat:@"select * from NewContact"];
//    NSMutableArray * tmpArrs = [[NSMutableArray alloc] init];
//    [[DataBaseManager dataBaseManager] execute:str resultsArray:tmpArrs];
//    NSLog(@"data=%@",tmpArrs);

    isAllowtoPush = YES;
    [self createDatabase];
    [self GetDatafromDatabase];
    if (IS_IPAD)
    {
        textSize = 17;
    }
    else
    {
        textSize = 16;
        if (IS_IPHONE_4 || IS_IPHONE_5)
        {
            textSize = 15;
        }
        if (IS_IPHONE_6plus)
        {
            approaxSize = 1.29;
        }
        else if (IS_IPHONE_6 || IS_IPHONE_X)
        {
            approaxSize = 1.17;
        }
        else
        {
            approaxSize = 1;
        }
    }
    [Fabric with:@[[Crashlytics class]]];
    
    SplashVC * splsh  = [[SplashVC alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:splsh];
    self.window.rootViewController = nav;

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self SetDefaultECGValues];
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] rangeOfString:@"multiecg://"].location == 0)
    {
        NSLog (@"New patient identifier %@", [url absoluteString]);
        NSString *patientID = [[url absoluteString] substringFromIndex:11];
        [[NSUserDefaults standardUserDefaults] setObject:patientID forKey:@"patientID"];
    }
    else if ([[url absoluteString] rangeOfString:@"boxsdk-0f0nuzo21pt5jwhm0bkzjh7z51304200://"].location == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Box.com" message:@"Registration successfull"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"Unknown caller url %@", [url absoluteString]);
        return NO;
    }
    return YES;
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (BOOL)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"avetana.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) {
        return YES;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"avetana.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        return NO;
    }
    return YES;
}

-(void)MoveToSplash
{
    isAnimated = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[APP_DELEGATE window] cache:YES];
    [UIView commitAnimations];
    
    
    SplashVC * splsh  = [[SplashVC alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:splsh];
    self.window.rootViewController = nav;
}
-(void)DashboardforIPAD
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
    [UIView commitAnimations];

    splitViewController = [[UISplitViewController alloc] init];
    
    LeftMenuVC * root = [[LeftMenuVC alloc] init];
    globalDashboard  = [[DashboardVC alloc] init];
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:root];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:globalDashboard];
    
    splitViewController.viewControllers = [NSArray arrayWithObjects:rootNav, detailNav, nil];
    splitViewController.delegate = globalDashboard;
    [self.window setRootViewController:(UIViewController*)splitViewController];  // that's the ticket
}
-(void)DashboardforIphone
{
    // View Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
    [UIView commitAnimations];
    
    DashboardVC * dashboard = [[DashboardVC alloc] init];
    UINavigationController * navControl = [[UINavigationController alloc] initWithRootViewController:dashboard];
    navControl.navigationBarHidden=YES;
    
    LeftMenuVC * leftMenu = [[LeftMenuVC alloc] init];
    MFSideMenuContainerViewController * container = [MFSideMenuContainerViewController containerWithCenterViewController:navControl leftMenuViewController:leftMenu rightMenuViewController:nil];
    self.window.rootViewController = container;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"55555555");
    
    return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([strCurrentScreen  isEqualToString:@"DiverBiometrics"])
    {
        
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Save changes.
    // Close the database.
    if (IS_IPAD) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidECGAction" object:nil];
    }
}
#pragma mark -
#pragma mark ECG UIPopoverController

- (void)didECGAction:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    NSNumber *index1 = [dict objectForKey:@"Select"];
    NSNumber *index2 = [dict objectForKey:@"Delete"];
    NSNumber *index3 = [dict objectForKey:@"Insert"];
    if (index1) {
        [self updateECGGraphAtIndex:[index1 intValue]];
        selectedECG = [index1 intValue];
    } else if (index2) {
        if ([index2 intValue] == selectedECG) {
            [self updateECGGraphAtIndex:-1];
            selectedECG = -1;
        } else if ([index2 intValue] < selectedECG) {
            selectedECG--;
        }
    } else if (index3) {
        if ([index3 intValue] <= selectedECG) {
            selectedECG++;
        }
    }
}
- (void)updateECGGraphAtIndex:(NSInteger)index {
    
}


#pragma mark - Create Database
-(void)createDatabase
{
    [[DataBaseManager dataBaseManager] createDatabase];
    [[DataBaseManager dataBaseManager] createAddressbook];
    [[DataBaseManager dataBaseManager] createCannedMessage];
    [[DataBaseManager dataBaseManager] createChatTable];
    [[DataBaseManager dataBaseManager] createErrorLogTable];
    [[DataBaseManager dataBaseManager] CrateNewCannedMessageTable];
    [[DataBaseManager dataBaseManager] createNewChatTable];
    [[DataBaseManager dataBaseManager] CreateNewContatTable];
    [[DataBaseManager dataBaseManager] CrateDiverMsgTable];
    [[DataBaseManager dataBaseManager] CreateHeatMessages];
    [[DataBaseManager dataBaseManager] addIMEIcolumnstoContactTable];
    [[DataBaseManager dataBaseManager] createECGMeasurementTable];
    [[DataBaseManager dataBaseManager] addECGSerialNumbertoContact];
    [[DataBaseManager dataBaseManager] Add_ECG_Name_to_NewContact];
    [[DataBaseManager dataBaseManager] CreateDiver_Locate];
    [[DataBaseManager dataBaseManager] CreateDiver_Locate_Details];
    [[DataBaseManager dataBaseManager] Add_sequence_to_NewChat];
}
-(void)GetDatafromDatabase
{
    NSMutableArray * cannedArr = [[NSMutableArray alloc] init];
    NSString * strCanned = [NSString stringWithFormat:@"Select * from DiverMessage"];
    [[DataBaseManager dataBaseManager] execute:strCanned resultsArray:cannedArr];
    if ([cannedArr count]==0)
    {
        NSArray * realArray = [[NSArray alloc] initWithObjects:@"Stop",@"Go",@"Report",@"Complete",@"Low Air",@"Training Complete",@"Canned 7",@"Canned 8",@"Canned 9",@"Canned 10",@"Canned 11",@"Canned 12",@"Canned 13",@"Canned 14",@"Canned 15",@"Canned 16",@"Canned 17",@"Canned 18",@"Canned 19",@"Canned 20", nil];
        for (int i = 0; i<[realArray count]; i++)
        {
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'DiverMessage' ('Message','is_emergency','indexStr') values ('%@','No','%d')",[realArray objectAtIndex:i],i+1];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        }
    }
    NSMutableArray * divArr = [[NSMutableArray alloc] init];
    NSString * strDiver = [NSString stringWithFormat:@"Select * from NewCanned_message"];
    [[DataBaseManager dataBaseManager] execute:strDiver resultsArray:divArr];
    if ([divArr count]==0)
    {
        NSArray * realArray = [[NSArray alloc] initWithObjects:@"Ok",@"Stop",@"Go",@"Acknowledged",@"Return to RV",@"Canned 6",@"Canned 7",@"Canned 8",@"Canned 9",@"Canned 10",@"Canned 11",@"Canned 12",@"Canned 13",@"Canned 14",@"Canned 15",@"Canned 16",@"Canned 17",@"Canned 18",@"Canned 19",@"Canned 20", nil];
        for (int i = 0; i<[realArray count]; i++)
        {
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewCanned_message' ('Message','is_emergency','indexStr') values ('%@','No','%d')",[realArray objectAtIndex:i],i+1];
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        }
    }
    NSMutableArray * addArr = [[NSMutableArray alloc] init];
    NSString * strAdd = [NSString stringWithFormat:@"Select * from NewContact"];
    [[DataBaseManager dataBaseManager] execute:strAdd resultsArray:addArr];
    if ([addArr count]==0)
    {
        NSArray * namesArr = [[NSArray alloc] initWithObjects:@"Boat",@"Diver 1",@"Diver 2",@"Diver 3",@"Diver 4", nil];
        NSMutableArray * tmpArr = [[NSMutableArray alloc]init];
        for (int i = 0; i<namesArr.count; i++)
        {
            NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[namesArr objectAtIndex:i],@"names", nil];
            [tmpArr addObject:tmpDict];
        }
        int tmpID = 1;
        NSArray * tmpBoolArr = [[NSArray alloc]initWithObjects:@"1",@"0",@"0",@"0",@"0", nil];
        NSArray * tmpGsmArr = [[NSArray alloc]initWithObjects:@"359865075886559",@"359865075871106",@"359865075871101",@"359865075871102",@"359865075871103", nil];

        for (int i = 0; i<[tmpArr count]; i++)
        {
            NSString * strSC4NanoID = [self GetUniqueNanoModemId];
            NSString * strLignNanoID = [self GetUniqueNanoModemId];
                        NSLog(@"Count1=%@",strSC4NanoID);
                        NSLog(@"Count2=%@",strLignNanoID);

            [[tmpArr objectAtIndex:i]setValue:strSC4NanoID forKey:@"SC4_nano_id"];
            tmpID = tmpID +1;
            [[tmpArr objectAtIndex:i]setValue:strLignNanoID forKey:@"lignlight_nano_id"];
            tmpID = tmpID +1;
            NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'NewContact' ('name','nano','SC4_nano_id','lignlight_nano_id','isBoat','gsm_irridium_id') values ('%@','%d','%@','%@','%@','%@')",[[tmpArr objectAtIndex:i]valueForKey:@"names"],i+1,[[tmpArr objectAtIndex:i]valueForKey:@"SC4_nano_id"],[[tmpArr objectAtIndex:i]valueForKey:@"lignlight_nano_id"],[tmpBoolArr objectAtIndex:i],[tmpGsmArr objectAtIndex:i]];
            NSLog(@"Query=%@",strInsertCan);
            [[DataBaseManager dataBaseManager] execute:strInsertCan];
        }
    }
    NSMutableArray * heatArr = [[NSMutableArray alloc] init];
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
-(UIColor *) colorWithHexString:(NSString *)stringToConvert
{
    // NSLog(@"ColorCode -- %@",stringToConvert);
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:1.0f];
}

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark Hud Method
-(void)startHudProcess:(NSString *)text
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    HUD.labelText = text;
    [self.window addSubview:HUD];

    [HUD show:YES];
}
-(void)endHudProcess
{
    [HUD hide:YES];
}
-(NSString *)getbackgroundImage;
{
    NSString * strImgName = @"";
    if (IS_IPHONE_4)
    {
        strImgName = @"iphone4.png";
    }
    else if (IS_IPHONE_5)
    {
        strImgName = @"iphone5.png";
    }
    else if (IS_IPHONE_6)
    {
        strImgName = @"iphone6.png";
    }
    else if (IS_IPHONE_6plus)
    {
        strImgName = @"iphone6+.png";
    }
    else if (IS_IPHONE_X)
    {
        strImgName = @"iphonex.png";
    }
    return strImgName;
}
//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (IS_IPAD)
//    {
////        if(restrictRotation)
//            return  UIInterfaceOrientationMaskAll;
////        else
////            return UIInterfaceOrientationMaskPortrait;
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}
-(void)SetDefaultECGValues
{
    // Set defaults
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"0", @"SelectedTab",
                                 @"https://www.avetana.de/file", @"server_url",
                                 @"NO", @"logged_in",
                                 @"", @"username",
                                 @"", @"access_token",
                                 @"", @"patient_name",
                                 @"", @"patient_access_token",
                                 @"kg", @"weightunit",
                                 @"mmol/l", @"glucoseunit",
                                 @"140", @"maxsyst",
                                 @"90", @"maxdiast",
                                 @"0", @"maxweight",
                                 @"0", @"minweight",
                                 @"0", @"maxglucose",
                                 @"0", @"minglucose",
                                 @"5", @"mmmV",
                                 @"10", @"mmsec",
                                 nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
//    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultValueSet"] isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"vibrateDuration"];
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"vibrateRepeat"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
-(NSString *)checkforValidString:(NSString *)strRequest
{
    NSString * strValid;
    if (![strRequest isEqual:[NSNull null]])
    {
        if (strRequest != nil && strRequest != NULL && ![strRequest isEqualToString:@""] && ![strRequest isEqualToString:@"(null)"])
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
    strValid = [strValid stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strValid;
}

-(void)showPopupwithText:(NSString *)strMessage withView:(UIViewController *)inView
{
    alerts = [[FCAlertView alloc] init];
    alerts.colorScheme = [UIColor blackColor];
    [alerts makeAlertTypeWarning];
    [alerts showAlertInView:inView
                 withTitle:@"Combat Diver"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];

}
-(NSString*)stringFroHex:(NSString *)hexStr
{
    unsigned long long startlong;
    NSScanner* scanner1 = [NSScanner scannerWithString:hexStr];
    [scanner1 scanHexLongLong:&startlong];
    double unixStart = startlong;
    NSNumber * startNumber = [[NSNumber alloc] initWithDouble:unixStart];
    return [startNumber stringValue];
}
-(void)showPopupwithMessage:(NSString *)strMessage withOpcode:(NSString *)strOpcode
{
    [alerts removeFromSuperview];
    alerts = [[FCAlertView alloc] init];
    alerts.colorScheme = [UIColor blackColor];
    if ([strOpcode isEqualToString:@"01"])
    {
        [alerts makeAlertTypeSuccess];
    }
    else
    {
        [alerts makeAlertTypeWarning];
    }
    [alerts showAlertInWindow:window
                 withTitle:@"Combat Diver"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
    
    
}

-(void)TestingMethod:(NSString *)valueStr
{
    valueStr = @"021304002f2dbb0c001f3f244c003850ae8c000000";
    if (![[self checkforValidString:valueStr] isEqualToString:@"NA"])
    {
        if ([valueStr length]>=32)//For Diver Locate 18122019
        {
            NSString * strCmd = [valueStr substringWithRange:NSMakeRange(0, 2)];
            if ([strCmd isEqualToString:@"02"])
            {
                if ([valueStr length]>=6)
                {
                    NSString * strOpcode = [valueStr substringWithRange:NSMakeRange(4, 2)];
                    if ([strOpcode isEqualToString:@"04"])
                    {
                        if ([valueStr length]>= 32)
                        {
                            NSString * strNanoID =
                            [self getStringExtcacted:[valueStr substringWithRange:NSMakeRange(6, 8)]];

                            NSRange range1 = NSMakeRange(14,10);
                            NSString * strLat = [valueStr substringWithRange:range1];
                            NSString * strLatFinal = [self getLatitudeLongitude:strLat];
                            
                            range1 = NSMakeRange(24,10);
                            NSString * strLong = [valueStr substringWithRange:range1];
                            NSString * strlongFinal = [self getLatitudeLongitude:strLong];
                            
                            NSString * strDistance = [valueStr substringWithRange:NSMakeRange(34, 8)];
                            
                            
                            strDistance = @"0000803E";
                            NSString  * strFinalDistance = @"0";
                            if (strDistance.length ==8)
                            {
                                NSString * str1 = [strDistance substringWithRange:NSMakeRange(strDistance.length-2, 2)];
                                NSString * str2 = [strDistance substringWithRange:NSMakeRange(strDistance.length-4, 2)];
                                NSString * str3 = [strDistance substringWithRange:NSMakeRange(strDistance.length-6, 2)];
                                NSString * str4 = [strDistance substringWithRange:NSMakeRange(strDistance.length-8, 2)];
                                strFinalDistance = [self getStringExtcacted:[NSString stringWithFormat:@"%@%@%@%@",str3,str4,str1,str2]];
                            }
                            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                            [dict setObject:strNanoID forKey:@"NanoID"];
                            [dict setObject:strLatFinal forKey:@"lat"];
                            [dict setObject:strlongFinal forKey:@"long"];
                            [dict setObject:strFinalDistance forKey:@"distance"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDistanceofNanoID" object:dict];
                            NSLog(@"data=%@",dict);
                        }
                    }
                }
            }
        }
        else if ([valueStr length]>=24)
        {
            if ([valueStr rangeOfString:@"0a0a"].location != NSNotFound)
            {
                if ([valueStr length]==24)
                {
                    //Get Latitude
                    NSRange range1 = NSMakeRange(4,10);
                    NSString * strLat = [valueStr substringWithRange:range1];
                    NSString * strLatFinal = [self getLatitudeLongitude:strLat];
                    
                    range1 = NSMakeRange(14,10);
                    NSString * strLong = [valueStr substringWithRange:range1];
                    NSString * strlongFinal = [self getLatitudeLongitude:strLong];
                    
                    float lat  = [strLatFinal floatValue];
                    lat = lat + 0.1401344;
                    strLatFinal = [NSString stringWithFormat:@"%f",lat];
                    
                    float longi  = [strlongFinal floatValue];
                    longi = longi + 0.2375655;
                    strlongFinal = [NSString stringWithFormat:@"%f",longi];
                    
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:strLatFinal forKey:@"latitude"];
                    [dict setObject:strlongFinal forKey:@"longitude"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGPSLocation" object:dict];
                }
            }
        }
        else if ([valueStr length]>=16)
        {
            NSString * strCmd = [valueStr substringWithRange:NSMakeRange(0, 2)];
            if ([strCmd isEqualToString:@"05"])
            {
                NSString * strOpcode = [valueStr substringWithRange:NSMakeRange(12, 2)];
                NSString * strNanoID = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(4, 8)]];
                
                NSString * strHexMsg = [valueStr substringWithRange:NSMakeRange(14, 2)];
                NSString * strMsg = [self stringFroHex:strHexMsg];
                [globalDashboard UpdateMessagelistwithNanoID:strNanoID withValue:strMsg withOpcode:strOpcode];
            }
        }
        else if([valueStr length]>=6)
        {
            NSString * strCmd = [valueStr substringWithRange:NSMakeRange(0, 4)];
            if ([strCmd isEqualToString:@"0901"])
            {
                NSString * strOpcode = [valueStr substringWithRange:NSMakeRange(4, 2)];
                [globalDeviceSetup SyncedAcknowlegmentfor:strOpcode];
            }
            else if ([strCmd isEqualToString:@"0101"])
            {
                if ([[valueStr substringWithRange:NSMakeRange(0, 6)]isEqualToString:@"010101"])
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"lignLightAssignAck" object:nil];
                    
                }
            }
        }
        
    }
}

-(NSString *)getStringExtcacted:(NSString *)importStr
{
    NSString * strExport;
    
    unsigned int uContact;
    NSScanner* scanner = [NSScanner scannerWithString:importStr];
    [scanner scanHexInt:&uContact];
    double unixNano = uContact;
    NSNumber * nanoNumber = [[NSNumber alloc] initWithDouble:unixNano];
    strExport = [NSString stringWithFormat:@"%@",nanoNumber];
    
    return strExport;
}
-(BOOL)isNetworkreachable
{
    Reachability *networkReachability = [[Reachability alloc] init];
    NetworkStatus networkStatus = [networkReachability internetConnectionStatus];
    if (networkStatus == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(NSString *)getLatitudeLongitude:(NSString *)strHex
{
    //Get Latitude
    NSRange range1 = NSMakeRange(0,2);
    NSString * strLat = [strHex substringWithRange:range1];
    //After PointValuue
    range1 = NSMakeRange(4,6);
    NSString * strLatPointVal =  [self getStringExtcacted:[strHex substringWithRange:range1]] ;
    
    double pointfloat = [strLatPointVal floatValue];
    int afterCalPoint = (pointfloat * 100.0)/60;
    
    NSString * strLatFinal = [NSString stringWithFormat:@"%@.%d",[self getStringExtcacted:strLat],afterCalPoint];
    return strLatFinal;
}
-(void)latlongcal
{
    [self getLatitudeLongitude:@"0c001f3efc"];
//    <0213040469301e 0c001f3efc 4c003850c2000000bb>
//    2020-01-11 14:52:02.735 Combat Diver[1183:317270] without convert=515
//    2020-01-11 14:52:02.737 Combat Diver[1183:317270] Here in Setupsurfae got the lat={
//        NanoID = 74002462;
//        distance = 515;
//        lat = "20.0.000000";
//        long = "124.0.000000";
//    } and long
}
//Distance1 = 234;
//Distance2 = 93;
//Distance3 = 93;
//Status = Completed;
//lat1 = "12.2047610";
//lat2 = "20.0";
//lat3 = "12.2047650";
//long1 = "76.3690510";
//long2 = "124.0";
//long3 = "76.3690540";
//pingtime1 = "1578639052.374993";
//pingtime2 = "1578639253.801730";
//pingtime3 = "1578639345.395146";
-(void)tempMethod
{
    CLLocation * loc1 = [[CLLocation alloc] initWithLatitude:12.2047610 longitude:76.3690510];
    CLLocation * loc2 = [[CLLocation alloc] initWithLatitude:20.0 longitude:124.0];
    CLLocation * loc3 = [[CLLocation alloc] initWithLatitude:12.2047650 longitude:76.3690540];

    float d1 = (234 / 1000000.0);
    
    double d2 = 93/1000000;
    double d3 = 93/1000000;
    
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:loc1 forKey:@"location"];
    [dic1 setObject:[NSNumber numberWithFloat:234/1000000] forKey:@"distance"];
    
    NSMutableDictionary * dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:loc2 forKey:@"location"];
    [dic2 setObject:[NSNumber numberWithFloat:d2] forKey:@"distance"];
    
    NSMutableDictionary * dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:loc3 forKey:@"location"];
    [dic3 setObject:[NSNumber numberWithFloat:d3] forKey:@"distance"];
    
    
    NSMutableArray * tmpArr = [[NSMutableArray alloc] initWithObjects:dic1,dic2,dic3, nil];
    
    KPTrilaterator * trl = [[KPTrilaterator alloc] init];
    [trl compute:tmpArr];
    
    //    [trl trilaterate:tmpArr success:^(Location * loca)
    //     {
    //         NSLog(@"got the lcoation=%f  long=%f" ,loca.coordinates.latitude,loca.coordinates.longitude);
    //     }failure:^(NSError * err)
    //     {
    //
    //     }];
    
}


@end
