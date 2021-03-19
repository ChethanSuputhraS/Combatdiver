//
//  Location.m
//  
//
//  Created by Kalpesh Panchasara on 06/12/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinates
                           altitude:(CLLocationDistance)altitude
{
    if (self = [super init]) {
        _coordinates = coordinates;
        _altitude = altitude;
    }
    return self;
}

@end
