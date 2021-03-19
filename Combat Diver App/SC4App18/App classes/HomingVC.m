//
//  HomingVC.m
//  SC4App18
//
//  Created by srivatsa s pobbathi on 06/09/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "HomingVC.h"

@interface HomingVC ()
{
    int headerhHeight,viewWidth;
}
@end

@implementation HomingVC

- (void)viewDidLoad {
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
    [lblTitle setText:@"Homing Mode"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGBold size:textSize+4]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    
    if (IS_IPHONE)
    {
        UIImageView * imgMenu = [[UIImageView alloc] init];
        imgMenu.frame = CGRectMake(10, 20+13.5, 24, 17);
        imgMenu.image = [UIImage imageNamed:@"menu_icon.png"];
        [self.view addSubview:imgMenu];
        
        UIButton * btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerhHeight, headerhHeight)];
        [btnMenu setBackgroundColor:[UIColor clearColor]];
        [btnMenu addTarget:self action:@selector(btnLeftMenuClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnMenu];
        
        if (IS_IPHONE_X)
        {
            viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
            lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
            imgMenu.frame = CGRectMake(10, 13.5+44, 24, 17);
            btnMenu.frame = CGRectMake(0, 0, 70, 88);
        }
    }
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)btnLeftMenuClicked
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
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
