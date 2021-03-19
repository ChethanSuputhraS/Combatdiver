//
//  SplashVC.m
//  SC4App18
//
//  Created by stuart watts on 07/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "SplashVC.h"
#import "LeftMenuVC.h"
#import "MFSideMenuContainerViewController.h"

@interface SplashVC ()
{
    UISplitViewController * splitViewController;
}
@end

@implementation SplashVC

- (void)viewDidLoad
{
//    [[BLEManager sharedManager] stopScan];

    self.navigationController.navigationBarHidden = YES;
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:@"Splash-Ipad.png"];
    [self.view addSubview:imgBack];
    
//    UILabel * lbl = [[UILabel alloc] init];
//    lbl.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
//    lbl.backgroundColor = [UIColor blackColor];
//    lbl.alpha = 0.5;
//    [imgBack addSubview:lbl];
//
//    UIImageView * imgLogo = [[UIImageView alloc] init];
//    imgLogo.frame = CGRectMake((DEVICE_WIDTH-350)/2, (DEVICE_HEIGHT-72)/2, 350, 72);
//    imgLogo.image = [UIImage imageNamed:@"logo.png"];
//    [self.view addSubview:imgLogo];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (IS_IPHONE)
    {
        imgBack.image = [UIImage imageNamed:[self getbackgroundImageforSplash]];
        [self performSelector:@selector(DashboardforIphone) withObject:self afterDelay:1.5];
    }
    else
    {
        [self performSelector:@selector(DashboardforIPAD) withObject:self afterDelay:1.5];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)DashboardforIPAD //KPchanges
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[APP_DELEGATE window] cache:YES];
    [UIView commitAnimations];
    
    splitViewController = [[UISplitViewController alloc] init];
    
    LeftMenuVC * root = [[LeftMenuVC alloc] init];
    globalDashboard  = [[DashboardVC alloc] init];
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:root];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:globalDashboard];
    
    splitViewController.viewControllers = [NSArray arrayWithObjects:rootNav, detailNav, nil];
    splitViewController.delegate = globalDashboard;
    [[APP_DELEGATE window] setRootViewController:(UIViewController*)splitViewController];  // that's the ticket
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
    [APP_DELEGATE window].rootViewController = container;
}

-(NSString *)getbackgroundImageforSplash
{
    NSString * strImgName = @"";
    if (IS_IPHONE_4)
    {
        strImgName = @"Splash4.png";
    }
    else if (IS_IPHONE_5)
    {
        strImgName = @"Splash5.png";
    }
    else if (IS_IPHONE_6)
    {
        strImgName = @"Splash6.png";
    }
    else if (IS_IPHONE_6plus)
    {
        strImgName = @"Splash6+.png";
    }
    else if (IS_IPHONE_X)
    {
        strImgName = @"SplashX.png";
    }
    return strImgName;
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
