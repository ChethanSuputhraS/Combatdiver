//
//  ComposeMsgVC.h
//  SC4App18
//
//  Created by stuart watts on 28/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeMsgVC : UIViewController
{
    UITableView * tblView, * tblContact;
    
    NSMutableArray * cannedMsgArr, * contactArr;

    UIView *  viewOverLay, * pickerView, * collectView;
    
    int headerhHeight,viewWidth;
    
    UIImageView * backContactView;

    NSString * sentMsg, * sentIndex, * sentUserName, * sentUserNano;
}
@end
