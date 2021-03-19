//
//  DiverBiometric m
//  SC4App18
//
//  Created by srivatsa s pobbathi on 10/10/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "DiverBiometricCell.h"

@implementation DiverBiometricCell
@synthesize lblBack,lblName,imgArrow,lblNano,lblEcgSerial,lblTap,btnSerialNo;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        int viewWidth = 704;
        if (IS_IPHONE)
        {
            viewWidth = DEVICE_WIDTH;
        }
        self.backgroundColor = [UIColor clearColor];
        
        lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewWidth,60)];
        lblBack.backgroundColor = [UIColor blackColor];
        lblBack.alpha = 0.5;
        [self.contentView addSubview:lblBack];
    
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0,150,30)];
        [lblName setTextColor:[UIColor whiteColor]];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setTextAlignment:NSTextAlignmentLeft];
        lblName.text = @"Sri";
        [lblName setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [self.contentView addSubview:lblName];
        
        
        lblNano = [[UILabel alloc] initWithFrame:CGRectMake(50, 30,150,30)];
        [lblNano setTextColor:[UIColor whiteColor]];
        [lblNano setBackgroundColor:[UIColor clearColor]];
        [lblNano setTextAlignment:NSTextAlignmentLeft];
        lblNano.text = @"nano id";
        [lblNano setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [self.contentView addSubview:lblNano];
        
        
        lblEcgSerial = [[UILabel alloc] initWithFrame:CGRectMake(50, 0,150,60 )];
        [lblEcgSerial setTextColor:[UIColor whiteColor]];
        [lblEcgSerial setBackgroundColor:[UIColor clearColor]];
        [lblEcgSerial setTextAlignment:NSTextAlignmentLeft];
        lblEcgSerial.text = @"ECG Serial No : NA";
        [lblEcgSerial setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [self.contentView addSubview:lblEcgSerial];
        
        lblTap = [[UILabel alloc] initWithFrame:CGRectMake(50, 45,150,15)];
        [lblTap setTextColor:[UIColor grayColor]];
        [lblTap setBackgroundColor:[UIColor clearColor]];
        [lblEcgSerial setTextAlignment:NSTextAlignmentLeft];
        lblTap.text = @"(Tap Here To Change)";
        [lblTap setFont:[UIFont fontWithName:CGRegularItalic size:textSize-4]];
        [self.contentView addSubview:lblTap];
        
        btnSerialNo = [[UIButton alloc]init];
        btnSerialNo.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:btnSerialNo];
        
        imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-30, 20, 20, 20)];
        imgArrow.image = [UIImage imageNamed:@"white_arrow.png"];
        [imgArrow setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:imgArrow];
        
        int height = 60;
        if (IS_IPHONE)
        {
            height = 50;
        }

        if (IS_IPAD)
        {
            viewWidth = 704;
           
            [lblName setFrame:CGRectMake(50, 0,viewWidth-50,60)];
            [imgArrow setFrame:CGRectMake(viewWidth-20, 27.5, 15, 15)];
            
             lblName.frame = CGRectMake(20, 5, 150, 25);
             lblNano.frame =  CGRectMake(20, 30,150,25);
             lblEcgSerial.frame =  CGRectMake(20+200, 0, 450, 60);
             lblTap.frame =  CGRectMake(20+200, 30, 450, 20);
             btnSerialNo.frame = CGRectMake(20+200, 0, 150, height);
            imgArrow.frame = CGRectMake(lblBack.frame.size.width-70, (height-20)/2, 12, 20);


        }
        else
        {
            lblBack.frame = CGRectMake(0, 0,DEVICE_WIDTH,50);
            [lblName setFrame:CGRectMake(40, 0,viewWidth-50,50)];
            [imgArrow setFrame:CGRectMake(viewWidth-20, 17.5, 15, 15)];
        }
        
        
    }
    return self;
}
@end
