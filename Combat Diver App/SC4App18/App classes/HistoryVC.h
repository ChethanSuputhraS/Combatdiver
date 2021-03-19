//
//  HistoryVC.h
//  SC4App18
//
//  Created by stuart watts on 08/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int viewWidth, headerHeight; int fixedHeight;

    UITableView * tblView;
    NSMutableArray * arrMessages;
    UILabel * lblSent, * lblFailed;

}
@end
