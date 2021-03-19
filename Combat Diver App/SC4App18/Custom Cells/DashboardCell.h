//
//  DashboardCell.h
//  SC4App18
//
//  Created by stuart watts on 18/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICircularSlider.h"

@interface DashboardCell : UITableViewCell

@property (nonatomic,retain) UIImageView * imgprof;
@property (nonatomic,retain) UILabel * lblname;
@property (nonatomic,retain) UILabel * lbldiviceid;
@property (nonatomic,retain) UILabel * lastMsg ;
@property (nonatomic,retain) UILabel * timeLbl;
@property (nonatomic,retain) UILabel * lblBack;
@property (nonatomic,retain) UILabel * lblAirValue;
@property (nonatomic,retain) UIButton * btnConnect;
@property (nonatomic,retain) UICircularSlider * slider;
@property (nonatomic,retain) UIImageView * imgBtry;
@property (nonatomic,retain) UILabel * lblLine;
@property(nonatomic,strong) UILabel * lblContact;
@property (nonatomic,retain) UIImageView * imgDistance;
@property (nonatomic,retain) UIImageView * imgHR;
@property (nonatomic,retain) UIImageView * imgTemp;
@property(nonatomic,strong) UILabel * lblHR;
@property(nonatomic,strong) UILabel * lblDistance;
@property(nonatomic,strong) UILabel * lblTemp;
@property(nonatomic,strong) UILabel * lblAir;


@end
