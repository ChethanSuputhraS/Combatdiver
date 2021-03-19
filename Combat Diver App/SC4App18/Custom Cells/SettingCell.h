//
//  SettingCell.h
//  SC4App18
//
//  Created by stuart watts on 12/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property(nonatomic,strong) UILabel * lblBack;
@property(nonatomic,strong) UIImageView * imgArrow;
@property(nonatomic,strong) UIImageView * imgIcon;
@property(nonatomic,strong) UILabel * lblName;
@property(nonatomic,strong) UILabel * lblValue;
@property(nonatomic,strong) UISlider * btrySlider;

@end
