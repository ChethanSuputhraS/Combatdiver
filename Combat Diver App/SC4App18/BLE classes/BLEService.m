//
//  BLEService.m
//
//
//  Created by Oneclick IT Solution on 7/11/14.
//  Copyright (c) 2014 One Click IT Consultancy Pvt Ltd, Ind. All rights reserved.
//

#import "BLEService.h"
#import "BLEManager.h"

#import "AppDelegate.h"

#import "DataBaseManager.h"

#define TI_KEYFOB_LEVEL_SERVICE_UUID                        0x2A19
#define TI_KEYFOB_BATT_SERVICE_UUID                         0x180F
#define TI_KEYFOB_PROXIMITY_ALERT_WRITE_LEN                 1
#define TI_KEYFOB_PROXIMITY_ALERT_UUID                      0x1802
#define TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID             0x2a06


/*-----HARI--------*/
#define CPTD_SERVICE_UUID_STRING                              @"0000AB00-0100-0800-0008-05F9B34FB000"
#define CPTD_CHARACTERISTIC_COMM_CHAR                         @"0505A101-D102-11E1-9B23-00025B002B2B"
#define CPTD_CHARACTERISTICS_DATA_CHAR                        @"0000AB01-0100-0800-0008-05F9B34FB000"


#define CKPTD_SERVICE_UUID_STRING1                             @"0000AB00-0100-0800-0008-05F9B34FB000"
#define CKPTD_CHARACTERISTICS_DATA_CHAR1                       @"0000AB01-0100-0800-0008-05F9B34FB000"

#define CKPTD_SERVICE_UUID_STRING2                             @"0000AB00-0100-0800-0008-05F9B34FB000"
#define CKPTD_CHARACTERISTICS_DATA_CHAR2                       @"0000AB02-0100-0800-0008-05F9B34FB000"

#define CKPTD_SERVICE_UUID_STRING3                             @"0000AB00-0100-0800-0008-05F9B34FB000"
#define CKPTD_CHARACTERISTICS_DATA_CHAR3                       @"0000AB03-0100-0800-0008-05F9B34FB000"

#define CKPTD_SERVICE_UUID_STRING4                             @"0000AB00-0100-0800-0008-05F9B34FB000"
#define CKPTD_CHARACTERISTICS_DATA_CHAR4                       @"0000ab04-0100-0800-0008-05F9B34FB000"

static BLEService	*sharedInstance	= nil;

@interface BLEService ()<CBPeripheralDelegate,AVAudioPlayerDelegate>
{
    NSMutableArray *assignedDevices;
    AVAudioPlayer *songAlarmPlayer1;
    BOOL isCannedMsg;
}
@property (nonatomic, strong) CBPeripheral *servicePeripheral;
@property (nonatomic,strong) NSMutableArray *servicesArray;
@end

@implementation BLEService
@synthesize servicePeripheral;

#pragma mark- Self Class Methods
-(id)init{
    self = [super init];
    if (self) {
        //do additional work
    }
    return self;
}

+ (instancetype)sharedInstance
{
    if (!sharedInstance)
        sharedInstance = [[BLEService alloc] init];
    
    return sharedInstance;
}

-(id)initWithDevice:(CBPeripheral*)device andDelegate:(id /*<BLEServiceDelegate>*/)delegate{
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        [device setDelegate:self];
        //        [servicePeripheral setDelegate:self];
        servicePeripheral = device;
    }
    return self;
}

-(void)startDeviceService:(CBPeripheral *)kpb
{
    [servicePeripheral discoverServices:@[[CBUUID UUIDWithString:@"0000AB00-0100-0800-0008-05F9B34FB000"]]];
    
    //    [servicePeripheral discoverServices:[CBUUID UUIDWithString:@"0000AB00-0100-0800-0008-05F9B34FB000"]];
}

-(void) readDeviceBattery:(CBPeripheral *)device
{
    
    //    NSLog(@"readDeviceBattery==%@",device);
    if (device.state != CBPeripheralStateConnected)
    {
        return;
    }
    else
    {
        [self notification:TI_KEYFOB_BATT_SERVICE_UUID characteristicUUID:TI_KEYFOB_LEVEL_SERVICE_UUID p:device on:YES];
    }
}

-(void)readDeviceRSSI:(CBPeripheral *)device
{
    //    NSLog(@"device==%@",device);
    if (device.state == CBPeripheralStateConnected)
    {
        [device readRSSI];
    }
    else
    {
        return;
    }
}

-(void)startBuzzer:(CBPeripheral*)device
{
    NSLog(@"startBuzzer called");
    NSLog(@"startBuzzer called with device ==%@",device);
    if (device == nil || device.state != CBPeripheralStateConnected)
    {
        return;
    }
    else
    {
        NSLog(@"startBuzzer==0x10");
        [self soundBuzzer:0x06 peripheral:device];
        //to know, from which OS the device has been connected i.e., iOS/Android
        //        [self soundBuzzer:0x0D peripheral:device];
    }
}

