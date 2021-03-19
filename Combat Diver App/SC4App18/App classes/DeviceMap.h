//
//  DeviceMap.h
//  SC4App18
//
//  Created by srivatsa s pobbathi on 09/12/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface DeviceMap : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView*deviceMapView;
    CLLocationManager *locationManager;
    CLLocation* currentLocation;
}

@end

NS_ASSUME_NONNULL_END
