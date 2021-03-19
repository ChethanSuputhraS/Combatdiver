//
//  LeftMenuVC.h
//  SC4App18
//
//  Created by stuart watts on 17/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * arrContent;
    UITableView * tblContent;
    int viewWidth;
   
}

@end