-(void)stopBuzzer:(CBPeripheral*)device{
    if (device == nil || device.state != CBPeripheralStateConnected)
    {
        return;
    }
    else
    {
        [self soundBuzzer:0x07 peripheral:device];
    }
}


#pragma mark- CBPeripheralDelegate
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray		*services	= nil;
    if (peripheral != servicePeripheral)
    {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil)
    {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    
    if (!services || ![services count])
    {
        return ;
    }
    
    if (!error)
    {
        [self getAllCharacteristicsFromKeyfob:peripheral];
    }
    else
    {
        printf("Service discovery was unsuccessfull !\r\n");
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
    NSArray		*characteristics	= [service characteristics];
    NSLog(@"didDiscoverCharacteristicsForService %@",characteristics);
    CBCharacteristic *characteristic;
    
    if (peripheral != servicePeripheral) {
        //NSLog(@"didDiscoverCharacteristicsForService Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        //NSLog(@"didDiscoverCharacteristicsForService Error %@\n", error);
        return ;
    }
    
    for (characteristic in characteristics)
    {
        UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
        
        switch(characteristicUUID){
            case TI_KEYFOB_LEVEL_SERVICE_UUID:
            {
                char batlevel;
                [characteristic.value getBytes:&batlevel length:1];
                if (_delegate) {
                    [_delegate activeDevice:peripheral];
                    NSString *battervalStr = [NSString stringWithFormat:@"%f",(float)batlevel];
                    NSLog(@"battervalStr=====%@",battervalStr);
                    [_delegate batterySignalValueUpdated:peripheral withBattLevel:battervalStr];
                }
                //sending code to identify the from which app it has benn connected i.e, either Find App/others....
                [self soundBuzzer:0x0E peripheral:peripheral];
                
                //to know, from which OS the device has been connected i.e., iOS/Android
                [self soundBuzzer:0x0D peripheral:peripheral];
                break;
            }
        }
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValueForCharacteristic==%@",[NSString stringWithFormat:@"%@",characteristic.value]);
    NSString * charUUIDStr = [NSString stringWithFormat:@"%@",characteristic.UUID];
    NSString * valueStr = [NSString stringWithFormat:@"%@",characteristic.value];
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@"<" withString:@""];

    if ([charUUIDStr isEqualToString:CKPTD_CHARACTERISTICS_DATA_CHAR3])
    {
        if (![[self checkforValidString:valueStr] isEqualToString:@"NA"])
        {
            if ([valueStr length]>=42)//For Diver Locate 18122019
            {
                NSString * strCmd = [valueStr substringWithRange:NSMakeRange(0, 2)];
                if ([strCmd isEqualToString:@"02"])
                {
                    if ([valueStr length]>=6)
                    {
                        NSString * strOpcode = [valueStr substringWithRange:NSMakeRange(4, 2)];
                        if ([strOpcode isEqualToString:@"04"])
                        {
                            if ([valueStr length]>= 44)
                            {
                                NSString * strNanoID =[self getStringExtcacted:[valueStr substringWithRange:NSMakeRange(6, 8)]];
                                
                                NSString * strLatSign = [valueStr substringWithRange:NSMakeRange(42, 1)];
                                NSString * strLongSign = [valueStr substringWithRange:NSMakeRange(43, 1)];
                                
                                NSRange range1 = NSMakeRange(14,10);
                                NSString * strLat = [valueStr substringWithRange:range1];
                                NSString * strLatFinal = [self getLatLongforBiometric:strLat withSign:strLatSign];
                                
                                range1 = NSMakeRange(24,10);
                                NSString * strLong = [valueStr substringWithRange:range1];
                                NSString * strlongFinal = [self getLatLongforBiometric:strLong withSign:strLongSign];
                                
                                NSString * strDistance = [self getStringExtcacted:[valueStr substringWithRange:NSMakeRange(34, 8)]];
                                
                                NSLog(@"Final Lat=%@ Lon=%@ Data=%@",strLatFinal,strlongFinal, valueStr);
                                
                                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                                [dict setObject:strNanoID forKey:@"NanoID"];
                                [dict setObject:strLatFinal forKey:@"lat"];
                                [dict setObject:strlongFinal forKey:@"long"];
                                [dict setObject:strDistance forKey:@"distance"];
                                [globalDeviceStatusVC GetDistanceofNanoID:dict];
                            }
                        }
                    }
                }
            }
            else if ([valueStr rangeOfString:@"020605"].location != NSNotFound)//Error in searching distance & location
            {
                if (valueStr.length ==16)
                {
                    if ([[valueStr substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"020605"])
                    {
                        NSString * strError = [valueStr substringWithRange:NSMakeRange(14, 2)];
                        NSString * strNanoID =[self getStringExtcacted:[valueStr substringWithRange:NSMakeRange(6, 8)]];
                        [globalDeviceStatusVC ShowErrorMessagewithType:strError withNanoID:strNanoID];
                    }
                }
            }
            else if ([valueStr length]>=26) //For Message Acknowledgement Recieved, Read & Error
            {
                if ([[valueStr substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"050b"])
                {
                    if ([[valueStr substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"01"])//Check 01 Opcode
                    {
                        NSString * strSquence = [valueStr substringWithRange:NSMakeRange(16, 8)];
                        NSLog(@"----->>>>>>>Sequence No---->%@",strSquence);
                        if (![[self checkforValidString:strSquence] isEqualToString:@"NA"])
                        {
                            NSString * strQuery = [NSString stringWithFormat:@"Select * from NewChat where sequence = '%@'",strSquence];
                            NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
                            [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:tmpArr];
                            if (tmpArr.count > 0)
                            {
                                NSString * strStatus = @"Received";
                                if ([[valueStr substringWithRange:NSMakeRange(24, 2)] isEqualToString:@"31"])//01 means Recieved
                                {
                                     strStatus = @"Received";
                                }
                                else if ([[valueStr substringWithRange:NSMakeRange(24, 2)] isEqualToString:@"32"])//01 means Read
                                {
                                     strStatus = @"Read";
                                }
                                else if ([[valueStr substringWithRange:NSMakeRange(24, 2)] isEqualToString:@"33"])//01 means Read
                                {
                                    strStatus = @"Failed";
                                }
                                NSString * strUpdate = [NSString stringWithFormat:@"Update NewChat set status = '%@' where sequence = '%@'",strStatus,strSquence];
                                [[DataBaseManager dataBaseManager] execute:strUpdate];
                                if ([strCurrentScreen isEqualToString:@"Chat"])
                                {
                                    [globalChatVC GotSentMessageAcknowledgement:strSquence withStatus:[valueStr substringWithRange:NSMakeRange(24, 2)]];
                                }
                            }
                        }
                    }
                }
            }
            else if ([valueStr length]>=24)//For LatLong
            {
                if ([valueStr rangeOfString:@"0a0a"].location != NSNotFound)
                {
                    if ([valueStr length]==24)
                    {
                        //Get Latitude
                        NSRange range1 = NSMakeRange(4,10);
                        NSString * strLat = [valueStr substringWithRange:range1];
                        NSString * strLatFinal = [self getLatitudeLongitude:strLat];
                        
                        range1 = NSMakeRange(14,10);
                        NSString * strLong = [valueStr substringWithRange:range1];
                        NSString * strlongFinal = [self getLatitudeLongitude:strLong];
                        
                        float lat  = [strLatFinal floatValue];
                        lat = lat + 0.1401344;
                        strLatFinal = [NSString stringWithFormat:@"%f",lat];
                        
                        float longi  = [strlongFinal floatValue];
                        longi = longi + 0.2375655;
                        strlongFinal = [NSString stringWithFormat:@"%f",longi];
                        
                        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:strLatFinal forKey:@"latitude"];
                        [dict setObject:strlongFinal forKey:@"longitude"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGPSLocation" object:dict];
                    }
                }
            }
            else if ([valueStr length]>=16)
            {
                NSString * strCmd = [valueStr substringWithRange:NSMakeRange(0, 2)];
                if ([strCmd isEqualToString:@"05"])
                {
                    NSString * strOpcode = [valueStr substringWithRange:NSMakeRange(12, 2)];
                    NSString * strNanoID = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(4, 8)]];
                    
                    NSString * strHexMsg = [valueStr substringWithRange:NSMakeRange(14, 2)];
                    NSString * strMsg = [self stringFroHex:strHexMsg];
                    if ([strOpcode isEqualToString:@"09"])
                    {
                        if (valueStr.length == 22)
                        {
                            strMsg = [self getStringExtcacted:[valueStr substringWithRange:NSMakeRange(14, 8)]];
                        }
                    }
                    [globalDashboard UpdateMessagelistwithNanoID:strNanoID withValue:strMsg withOpcode:strOpcode];
                }
            }
            else if([valueStr length]>=6)
            {
                NSString * strCmd = [valueStr substringWithRange:NSMakeRange(0, 4)];
                if ([strCmd isEqualToString:@"0901"])
                {
                    NSString * strOpcode = [valueStr substringWithRange:NSMakeRange(4, 2)];
                    [globalDeviceSetup SyncedAcknowlegmentfor:strOpcode];
                }
                else if ([strCmd isEqualToString:@"0101"])
                {
                    if ([[valueStr substringWithRange:NSMakeRange(0, 6)]isEqualToString:@"010101"])
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"lignLightAssignAck" object:nil];

                    }
                }
            }
            
        }
    }    
 }
