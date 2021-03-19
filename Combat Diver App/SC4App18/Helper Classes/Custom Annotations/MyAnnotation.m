//
//  MyAnnotation.m
//  Maps Presentation
//
//  Created by Julian on 07/02/14.
//  Copyright (c) 2014 Julian Król. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title {
    self = [super init];
    if(self){
        _coordinate = coordinate;
        _title = title;
    }
    return self;
}

@end
