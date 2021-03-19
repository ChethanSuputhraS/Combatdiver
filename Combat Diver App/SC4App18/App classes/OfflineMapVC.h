//
//  OfflineMapVC.h
//  SC4App18
//
//  Created by stuart watts on 11/12/2019.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OfflineMapVC : UIViewController<UISearchBarDelegate>
{
    float latValue;
    float longValue;
    UISearchBar *searchBar;
    MKPointAnnotation *annotation2;
    float changedLat;
    float changedLong;
    CLLocationManager *locationManager;

}
@property(nonatomic,strong)NSMutableDictionary * dictGeofenceInfo;
@end

NS_ASSUME_NONNULL_END
