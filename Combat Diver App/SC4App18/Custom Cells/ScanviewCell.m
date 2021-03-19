//
//  ScanviewCell.m
//  SC4App18
//
//  Created by stuart watts on 27/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "ScanviewCell.h"

@implementation ScanviewCell
@synthesize lblname,lblBack;
@synthesize lbldiviceid;
@synthesize lblConnect;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        int viewWidth = 704;
        if (IS_IPAD)
        {
            viewWidth = 704;
        }
        else
        {
            viewWidth = DEVICE_WIDTH;
        }
        self.backgroundColor = [UIColor clearColor];
        
        lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH,70)];
        lblBack.backgroundColor = [UIColor blackColor];
        lblBack.alpha = 0.4;
        lblBack.userInteractionEnabled = YES;
        [self.contentView addSubview:lblBack];
        
        lblname = [[UILabel alloc] initWithFrame:CGRectMake(40,10, 200, 35)];
        [lblname setTextColor:[UIColor whiteColor]];
        [lblname setBackgroundColor:[UIColor clearColor]];
        [lblname setTextAlignment:NSTextAlignmentLeft];
        lblname.font=[UIFont fontWithName:CGBold size:textSize+1];
        lblname.text = @"Device 123";
        [self.contentView addSubview:lblname];

        lbldiviceid=[[UILabel alloc]initWithFrame:CGRectMake(40,35, 200, 35)];
        lbldiviceid.text=@"Device ID:1234";
        lbldiviceid.textColor=[UIColor lightGrayColor];
        lbldiviceid.font=[UIFont fontWithName:CGRegular size:textSize];
        [self.contentView addSubview:lbldiviceid];

        lblConnect=[[UILabel alloc]initWithFrame:CGRectMake(viewWidth-180,00, 100, 70)];
        lblConnect.text=@"Connect";
        lblConnect.textColor=[UIColor whiteColor];
        lblConnect.font=[UIFont fontWithName:CGRegular size:textSize+1];
        lblConnect.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblConnect];

        
        if(IS_IPAD)
        {
            
        }
        else
        {
            lblConnect.frame = CGRectMake(viewWidth-110,00, 100, 70);
            lblConnect.font=[UIFont fontWithName:CGRegular size:textSize-1];
            lblname.frame = CGRectMake(20,10, 200, 35);
            lbldiviceid.frame = CGRectMake(20,35, 200, 35);


        }
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