-(NSString *)getLatitudeLongitude:(NSString *)strHex
{
    //Get Latitude
    NSRange range1 = NSMakeRange(0,2);
    NSString * strLat = [strHex substringWithRange:range1];
    //After PointValuue
    range1 = NSMakeRange(4,6);
    NSString * strLatPointVal =  [self getStringExtcacted:[strHex substringWithRange:range1]] ;
    
    double pointfloat = [strLatPointVal floatValue];
    int afterCalPoint = (pointfloat * 100.0)/60;
    
    NSString * strLatFinal = [NSString stringWithFormat:@"%@.%d",[self getStringExtcacted:strLat],afterCalPoint];
    return strLatFinal;
}
-(NSString *)getLatLongforBiometric:(NSString *)strHex withSign:(NSString *)strSign
{
    //Get Latitude
    NSRange range1 = NSMakeRange(0,2);
    NSString * strLat = [strHex substringWithRange:range1];
    //After PointValuue
    range1 = NSMakeRange(4,6);
    NSString * strLatPointVal =  [self getStringExtcacted:[strHex substringWithRange:range1]] ;
    
    double pointfloat = [strLatPointVal floatValue];
    int afterCalPoint = (pointfloat * 100.0)/60;
    NSString * strBeforePoint = [self getStringExtcacted:strLat];
    if ([strSign isEqualToString:@"1"])
    {
        strBeforePoint = [NSString stringWithFormat:@"-%@",strBeforePoint];
    }
    
    NSString * strLatFinal = [NSString stringWithFormat:@"%@.%d",strBeforePoint,afterCalPoint];
    return strLatFinal;
}
-(NSString *)getStringExtcacted:(NSString *)importStr
{
    NSString * strExport;
    
    unsigned long long uContact;
    NSScanner* scanner = [NSScanner scannerWithString:importStr];
    [scanner scanHexLongLong:&uContact];
    double unixNano = uContact;
    NSNumber * nanoNumber = [[NSNumber alloc] initWithDouble:unixNano];
    strExport = [NSString stringWithFormat:@"%@",nanoNumber];
    
    return strExport;
}
-(int)getSignedIntfromHex:(NSString *)hexStr
{
    NSString *tempNumber = hexStr;
    NSScanner *scanner = [NSScanner scannerWithString:tempNumber];
    unsigned int temp;
    [scanner scanHexInt:&temp];
    float actualInt = (int32_t)(temp);
    return actualInt;
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
        NSLog(@"didUpdateNotificationStateForCharacteristic =%@",characteristic);
//    [self readValue:TI_KEYFOB_BATT_SERVICE_UUID characteristicUUID:TI_KEYFOB_LEVEL_SERVICE_UUID p:peripheral];
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"peripheralDidUpdateRSSI peripheral.name ==%@ ::RSSI ==%f, error==%@",peripheral.name,[peripheral.RSSI doubleValue],error);
    
    if (error == nil)
    {
        if(peripheral == nil)
            return;
        
        if (peripheral != servicePeripheral)
        {
            NSLog(@"Wrong peripheral\n");
            return ;
        }
        
        if (peripheral==servicePeripheral)
        {
            if (_delegate) {
                //            [_delegate updateSignalImage:[[peripheral RSSI] intValue] forDevice:peripheral];
                [_delegate updateSignalImage:[peripheral.RSSI doubleValue] forDevice:peripheral];
            }
            
            //            rssiValue = [peripheral.RSSI doubleValue];
            //            NSLog(@"rssiValue peripheralDidUpdateRSSI =====================================================>>%f",rssiValue);
            
            if (peripheral.state == CBPeripheralStateConnected)
            {
                /*  if (rssiValue !=0)
                 {
                 if ([Range_Alert_Value integerValue]<40)
                 {
                 if (rssiValue < -55)
                 {
                 [self playSoundWhenDeviceRSSIisLow];
                 }
                 }
                 else if ([Range_Alert_Value integerValue]>=40 && [Range_Alert_Value integerValue]<90)
                 {
                 if (rssiValue < -80)
                 {
                 [self playSoundWhenDeviceRSSIisLow];
                 }
                 }
                 else if([Range_Alert_Value integerValue]>90)
                 {
                 if (rssiValue < -96)
                 {
                 //                            [self stopPlaySound];
                 [self playSoundWhenDeviceRSSIisLow];
                 }
                 }
                 }
                 else
                 {
                 // [self playSoundWhenDeviceRSSIisLow]; //comment due to app is randomly beep when rssi is 0
                 }*/ 
                
                
                
                /* if (rssiValue !=0)
                 {
                 if (rssiValue >= -74)
                 {
                 [self stopPlaySound];
                 }
                 else if(rssiValue <=-75 && rssiValue >=-84 )
                 {
                 [self stopPlaySound];
                 }
                 else if(rssiValue <=-84 && rssiValue >=-89)
                 {
                 [self stopPlaySound];
                 //                        [self playSoundWhenDeviceRSSIisLow];
                 }
                 else if(rssiValue <=-90 && rssiValue >=-95)
                 {
                 [self stopPlaySound];
                 //                        [self playSoundWhenDeviceRSSIisLow];
                 }
                 else if(rssiValue < -95)
                 {
                 [self playSoundWhenDeviceRSSIisLow];
                 }
                 }
                 else
                 {
                 [self playSoundWhenDeviceRSSIisLow];
                 }*/
            }
        }
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"didReadRSSI peripheral.name ==%@ ::RSSI ==%f, error==%@",peripheral.name,[RSSI doubleValue],error);
    
    if(peripheral == nil)
        return;
    
    if (peripheral != servicePeripheral)
    {
        //NSLog(@"Wrong peripheral\n");
        return ;
    }
    
    if (peripheral==servicePeripheral)
    {
        /*  if (tempRSSI == 0) {
         tempRSSI = [RSSI doubleValue];
         }else{
         tempRSSI = rssiValue;
         }
         
         rssiValue = [RSSI doubleValue];
         
         if (tempRSSI != 0) {
         rssiValue = tempRSSI+rssiValue;
         rssiValue = rssiValue/2;
         }else{
         rssiValue = [RSSI doubleValue];
         }
         
         if (peripheral.state == CBPeripheralStateConnected)
         {
         if (rssiValue !=0)
         {
         if ([Range_Alert_Value integerValue]<40)
         {
         if (rssiValue < -55)
         {
         [self playSoundWhenDeviceRSSIisLow];
         }
         }
         else if ([Range_Alert_Value integerValue]>=40 && [Range_Alert_Value integerValue]<90)
         {
         if (rssiValue < -80)
         {
         [self playSoundWhenDeviceRSSIisLow];
         }
         }
         else if([Range_Alert_Value integerValue]>90)
         {
         if (rssiValue < -96)
         {
         [self playSoundWhenDeviceRSSIisLow];
         }
         }
         }
         else
         {
         // [self playSoundWhenDeviceRSSIisLow]; //comment due to app is randomly beep when rssi is 0
         }
         }*/
    }
}

