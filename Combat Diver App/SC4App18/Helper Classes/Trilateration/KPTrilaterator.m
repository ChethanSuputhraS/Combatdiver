//
//  KPTrilaterator.m
//  SC4App18
//
//  Created by stuart watts on 08/01/2020.
//  Copyright © 2020 Kalpesh Panchasara. All rights reserved.
//

#import "KPTrilaterator.h"
#define TORAD    ((double)M_PI/180)        //multiplier to convert from degrees to radians
#define TODEG    ((double)180/M_PI)        //multiplier to convert from radians to degrees
#define REQ        ((double)6378137)                    //equatorial radius in m for WGS84 model
#define FLAT    ((double)1/298.257223563)            //flattening for WGS84 model
#define NO_OF_PINGS    3                    //number of transponders/positions for LBL calculation

typedef struct {
    double Lat;            //latitude in degrees
    double Lon;            //longitude in degrees
    double Alt;            //Altitude in m (above sea level, or -ve for depth)
    double R;            //Range to Transponder in m
} PingLL;                //Transponder ping type with Lat Lon coordinates

typedef struct {
    double x;            //x coordinate (aligned North)
    double y;            //y coordinate
    double z;            //z coordinate = alt (-depth)
    double d;            //horizontal distance from origin in m
    double a;            //angle
    double R;            //Range to Transponder in m
} PingC;                //Transponder Ping with cartesian coordinates

@implementation KPTrilaterator

