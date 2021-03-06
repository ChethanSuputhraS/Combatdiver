/*
 
 The MIT License (MIT)
 
 Copyright (c) 2015 ABM Adnan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CMPopTipView.h"
#import "Arcs.h"
#import "Radar.h"
#import "Dot.h"
#import "AMPopTip.h"
#import "NSMutableAttributedString+KpCategoryString.h"
#import "GeoPointCompass.h"
#import "MFSideMenu.h"
@interface RadarViewController : UIViewController <CLLocationManagerDelegate,CMPopTipViewDelegate>
{
    UIView *radarViewHolder;
    UIView *radarLine;
    UISlider *distanceSlider;
    Arcs *arcsView;
    Radar *radarView;
    float currentDeviceBearing;
    NSMutableArray *dots;
    NSArray *nearbyUsers;
    NSTimer *detectCollisionTimer;
    UIImageView * radarImg;
    
    UIView * topView;
    UIImageView *   shipImg;
    UILabel * namelbl;
    UILabel * distanceLbl;
    UIButton * btnSendMsg;
    UILabel * lblDirection;
    UILabel * lblDepth;
    NSMutableArray * filteredContacts;
    NSInteger selectedIndex;
    GeoPointCompass *geoPointCompass;
    int  headerhHeight, viewWidth;
}
@property (nonatomic, retain) CLLocationManager *locManager;

@end