#pragma mark- Helper Methods
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

-(const char *) CBUUIDToString:(CBUUID *) UUID
{
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p
{
    for (int i=0; i < p.services.count; i++)
    {
        CBService *s = [p.services objectAtIndex:i];
        
        if ( self.servicesArray )
        {
            if ( ! [self.servicesArray containsObject:s.UUID] )
                [self.servicesArray addObject:s.UUID];
        }
        else
            self.servicesArray = [[NSMutableArray alloc] initWithObjects:s.UUID, nil];
        
        [p discoverCharacteristics:nil forService:s];
    }
    NSLog(@" services array is %@",self.servicesArray);
}

-(UInt16) CBUUIDToInt:(CBUUID *) UUID
{
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

#pragma mark - SoundBuzzer (Sending signals)
-(void) soundBuzzer:(Byte)buzzerValue peripheral:(CBPeripheral *)peripheral
{
    
}
#pragma mark - Sounder buzzer for notify device
-(void)soundBuzzerforNotifydevice:(Byte)buzzerValue peripheral:(CBPeripheral *)peripheral
{
    NSLog(@"buzzerValue==%d",buzzerValue);
    //    buzzerValue = 01;
    NSData *d = [[NSData alloc] initWithBytes:&buzzerValue length:2];
    //    NSData *d = [[NSData alloc] initWithBytes:&buzzerValue length:2];
    
    CBUUID * sUUID = [CBUUID UUIDWithString:CPTD_SERVICE_UUID_STRING];
    CBUUID * cUUID = [CBUUID UUIDWithString:CPTD_CHARACTERISTIC_COMM_CHAR];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:d];
}
-(void)soundBuzzerforNotifydevice1:(NSString *)buzzerValue peripheral:(CBPeripheral *)peripheral
{
    NSLog(@"buzzerValue==%@",buzzerValue);
    NSInteger test = [buzzerValue integerValue];
    
    //    buzzerValue = 01;
    NSData *d = [[NSData alloc] initWithBytes:&test length:2];
    //    NSData *d = [[NSData alloc] initWithBytes:&buzzerValue length:2];
    
    CBUUID * sUUID = [CBUUID UUIDWithString:CPTD_SERVICE_UUID_STRING];
    CBUUID * cUUID = [CBUUID UUIDWithString:CPTD_CHARACTERISTIC_COMM_CHAR];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:d];
}
#pragma mark - send Battery to device
-(void) soundbatteryToDevice:(long long)buzzerValue peripheral:(CBPeripheral *)peripheral
{
    //    NSInteger test = [buzzerValue integerValue];
    NSLog(@"test ==> %ld",(long)buzzerValue);
    NSData *d = [NSData dataWithBytes:&buzzerValue length:6];
    CBUUID * sUUID = [CBUUID UUIDWithString:CPTD_SERVICE_UUID_STRING];
    CBUUID * cUUID = [CBUUID UUIDWithString:CPTD_CHARACTERISTICS_DATA_CHAR];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:d];
}


