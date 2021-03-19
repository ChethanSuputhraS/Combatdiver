//
//  massagetableTableViewCell.h
//  Elite Operator
//
//  Created by One Click IT Consultancy  on 3/19/15.
//  Copyright (c) 2015 One Click IT Consultancy . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface massagetableTableViewCell : UITableViewCell
{
//    UIImageView *imgprof;
//    UILabel *lblname;
//    UILabel *lbldiviceid;
    
}
@property (nonatomic,retain) UIImageView *imgprof;
@property (nonatomic,retain) UILabel *lblname;
@property (nonatomic,retain) UILabel *lbldiviceid;
@property (nonatomic,retain) UILabel * lastMsg ;
@property (nonatomic,retain) UILabel * timeLbl;
@property (nonatomic,retain) UIImageView * img;
@property (nonatomic,retain) UIImageView * checkmarkImg;
@property (nonatomic,retain) UIButton * btnConnect;
@property (nonatomic,retain) UILabel * lblBack;


@end
