//
//  DiverBiometricCell.h
//  SC4App18
//
//  Created by srivatsa s pobbathi on 10/10/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiverBiometricCell : UITableViewCell
{
    
}
@property(nonatomic,strong)UILabel * lblName;
@property(nonatomic,strong)UILabel * lblBack;
@property(nonatomic,strong)UIImageView * imgArrow;
@property(nonatomic,strong)UILabel * lblNano;
@property(nonatomic,strong)UILabel * lblEcgSerial;
@property(nonatomic,strong)UILabel * lblTap;
@property(nonatomic,strong)UIButton * btnSerialNo;

@end

NS_ASSUME_NONNULL_END