-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    [p readValueForCharacteristic:characteristic];
}

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    
    NSLog(@" ***** Sent data *****%@",data);
//    NSLog(@" ***** find data *****%@",characteristic);
    //    NSLog(@" ***** find data *****%@",data);
    
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark play Sound
-(void)playSoundWhenDeviceRSSIisLow
{
    // NSLog(@"IS_Range_Alert_ON==%@",IS_Range_Alert_ON);
    //if ([IS_Range_Alert_ON isEqualToString:@"YES"])
    {
        NSURL *songUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/beep.wav", [[NSBundle mainBundle] resourcePath]]];
        
        songAlarmPlayer1=[[AVAudioPlayer alloc]initWithContentsOfURL:songUrl error:nil];
        songAlarmPlayer1.delegate=self;
        
        AVAudioSession *audioSession1 = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession1 setCategory :AVAudioSessionCategoryPlayback error:&err];
        [audioSession1 setActive:YES error:&err];
        
        [songAlarmPlayer1 prepareToPlay];
        [songAlarmPlayer1 play];
    }
}

-(void)stopPlaySound
{
    [songAlarmPlayer1 stop];
}



#pragma mark - Sending Notification
-(void)sendSignals
{
    CBPeripheral * p;
    CBUUID * sUUID = [CBUUID UUIDWithString:@"0505A000D10211E19B2300025B002B2B"];
    CBUUID * cUUID = [CBUUID UUIDWithString:@"0505A001D10211E19B2300025B002B2B"];
    [self CBUUIDnotification:sUUID characteristicUUID:cUUID p:p on:YES];
}
#pragma mark - Sending notifications
-(void)CBUUIDnotification:(CBUUID*)su characteristicUUID:(CBUUID*)cu p:(CBPeripheral *)p on:(BOOL)on {
    
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}

