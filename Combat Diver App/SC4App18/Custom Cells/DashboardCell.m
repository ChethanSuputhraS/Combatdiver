//
//  DashboardCell.m
//  SC4App18
//
//  Created by stuart watts on 18/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "DashboardCell.h"
#import "UICircularSlider.h"

@implementation DashboardCell
@synthesize lblname;
@synthesize imgprof;
@synthesize lbldiviceid;
@synthesize lastMsg;
@synthesize timeLbl;
@synthesize lblBack;
@synthesize btnConnect,slider,imgBtry,lblAirValue,lblLine,lblContact,imgDistance,imgHR,imgTemp,lblDistance,lblHR,lblTemp,lblAir;
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        int viewWidth = DEVICE_WIDTH;
        if (IS_IPAD)
        {
            viewWidth = 704;
        }
        
        lblBack = [[UILabel alloc] initWithFrame:CGRectMake(20, 10,viewWidth-40,105)];
        lblBack.backgroundColor = [UIColor blackColor];
        lblBack.alpha = 0.4;
        [self.contentView addSubview:lblBack];
        
        int yy = 10;
        
        imgprof=[[UIImageView alloc]initWithFrame:CGRectMake(20+20, 10+17.5 , 73, 70)];
        [imgprof.layer setBorderColor: [[UIColor blackColor] CGColor]];
        imgprof.image=[UIImage imageNamed:@"diver_default.png"];
        [imgprof.layer setMasksToBounds:YES];
        [self.contentView addSubview:imgprof];
        
        lblname = [[UILabel alloc] initWithFrame:CGRectMake(115+20,yy+25, 130, 25)];
        [lblname setTextColor:[UIColor whiteColor]];
        [lblname setBackgroundColor:[UIColor clearColor]];
        [lblname setTextAlignment:NSTextAlignmentLeft];
        lblname.font=[UIFont fontWithName:CGBold size:textSize+3];
        lblname.text = @"Diver 1";
        [self.contentView addSubview:lblname];
//        srivatsa november
        imgHR=[[UIImageView alloc]initWithFrame:CGRectMake(lblname.frame.origin.x+lblname.frame.size.width+20,20, 27, 27)];
        imgHR.image=[UIImage imageNamed:@"hr.png"];
        imgHR.hidden = true;
        [imgHR.layer setMasksToBounds:YES];
        [self.contentView addSubview:imgHR];
        
        lblHR =[[UILabel alloc] initWithFrame:CGRectMake(lblname.frame.origin.x+lblname.frame.size.width-1,50, 70, 30)];
        lblHR.backgroundColor=[UIColor clearColor];
        lblHR.textColor=[UIColor whiteColor];
        lblHR.font=[UIFont fontWithName:CGRegular size:textSize-1];
        lblHR.text=@"--";
        lblHR.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lblHR];
        
        imgDistance=[[UIImageView alloc]initWithFrame:CGRectMake(imgHR.frame.origin.x+imgHR.frame.size.width+70, 21, 27, 27)];
        imgDistance.image=[UIImage imageNamed:@"distance.png"];
        [imgDistance.layer setMasksToBounds:YES];
        imgDistance.hidden = true;
        [self.contentView addSubview:imgDistance];
        
        lblDistance =[[UILabel alloc] initWithFrame:CGRectMake(imgDistance.frame.origin.x-38,50, 100, 30)];
        lblDistance.backgroundColor=[UIColor clearColor];
        lblDistance.textColor=[UIColor whiteColor];
        lblDistance.font=[UIFont fontWithName:CGRegular size:textSize-2];
        lblDistance.text=@"--";
        lblDistance.numberOfLines = 0;
        lblDistance.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lblDistance];

        imgTemp=[[UIImageView alloc]initWithFrame:CGRectMake(imgDistance.frame.origin.x+imgDistance.frame.size.width+70, 21, 25, 25)];
        imgTemp.image=[UIImage imageNamed:@"temp.png"];
        [imgTemp.layer setMasksToBounds:YES];
        imgTemp.hidden = true;
        [self.contentView addSubview:imgTemp];
        
        lblTemp =[[UILabel alloc] initWithFrame:CGRectMake(imgTemp.frame.origin.x-21,50, 70, 30)];
        lblTemp.backgroundColor=[UIColor clearColor];
        lblTemp.textAlignment = NSTextAlignmentCenter;
        lblTemp.textColor=[UIColor whiteColor];
        lblTemp.font=[UIFont fontWithName:CGRegular size:textSize-1];
        lblTemp.text=@"--";
        [self.contentView addSubview:lblTemp];
        
        lbldiviceid=[[UILabel alloc]initWithFrame:CGRectMake(115+20+140,yy+12, 270, 25)];
        lbldiviceid.text=@"Device ID:1234";
        lbldiviceid.textColor=[UIColor lightGrayColor];
        lbldiviceid.font=[UIFont fontWithName:CGRegular size:textSize+1];
        [self.contentView addSubview:lbldiviceid];
        
        lastMsg =[[UILabel alloc] initWithFrame:CGRectMake(40, yy+74, viewWidth-180, 25)];
        lastMsg.backgroundColor=[UIColor clearColor];
        lastMsg.textColor=[UIColor lightGrayColor];
        lastMsg.font=[UIFont fontWithName:CGRegular size:textSize-2];
        lastMsg.text=@"Last Message : hey Everything is good";
        [self.contentView addSubview:lastMsg];
        
