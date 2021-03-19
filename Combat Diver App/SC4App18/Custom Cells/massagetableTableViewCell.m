//
//  massagetableTableViewCell.m
//  Elite Operator
//
//  Created by One Click IT Consultancy  on 3/19/15.
//  Copyright (c) 2015 One Click IT Consultancy . All rights reserved.
//

#import "massagetableTableViewCell.h"
#import "Constant.h"
@implementation massagetableTableViewCell
@synthesize lblname;
@synthesize imgprof;
@synthesize lbldiviceid;
@synthesize lastMsg;
@synthesize timeLbl,img;
@synthesize checkmarkImg;
@synthesize btnConnect,lblBack;
- (void)awakeFromNib {
    
    
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code

        self.backgroundColor = [UIColor clearColor];
        
        imgprof=[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 51, 44)];
        [imgprof.layer setBorderColor: [[UIColor blackColor] CGColor]];
        imgprof.image=[UIImage imageNamed:@"user"];
        [imgprof.layer setMasksToBounds:YES];
        
        lblname = [[UILabel alloc] initWithFrame:CGRectMake(80,5, 200, 25)];
        [lblname setTextColor:[UIColor whiteColor]];
        [lblname setBackgroundColor:[UIColor clearColor]];
        [lblname setTextAlignment:NSTextAlignmentLeft];
        lblname.font=[UIFont systemFontOfSize:15.0];
        lblname.font=[UIFont boldSystemFontOfSize:15.0];

        lbldiviceid=[[UILabel alloc]initWithFrame:CGRectMake(80, 25, 200, 25)];
        lbldiviceid.text=@"Device ID:1234";
        lbldiviceid.font=[UIFont systemFontOfSize:15.0];
        lbldiviceid.textColor=[UIColor grayColor];
        lbldiviceid.font=[UIFont boldSystemFontOfSize:15.0];

        lastMsg =[[UILabel alloc] initWithFrame:CGRectMake(80, 45, 190, 25)];
        lastMsg.backgroundColor=[UIColor clearColor];
        lastMsg.textColor=[UIColor whiteColor];
        lastMsg.font=[UIFont systemFontOfSize:10.0];
        lastMsg.text=@"hey Everything is good.";
        
        timeLbl =[[UILabel alloc] initWithFrame:CGRectMake(260, 45, 190, 25)];
        timeLbl.backgroundColor=[UIColor clearColor];
        timeLbl.textColor=[UIColor whiteColor];
        timeLbl.font=[UIFont systemFontOfSize:10.0];
        timeLbl.text=@"2 min ago.";
        timeLbl.textAlignment = NSTextAlignmentRight;
        
        //------------jam04-04-2015----------//
        checkmarkImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 10, 20, 20)];
        [checkmarkImg setTag:0];
        checkmarkImg.backgroundColor = [UIColor clearColor];
        checkmarkImg.image = [UIImage imageNamed:@""];
        
        btnConnect =[UIButton buttonWithType:UIButtonTypeCustom];
        btnConnect.frame = CGRectMake(550, 20, 130, 50);
        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        [btnConnect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnConnect.layer.borderColor =[UIColor whiteColor].CGColor;
        btnConnect.layer.borderWidth =1;
        btnConnect.layer.cornerRadius = 4;
        btnConnect.layer.masksToBounds = YES;
        btnConnect.hidden =YES;
        
        if(IS_IPAD)
        {
            img =[[UIImageView alloc] init];
            img.image=[UIImage imageNamed:@"cell_ipad"];
            img.frame=CGRectMake(0, 10, 700, 112);
            
            imgprof.frame=CGRectMake(48, 34, 73, 64);
            lblname.frame=CGRectMake(190,19, 200, 25);
            lbldiviceid.frame=CGRectMake(190,42, 200, 25);
            lastMsg.frame=CGRectMake(190, 80, 270, 25);
            timeLbl.frame=CGRectMake(470-20,70, 230, 50);
            self.contentView.frame=CGRectMake(0, 0, 673, 112);
            [self.contentView addSubview:img];
            
            [self.contentView addSubview:imgprof];
            [self.contentView addSubview:lblname];
            [self.contentView addSubview:lbldiviceid];
            [self.contentView addSubview:lastMsg];
            [self.contentView addSubview:timeLbl];
            [self.contentView addSubview:checkmarkImg];//KP
            [self.contentView addSubview:btnConnect];//KP

            lblname.font=[UIFont systemFontOfSize:18.0];
            lblname.font=[UIFont boldSystemFontOfSize:18.0];
            lbldiviceid.font=[UIFont systemFontOfSize:18.0];
            lbldiviceid.font=[UIFont boldSystemFontOfSize:18.0];
            lastMsg.font=[UIFont systemFontOfSize:15.0];
            timeLbl.font=[UIFont systemFontOfSize:13.0];
        }
        else
        {
            self.contentView.frame=CGRectMake(0, 0, DEVICE_WIDTH, 70);
            
            lblBack =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 60)];
            lblBack.backgroundColor=[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
            [self.contentView addSubview:lblBack];

            img =[[UIImageView alloc] init];
//            img.image=[UIImage imageNamed:@"cell_ipad"];
            img.frame=CGRectMake(0, 0, 67, 60);
            img.backgroundColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1.0];
            [self.contentView addSubview:img];

            imgprof.frame=CGRectMake(8, 8, 51, 44);
            lblname.frame=CGRectMake(80,5, 200, 20);
            lbldiviceid.frame=CGRectMake(80,30, 200, 20);
            lastMsg.frame=CGRectMake(80,45, 250, 20);
            timeLbl.frame=CGRectMake(DEVICE_WIDTH-90,45, 80, 20);
            
            btnConnect.frame = CGRectMake(DEVICE_WIDTH-90, 10, 80, 35);

            timeLbl.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:imgprof];
            [self.contentView addSubview:lblname];
            [self.contentView addSubview:lbldiviceid];
            [self.contentView addSubview:lastMsg];
            [self.contentView addSubview:timeLbl];
            [self.contentView addSubview:checkmarkImg];//KP
            [self.contentView addSubview:btnConnect];//KP
            btnConnect.titleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
