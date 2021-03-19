//
//  CompassVC.m
//  SC4App18
//
//  Created by stuart watts on 19/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "CompassVC.h"
#import "SYCompassView.h"

@interface CompassVC ()
{
    int headerhHeight,viewWidth;
}
@end

@implementation CompassVC

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;

    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
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
    [lblTitle setText:@"Compass"];
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
    btnBack.frame = CGRectMake(0, 0, 100 + 40, headerhHeight);
    btnBack.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:btnBack];

    if (IS_IPHONE_X)
    {
        viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
        lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
        backImg.frame = CGRectMake(10, 12+44, 12, 20);
        btnBack.frame = CGRectMake(0, 0, 70, 88);
    }
    if (IS_IPHONE)
    {
        int compassWidth = DEVICE_WIDTH-20;
        
        SYCompassView *compassView = [SYCompassView sharedWithRect:CGRectMake(10, ((DEVICE_HEIGHT-compassWidth)/2)+0, DEVICE_WIDTH-20, DEVICE_WIDTH-20) radius:(DEVICE_WIDTH-20)/2];
        compassView.textColor = [UIColor whiteColor];
        compassView.calibrationColor = [UIColor whiteColor];
        compassView.horizontalColor = [UIColor clearColor];
        compassView.layer.masksToBounds = YES;
        [self.view addSubview:compassView];
    }
    else
    {
        SYCompassView *compassView = [SYCompassView sharedWithRect:CGRectMake(51, 51+64, 600, 600) radius:(600)/2];
        compassView.textColor = [UIColor whiteColor];
        compassView.calibrationColor = [UIColor whiteColor];
        compassView.horizontalColor = [UIColor clearColor];
        compassView.layer.masksToBounds = YES;
        [self.view addSubview:compassView];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