#pragma mark - Write value
-(void) CBUUIDwriteValue:(CBUUID *)su characteristicUUID:(CBUUID *)cu p:(CBPeripheral *)p data:(NSData *)data
{
    CBService *service = [self findServiceFromUUID:su p:p];
    
    
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@ \r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],p.identifier.UUIDString);
        return;
    }
    
    NSLog(@" ***** sent data *****%@",data);
//    NSLog(@" ***** find data *****%@",characteristic);
    
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}
#pragma mark  - send signal before Before
-(void)sendSignalBeforeBattery:(CBPeripheral *)kp withValue:(NSString *)dataStr
{
    if (kp != nil)
    {
        if (kp.state == CBPeripheralStateConnected)
        {
            NSLog(@"continuousSendSignalToConnectedDevice %@ : 0x01",kp); // For battery
            [self soundBuzzerforNotifydevice1:dataStr peripheral:kp];
        }
    }
}
#pragma mark  - send signals to device
-(void)sendBatterySignal:(CBPeripheral *)kp
{
    if (kp != nil)
    {
        if (kp.state == CBPeripheralStateConnected)
        {
            double secsUtc1970 = [[NSDate date]timeIntervalSince1970];
            
            long long mills = (long long)([[NSDate date]timeIntervalSince1970]*1000.0);
            NSLog(@"continuousSendSignalToConnectedDevice %lld : real time-%@",mills,[NSDate date]); // For battery
            
            NSString * setUTCTime = [NSString stringWithFormat:@"%f",secsUtc1970];
            [self soundbatteryToDevice:mills peripheral:kp];
        }
    }
}
-(void)sendDeviceType:(CBPeripheral *)kp withValue:(NSString *)dataStr
{
    if (kp != nil)
    {
        if (kp.state == CBPeripheralStateConnected)
        {
            NSLog(@"continuousSendSignalToConnectedDevice %@ : 0x01",kp); // For battery
            //[self soundBuzzerforNotifydevice1:dataStr peripheral:kp];
            
            NSInteger test = [dataStr integerValue];
            
            //    buzzerValue = 01;
            NSData *d = [[NSData alloc] initWithBytes:&test length:2];
            //    NSData *d = [[NSData alloc] initWithBytes:&buzzerValue length:2];
            
            CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING1];
            CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR1];
            [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:kp data:d];
        }
    }
}
//15C8B50CF60
-(void)sendHandleString:(CBPeripheral *)peripheral
{
    Byte *bt =0x1F;
            NSData *d = [[NSData alloc] initWithBytes:&bt length:1];
            CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING1];
            CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR1];
            [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:d];
}
-(void)sendingTestToDevice:(NSString *)message with:(CBPeripheral *)peripheral withIndex:(NSString *)strIndex
{
    NSString * str = [self hexFromStr:message];
    NSData * msgData = [self dataFromHexString:str];
    
    NSMutableData * midData = [[NSMutableData alloc] init];
    if ([strIndex length]>1)
    {
        for (int i=0; i<[strIndex length]; i++)
        {
            NSString * str = [strIndex substringWithRange:NSMakeRange(i,1)];
            NSString * string = [self hexFromStr:str];
            NSData * strData = [self dataFromHexString:string];
            [midData appendData:strData];
        }
    }
    else
    {
        NSString * str = [strIndex substringWithRange:NSMakeRange(0,1)];
        NSString * string = [self hexFromStr:str];
        NSData * strData = [self dataFromHexString:string];
        [midData appendData:strData];

    }
    NSString * dotStr = [self hexFromStr:@"."];
    NSData * dotData = [self dataFromHexString:dotStr];
    [midData appendData:dotData];
    
    NSInteger indexInt = [strIndex integerValue];
    NSData * indexData = [[NSData alloc] initWithBytes:&indexInt length:1];
    
    NSMutableData *completeData = [indexData mutableCopy];
    [completeData appendData:midData];
    [completeData appendData:msgData];
    
    NSLog(@"Hex of Message =%@ and Final Bytes===>>>%@",str,completeData);

    
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING2];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR2];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:completeData];

    /*NSString * str = [self hexFromStr:message];
    NSLog(@"%@", str);
    
    NSData *bytes = [self dataFromHexString:str];
    NSLog(@"This is sent data===>>>%@",bytes);
    
    NSInteger test = [strIndex integerValue];
    NSData *d = [[NSData alloc] initWithBytes:&test length:1];
    
    NSMutableData *completeData = [d mutableCopy];
    [completeData appendData:bytes];
    NSLog(@"This is sent data===>>>%@",completeData);
    
    //    NSData *d = [[NSData alloc] initWithBytes:0x1F length:1];
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING2];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR2];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:completeData];*/
    
}
-(void)sendingTestToDeviceCanned:(NSString *)message with:(CBPeripheral *)peripheral withIndex:(NSString *)strIndex
{
    NSString * str = [self hexFromStr:message];
    NSData * msgData = [self dataFromHexString:str];
    
    NSMutableData * midData = [[NSMutableData alloc] init];
    if ([strIndex length]>1)
    {
        for (int i=0; i<[strIndex length]; i++)
        {
            NSString * str = [strIndex substringWithRange:NSMakeRange(i,1)];
            NSString * string = [self hexFromStr:str];
            NSData * strData = [self dataFromHexString:string];
            [midData appendData:strData];
        }
    }
    else
    {
        NSString * str = [strIndex substringWithRange:NSMakeRange(0,1)];
        NSString * string = [self hexFromStr:str];
        NSData * strData = [self dataFromHexString:string];
        [midData appendData:strData];
        
    }
    NSString * dotStr = [self hexFromStr:@"."];
    NSData * dotData = [self dataFromHexString:dotStr];
    [midData appendData:dotData];
    
    NSInteger indexInt = [strIndex integerValue];
    NSData * indexData = [[NSData alloc] initWithBytes:&indexInt length:1];
    
    NSMutableData *completeData = [indexData mutableCopy];
    [completeData appendData:midData];
    [completeData appendData:msgData];
    
    NSLog(@"data===>>>%@  and Msg =%@",completeData, message);

    /*NSString * str = [self hexFromStr:message];
    NSLog(@"%@", str);
    
    NSData *bytes = [self dataFromHexString:str];
    NSLog(@"This is sent data===>>>%@",bytes);
    
    NSInteger test = [strIndex integerValue];
    NSData *d = [[NSData alloc] initWithBytes:&test length:1];
    
    NSMutableData *completeData = [d mutableCopy];
    [completeData appendData:bytes];
    NSLog(@"This is sent data===>>>%@",bytes);*/
    
    //    NSData *d = [[NSData alloc] initWithBytes:0x1F length:1];
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING1];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR1];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:completeData];
    
}
-(void)syncDiverMessage:(NSString *)message with:(CBPeripheral *)peripheral withIndex:(NSString *)strIndex
{
    NSString * str = [self hexFromStr:message];
    NSData * msgData = [self dataFromHexString:str];
    
    NSMutableData * midData = [[NSMutableData alloc] init];
    if ([strIndex length]>1)
    {
        for (int i=0; i<[strIndex length]; i++)
        {
            NSString * str = [strIndex substringWithRange:NSMakeRange(i,1)];
            NSString * string = [self hexFromStr:str];
            NSData * strData = [self dataFromHexString:string];
            [midData appendData:strData];
        }
    }
    else
    {
        NSString * str = [strIndex substringWithRange:NSMakeRange(0,1)];
        NSString * string = [self hexFromStr:str];
        NSData * strData = [self dataFromHexString:string];
        [midData appendData:strData];
        
    }
    NSString * dotStr = [self hexFromStr:@"."];
    NSData * dotData = [self dataFromHexString:dotStr];
    [midData appendData:dotData];
    
    NSInteger indexInt = [strIndex integerValue];
    NSData * indexData = [[NSData alloc] initWithBytes:&indexInt length:1];
    
    NSMutableData *completeData = [indexData mutableCopy];
    [completeData appendData:midData];
    [completeData appendData:msgData];
    
    NSLog(@"data===>>>%@  and Msg =%@",completeData, message);

    
    /*NSString * str = [self hexFromStr:message];
    NSData * msgData = [self dataFromHexString:str];

    NSLog(@"%@", str);
    
    NSMutableData * midData = [[NSMutableData alloc] init];
    if ([strIndex length]>1)
    {
        for (int i=0; i<[strIndex length]; i++)
        {
            NSString * str = [strIndex substringWithRange:NSMakeRange(i,i+1)];
            NSString * string = [self hexFromStr:str];
            NSData * strData = [self dataFromHexString:string];
            [midData appendData:strData];
            NSLog(@"strings===>>>%@",str);
        }
    }
    else
    {
        
    }
    NSString * dotStr = [self hexFromStr:@"."];
    NSData * dotData = [self dataFromHexString:dotStr];
    [midData appendData:dotData];

    NSInteger indexInt = [strIndex integerValue];
    NSData * indexData = [[NSData alloc] initWithBytes:&indexInt length:1];
    
    NSMutableData *completeData = [indexData mutableCopy];
    [completeData appendData:midData];
    [completeData appendData:msgData];*/
    
    //    NSData *d = [[NSData alloc] initWithBytes:0x1F length:1];
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING4];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR4];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:completeData];
    
}

