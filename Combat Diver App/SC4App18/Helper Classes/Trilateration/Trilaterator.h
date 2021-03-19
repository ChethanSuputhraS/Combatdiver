//
//  Trilaterator.h
//  
//
//  Created by Kalpesh Panchasara on 06/12/19.
//  Copyright © 2019 Kalpesh Panchasara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Location.h"

@interface Trilaterator : NSObject

- (void)trilaterate:(NSMutableArray *)arrayLocation
            success:(void (^)(Location *location))success
            failure:(void (^)(NSError *error))failure;

@end
