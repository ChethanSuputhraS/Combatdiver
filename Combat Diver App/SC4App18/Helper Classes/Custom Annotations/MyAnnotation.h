//
//  MyAnnotation.h
//  Maps Presentation
//
//  Created by Julian on 07/02/14.
//  Copyright (c) 2014 Julian Król. All rights reserved.
//

@import MapKit;

@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title;

@end
