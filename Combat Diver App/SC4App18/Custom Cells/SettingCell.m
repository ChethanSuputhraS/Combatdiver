//
//  SettingCell.m
//  SC4App18
//
//  Created by stuart watts on 12/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell
@synthesize lblBack,lblValue,lblName,imgIcon,imgArrow,btrySlider;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH,60)];
        lblBack.backgroundColor = [UIColor blackColor];
        lblBack.alpha = 0.5;
        lblBack.hidden = YES;
        [self.contentView addSubview:lblBack];
        
        imgIcon = [[UIImageView alloc] init];
        imgIcon.frame = CGRectMake(10, 20, 20, 20);
        [imgIcon setImage:[UIImage imageNamed:@"profile_1.jpg"]];
        [imgIcon setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:imgIcon];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 10,DEVICE_WIDTH-60,24)];
        [lblName setTextColor:[UIColor whiteColor]];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setTextAlignment:NSTextAlignmentLeft];
        [lblName setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [self.contentView addSubview:lblName];
        
        imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-30, 20, 20, 20)];
        imgArrow.image = [UIImage imageNamed:@"arrow.png"];
        [imgArrow setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:imgArrow];
        
        lblValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, DEVICE_WIDTH, 0.5)];
        [lblValue setBackgroundColor:[UIColor whiteColor]];
        lblValue.textColor = [UIColor blackColor];
        lblValue.text=@"20";
        [lblName setFont:[UIFont fontWithName:CGBold size:textSize]];
        [self.contentView addSubview:lblValue];
        
        btrySlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 40,DEVICE_WIDTH,1)];
        btrySlider.minimumValue = 0;
        btrySlider.maximumValue = 100;
        btrySlider.continuous = true;
        btrySlider.value = 20;
        btrySlider.minimumTrackTintColor = [UIColor whiteColor];
        btrySlider.maximumTrackTintColor = [UIColor grayColor];
        [self.contentView addSubview:btrySlider];
        btrySlider.hidden=YES;
        
        lblValue.layer.masksToBounds = YES;
        lblValue.layer.borderWidth = 4;
        lblValue.layer.cornerRadius = 25;

        lblValue.textAlignment = NSTextAlignmentCenter;
        lblValue.layer.borderColor = [UIColor whiteColor].CGColor;
        
        int viewWidth = DEVICE_WIDTH;
        if (IS_IPAD)
        {
            viewWidth = 704;
            lblValue.frame = CGRectMake(0, 59.5, viewWidth,0.5);
            [lblName setFrame:CGRectMake(50, 0,viewWidth-50,60)];
            [imgArrow setFrame:CGRectMake(viewWidth-20, 27.5, 15, 15)];
            [imgIcon setFrame:CGRectMake(10, 25, 20, 20)];
        }
        else
        {
            lblBack.frame = CGRectMake(0, 0,DEVICE_WIDTH,50);
            lblValue.frame = CGRectMake(0, 49.5, viewWidth, 0.5);
            [lblName setFrame:CGRectMake(40, 0,viewWidth-50,50)];
            [imgArrow setFrame:CGRectMake(viewWidth-20, 17.5, 15, 15)];
            [imgIcon setFrame:CGRectMake(10, 15, 20, 20)];
        }
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
