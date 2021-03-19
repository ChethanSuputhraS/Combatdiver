//
//  DeviceStatusVC.h
//  SC4App18
//
//  Created by srivatsa s pobbathi on 06/12/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceStatusVC : UIViewController
{
    UIView * animateView1, * animateView2, * animateView3;
    UILabel * lblHint2Up, * lblHint2Down;
    UILabel * lblHin3Right, * lblHin3Left;
    UILabel * lblOr1, * lblOr2;
    NSTimer * timer1, * timer2;
    UILabel * lblStatus, * lblStatus2, * lblStatus3, * lblDistance, * lblDistance2, *lblDistance3;
    UILabel * lblLatLong1, * lblLatLong2, * lblLatLong3;

}
-(void)GetDistanceofNanoID:(NSMutableDictionary *)dict;
-(void)ShowErrorMessagewithType:(NSString *)strType withNanoID:(NSString *)strNanoID;

@property (nonatomic, strong) NSMutableDictionary * previousDict;
@end

NS_ASSUME_NONNULL_END