-(NSMutableArray *)compute:(NSMutableArray *)arrlocation
{
    if ([arrlocation count] >= 3)
    {
        PingC PC[3],TempPC;
        
        // three locations
        CLLocation * loc1 = [[arrlocation objectAtIndex:0] objectForKey:@"location"];
        CLLocation * loc2 = [[arrlocation objectAtIndex:1] objectForKey:@"location"];
        CLLocation * loc3 = [[arrlocation objectAtIndex:2] objectForKey:@"location"];
        
        CGFloat lat1 = loc1.coordinate.latitude;
        CGFloat lon1 = loc1.coordinate.longitude;
        CGFloat dist1 = [[[arrlocation objectAtIndex:0] objectForKey:@"distance"] floatValue];
        
        CGFloat lat2 = loc2.coordinate.latitude;
        CGFloat lon2 = loc2.coordinate.longitude;
        CGFloat dist2 = [[[arrlocation objectAtIndex:1] objectForKey:@"distance"] floatValue];
        
        CGFloat lat3 = loc3.coordinate.latitude;
        CGFloat lon3 = loc3.coordinate.longitude;
        CGFloat dist3 = [[[arrlocation objectAtIndex:2] objectForKey:@"distance"] floatValue];
        
        double Org_Lat = (lat1 + lat2 + lat3) / 3;    //set an origin at geometric centre of LBL array
        double Org_Lon = (lon1 + lon2 + lon3) / 3;
        double Rn = REQ / sqrt(1 - (2 * FLAT - FLAT*FLAT)*(pow(sin(Org_Lat*TORAD),2)));                //Calculate radii
        double Rm = Rn * (1 - (2 * FLAT - FLAT*FLAT)) / (1 - (2 * FLAT - FLAT*FLAT)*(pow(sin(Org_Lat*TORAD),2)));
        
        for (int i = 0; i < 3; i++)            //calculate cartesian positions for pings
        {
            CLLocation * loc = [[arrlocation objectAtIndex:i] objectForKey:@"location"];
            CGFloat lat = loc.coordinate.latitude;
            CGFloat lon = loc.coordinate.longitude;
            CGFloat dist = [[[arrlocation objectAtIndex:i] objectForKey:@"distance"] floatValue];
            
            PC[i].x = ((lat - Org_Lat)*TORAD) / atan((double)1 / Rm);                //calculate P1 cartesian coordinates relative to origin
            PC[i].y = ((lon - Org_Lon)*TORAD) / atan((double)1 / (Rn*cos(Org_Lat*TORAD)));
            PC[i].z = 0;
            PC[i].R = dist;                //copy range to transponder
            PC[i].d = sqrt(PC[i].x*PC[i].x + PC[i].y*PC[i].y);        //calculate distance to origin
            PC[i].a = atan2(PC[i].x, PC[i].y);                        //calculate angle
        }
        
        //reorder from smallest angle to biggest using bubble sort (aligns with reference frame for trilateration)
        for (int i = 0; i < 2; i++)
        {
            if (PC[1].a < PC[0].a)
            {
                TempPC = PC[0];
                PC[0] = PC[1];
                PC[1] = TempPC;
            }
            if (PC[2].a < PC[1].a)
            {
                TempPC = PC[1];
                PC[1] = PC[2];
                PC[2] = TempPC;
            }
        }
        
        //calculate baselines
        double P1toP2x = PC[0].x - PC[1].x;
        double P1toP2y = PC[0].y - PC[1].y;
        double P1toP2d = sqrt(P1toP2x * P1toP2x + P1toP2y * P1toP2y);
        double P1toP3x = PC[0].x - PC[2].x;
        double P1toP3y = PC[0].y - PC[2].y;
        double P1toP3d = sqrt(P1toP3x * P1toP3x + P1toP3y * P1toP3y);
        double P2toP3x = PC[1].x - PC[2].x;
        double P2toP3y = PC[1].y - PC[2].y;
        double P2toP3d = sqrt(P2toP3x * P2toP3x + P2toP3y * P2toP3y);
        double Rot = M_PI / 2 - atan(P1toP2y / P1toP2x);        //rotation angle
        
        //angle to calculate YaxisToP3 and XaxisToP3
        double Angle = acos((P1toP3d*P1toP3d + P1toP2d*P1toP2d - P2toP3d*P2toP3d) / (2 * P1toP3d * P1toP2d));
        double YaxisToP3 = P1toP3d * cos(Angle); // distance in the x axis between the (0,0) coordinate and the third fixed point
        double XaxisToP3 = P1toP3d * sin(Angle); // distance between the x axis and the third fixed point
        
        //Estimating position with direct method - in the referential frame
        double x_est = (PC[0].R*PC[0].R - PC[1].R*PC[1].R + P1toP2d*P1toP2d) / (2 * P1toP2d);
        double y_est = ((PC[0].R*PC[0].R - PC[2].R*PC[2].R + YaxisToP3 * YaxisToP3 + XaxisToP3 * XaxisToP3) - (2 * YaxisToP3 * x_est)) / (2 * XaxisToP3);
        double xy = sqrt(x_est*x_est + y_est*y_est);
        double z_est = sqrt(fabs(PC[0].R*PC[0].R - xy*xy));
        
        //Rotate anticlockwise by Rot
        double x = x_est * cos(Rot) - y_est * sin(Rot);
        double y = x_est * sin(Rot) + y_est * cos(Rot);
        double z = z_est;
        
        //Translate
        x = x + PC[0].y;
        y = y + PC[0].x;
        
        //Convert back to lat and lon coordinates and return
        double Lat = y * atan((double)1 / Rm) * TODEG + Org_Lat;
        double Lon = x * atan((double)1 / (Rn*cos(Org_Lat*TORAD))) * TODEG + Org_Lon;
        double Alt = -z;
        NSLog(@"lat=%f long=%f",Lat,Lon);
        NSMutableArray * i = [[NSMutableArray alloc] init];
        [i addObject:[NSNumber numberWithDouble:Lat]];
        [i addObject:[NSNumber numberWithDouble:Lon]];
        NSLog(@"after Arrat=%@",i);
        
        return i;
    }
    return [NSMutableArray new];
}
-(double)A:(double)a
{
    return a*7.2;
}

-(double)B:(double)a
{
    return a/900000;
}

-(NSMutableArray *)C:(double)a :(double)b :(double)c :(double)d
{
    double aOut = a*cos((M_PI/180)*d)-b*sin((M_PI/180)*d);
    double bOut = a*sin((M_PI/180)*d)+b*cos((M_PI/180)*d);
    double cOut = c;
    NSMutableArray * arrOut = [[NSMutableArray alloc] init];
    [arrOut addObject:[NSNumber numberWithDouble:aOut]];
    [arrOut addObject:[NSNumber numberWithDouble:bOut]];
    [arrOut addObject:[NSNumber numberWithDouble:cOut]];
    return arrOut;
}

-(double)D:(double)a
{
    return 730.24198315+52.33325511*a+1.35152407*pow(a,2)+0.01481265*pow(a,3)+0.00005900*pow(a,4)+0.00541703*180;
}

-(double)E:(double)a :(double)b :(double)c :(double)d
{
    double e=M_PI,f=e*a/180,g=e*c/180,h=b-d,i=e*h/180,j=sin(f)*sin(g)+cos(f)*cos(g)*cos(i);
    if(j>1)
    {
        j=1;
    }
    j=acos(j);j=j*180/e;j=j*60*1.1515;j=j*1.609344;
    return j;
}
//lat=43.932286 long=15.446130
//    "43.93228629266951", "15.44612958031284"

@end
