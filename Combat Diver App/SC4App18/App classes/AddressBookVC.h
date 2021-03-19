//
//  AddressBookVC.h
//  SC4App18
//
//  Created by stuart watts on 08/05/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    int headerhHeight,viewWidth;
    UITableView * tblView;
    NSMutableArray * arrContacts;
    UIButton * btnSync;
    NSString * strPhoneNo,*strIrridiumID, * strECGSerialNo;
}

@end