//        timeLbl =[[UILabel alloc] initWithFrame:CGRectMake(lastMsg.frame.origin.x+lastMsg.frame.size.width+10, yy+44, 200, 80)];
//        timeLbl.backgroundColor=[UIColor clearColor];
//        timeLbl.textColor=[UIColor whiteColor];
//        timeLbl.font=[UIFont fontWithName:CGRegular size:textSize-1];
//        timeLbl.text=@"2 min ago";
//        timeLbl.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:timeLbl];
        
        lblLine = [[UILabel alloc] init];
        lblLine.frame = CGRectMake(viewWidth-15-20-180-10, 20, 0.6, 85);
        lblLine.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:lblLine];
        
        btnConnect =[UIButton buttonWithType:UIButtonTypeCustom];
        btnConnect.frame = CGRectMake(550, 22, 130, 50);
        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        [btnConnect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnConnect.layer.borderColor =[UIColor whiteColor].CGColor;
        btnConnect.layer.borderWidth =1;
        btnConnect.layer.cornerRadius = 4;
        btnConnect.layer.masksToBounds = YES;
        btnConnect.hidden =YES;
        //        [self.contentView addSubview:btnConnect];
        
        imgBtry = [[UIImageView alloc] init];
        imgBtry.frame = CGRectMake(viewWidth-15-20-80, 10+12.5, 80, 80);
        imgBtry.image = [UIImage imageNamed:@"red_warning.png"];
        [self.contentView addSubview:imgBtry];
        
        lblAirValue = [[UILabel alloc] init];
        lblAirValue.text = @"20%";
        lblAirValue.font = [UIFont fontWithName:CGRegular size:textSize+2];
        lblAirValue.textAlignment = NSTextAlignmentCenter;
        lblAirValue.frame  = CGRectMake(0, 0, 80, 50);
        lblAirValue.textColor = [UIColor whiteColor];
        lblAirValue.backgroundColor = UIColor.clearColor;
        lblAirValue.numberOfLines=0;
        [imgBtry addSubview:lblAirValue];
        
        lblAir = [[UILabel alloc] init];
        lblAir.text = @"Air";
        lblAir.font = [UIFont fontWithName:CGRegular size:textSize-2];
        lblAir.textAlignment = NSTextAlignmentCenter;
        lblAir.frame  = CGRectMake(0, 45, 80, 30);
        lblAir.textColor = [UIColor whiteColor];
        lblAir.backgroundColor = UIColor.clearColor;
        [imgBtry addSubview:lblAir];
        
        lblContact = [[UILabel alloc] initWithFrame:CGRectMake(115+20,yy+42, 300, 25)];
        [lblContact setBackgroundColor:[UIColor clearColor]];
        [lblContact setTextAlignment:NSTextAlignmentLeft];
        lblContact.text = @"239238248282222";
        lblContact.hidden = true;
        lblContact.textColor=[UIColor lightGrayColor];
        lblContact.font=[UIFont fontWithName:CGRegular size:textSize+1];
        [self.contentView addSubview:lblContact];
        if(IS_IPHONE)
        {
            lblBack.frame = CGRectMake(5,0,viewWidth-10,75);
            imgprof.frame = CGRectMake(5+10,14,50,47);
            lblname.frame = CGRectMake(60,12.5,100,25);
            lblContact.frame = CGRectMake(75,25,viewWidth-50-10-75-5, 25);
            
            
            lbldiviceid.frame = CGRectMake(160,12.5, 90, 25);
            lastMsg.frame = CGRectMake(75, 50, viewWidth-50-5-75, 20);
            imgBtry.frame = CGRectMake(viewWidth-50-10, 12.5, 50, 50);
            lblAirValue.frame  = CGRectMake(0, 0, 50, 40);
            lblAir.frame  = CGRectMake(0, 25, 50, 20);
            
            lblLine.hidden = YES;
            timeLbl.frame = CGRectMake(viewWidth-50-85, 0, 80, 75);
            timeLbl.numberOfLines = 0;
            
            lblname.font=[UIFont fontWithName:CGBold size:textSize+1];
            lbldiviceid.font=[UIFont fontWithName:CGRegular size:textSize-1];
            lblContact.font=[UIFont fontWithName:CGRegular size:textSize-2];
            lastMsg.font=[UIFont fontWithName:CGRegular size:textSize-3];
            lblAirValue.font = [UIFont fontWithName:CGRegular size:textSize];
            lblAir.font = [UIFont fontWithName:CGRegular size:textSize-2];
            timeLbl.font=[UIFont fontWithName:CGRegular size:textSize-4];
            
            
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
