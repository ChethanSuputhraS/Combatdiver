//
//  AddLignlightDevice.h
//  SC4App18
//
//  Created by srivatsa s pobbathi on 06/11/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddLignlightDevice : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int headerhHeight,viewWidth;
    UITableView * tblContent,*tblContact;
    NSMutableArray * arrayLignlightDevices,*contactArr;
    BOOL isConnected;
    NSTimer * timerOut;
    UIView *  viewOverLay, * pickerView;
    UIImageView * backContactView;

}
@end

NS_ASSUME_NONNULL_END