-(NSString*)hexFromStr:(NSString*)str
{
    NSData* nsData = [str dataUsingEncoding:NSUTF8StringEncoding];
    const char* data = [nsData bytes];
    NSUInteger len = nsData.length;
    NSMutableString* hex = [NSMutableString string];
    for(int i = 0; i < len; ++i)
        [hex appendFormat:@"%02X", data[i]];
    return hex;
}

- (NSData *)dataFromHexString:(NSString*)hexStr
{
    const char *chars = [hexStr UTF8String];
    int i = 0, len = hexStr.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}
-(void)writeValuetoDevice:(NSData *)message with:(CBPeripheral *)peripheral
{
  //    NSData *d = [[NSData alloc] initWithBytes:0x1F length:1];
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING3];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR3];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:message];
    
}
-(void)writeValuetoDeviceDiverMsg:(NSData *)message with:(CBPeripheral *)peripheral
{
    //    NSData *d = [[NSData alloc] initWithBytes:0x1F length:1];
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING3];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR3];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:message];
    
}

-(void)sendTimeToDevice:(CBPeripheral *)kp
{
    if (kp != nil)
    {
        if (kp.state == CBPeripheralStateConnected)
        {
            long long mills = (long long)([[NSDate date]timeIntervalSince1970]);
            NSData *dates = [NSData dataWithBytes:&mills length:4];
            
            NSInteger first = [@"01" integerValue];
            NSData *dfirst = [[NSData alloc] initWithBytes:&first length:1];
            
            NSInteger four = [@"04" integerValue];
            NSData *dfour = [[NSData alloc] initWithBytes:&four length:1];
            
            NSMutableData *completeData = [dfirst mutableCopy];
            [completeData appendData:dfour];
            [completeData appendData:dates];
            
            NSLog(@"Final data%@ and RTC=%lld",completeData,mills); // For battery
            
            CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING3];
            CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR3];
            [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:kp data:completeData];
            
            //            [self soundbatteryToDevice:mills peripheral:kp];
        }
    }
}

