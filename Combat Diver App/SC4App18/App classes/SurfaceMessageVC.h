//
//  SurfaceMessageVC.h
//  SC4App18
//
//  Created by stuart watts on 07/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurfaceMessageVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int headerhHeight,viewWidth;
    UITableView * tblView;
    NSMutableArray * arrMessages;
    UIButton * btnSync;
}
@end
