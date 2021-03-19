//
//  Location.h
//  
//
//  Created by Kalpesh Panchasara on 06/12/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D coordinates;
@property (assign, nonatomic) CLLocationDistance altitude;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinates
                        altitude:(CLLocationDistance)altitude;
@end