-(void)sendMessagetoother:(NSString *)strAll with:(CBPeripheral *)peripheral withIndex:(NSString *)strIndex
{
    NSInteger int1 = [@"05" integerValue];
    NSData * data1 = [[NSData alloc] initWithBytes:&int1 length:1];
    
    NSInteger int2 = [@"02" integerValue];
    NSData * data2 = [[NSData alloc] initWithBytes:&int2 length:1];

    NSInteger int3 = [strAll integerValue];
    NSData * data3 = [[NSData alloc] initWithBytes:&int3 length:1];

    NSInteger int4 = [strIndex integerValue];
    NSData * data4 = [[NSData alloc] initWithBytes:&int4 length:1];

    NSMutableData *completeData = [data1 mutableCopy];
    [completeData appendData:data2];
    [completeData appendData:data3];
    [completeData appendData:data4];

    NSLog(@"This is sent data===>>>%@",completeData);
    
    //    NSData *d = [[NSData alloc] initWithBytes:0x1F length:1];
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING3];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR3];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peripheral data:completeData];
    
}
-(void)sendNotifications:(CBPeripheral*)kp withType:(BOOL)isMulti
{
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING3];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR3];
    
    //    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:kp data:d];
    kp.delegate = self;
    [self CBUUIDnotification:sUUID characteristicUUID:cUUID p:kp on:YES];
}
-(NSString*)stringFroHex:(NSString *)hexStr
{
    unsigned long long startlong;
    NSScanner* scanner1 = [NSScanner scannerWithString:hexStr];
    [scanner1 scanHexLongLong:&startlong];
    double unixStart = startlong;
    NSNumber * startNumber = [[NSNumber alloc] initWithDouble:unixStart];
    return [startNumber stringValue];
}
-(void)SendDatatodevice:(NSMutableData *)finalData withPeripheral:(CBPeripheral *)peri
{
    CBUUID * sUUID = [CBUUID UUIDWithString:CKPTD_SERVICE_UUID_STRING2];
    CBUUID * cUUID = [CBUUID UUIDWithString:CKPTD_CHARACTERISTICS_DATA_CHAR2];
    [self CBUUIDwriteValue:sUUID characteristicUUID:cUUID p:peri data:finalData];
}
-(NSString *)checkforValidString:(NSString *)strRequest
{
    NSString * strValid;
    if (![strRequest isEqual:[NSNull null]])
    {
        if (strRequest != nil && strRequest != NULL && ![strRequest isEqualToString:@""])
        {
            strValid = strRequest;
        }
        else
        {
            strValid = @"NA";
        }
    }
    else
    {
        strValid = @"NA";
    }
    strValid = [strValid stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strValid;
}

@end
