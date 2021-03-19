//
//  SGFManager.m
//  SGFindSDK
//
//  Created by Oneclick IT Solution on 7/11/14.
//  Copyright (c) 2014 One Click IT Consultancy Pvt Ltd, Ind. All rights reserved.
//


#import "BLEManager.h"
#import "Constant.h"

static BLEManager	*sharedManager	= nil;
//BLEManager	*sharedManager	= nil;

@interface BLEManager()
{
    NSMutableArray *disconnectedPeripherals;
    NSMutableArray *connectedPeripherals;
    NSMutableArray *peripheralsServices;
    CBCentralManager    *centralManager;
    BLEService * blutoothService;
}
@end

@implementation BLEManager
@synthesize delegate,foundDevices,connectedServices,centralManager;

#pragma mark- Self Class Methods
-(id)init
{
    if(self = [super init])
    {
        [self initialize];
    }
    return self;
}

#pragma mark --> Initilazie
-(void)initialize
{
    //  NSLog(@"bleManager initialized");
    
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{ CBCentralManagerOptionRestoreIdentifierKey:  @"CentralManagerIdentifier" }];
    centralManager.delegate = self;
    blutoothService.delegate = self;
    [foundDevices removeAllObjects];
    if(!foundDevices)foundDevices = [[NSMutableArray alloc] init];
    if(!connectedServices)connectedServices = [[NSMutableArray alloc] init];
    if(!disconnectedPeripherals)disconnectedPeripherals = [NSMutableArray new];
}

+ (BLEManager*)sharedManager
{
    if (!sharedManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[BLEManager alloc] init];
        });
    }
    return sharedManager;
}
-(NSArray *)getLastConnected
{
    //    if (isConnectionIssue)
    //    {
    //        //isConnectionIssue = NO;
    //    }
    return [centralManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"0000AB00-0100-0800-0008-05F9B34FB000"]]];
}

#pragma mark- Scanning Method
-(void)startScan
{
    
    CBPeripheralManager *pm = [[CBPeripheralManager alloc] initWithDelegate:nil queue:nil];
    //  NSLog(@"pm===%@",pm);
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey,nil];
    [centralManager scanForPeripheralsWithServices:nil options:options];
}
#pragma mark - > Rescan Method
-(void) rescan
{
    centralManager.delegate = self;
    blutoothService.delegate = self;
    self.serviceDelegate = self;
    
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey,
                              nil];
    [centralManager scanForPeripheralsWithServices:nil options:options];
}

#pragma mark - Stop Method
-(void)stopScan
{
    self.delegate = nil;
    self.serviceDelegate = nil;
    blutoothService.delegate = nil;
    blutoothService = nil;
    centralManager.delegate = nil;
    [foundDevices removeAllObjects];
    [centralManager stopScan];
    [blutoothSearchTimer invalidate];
    
}

#pragma mark - Central manager delegate method stop
-(void)centralmanagerScanStop
{
    [centralManager stopScan];
}
#pragma mark - Connect Ble device
- (void) connectDevice:(CBPeripheral*)device{
    
    if (device == nil)
    {
        return;
    }
    else
    {//3.13.1 is live or testlgijt ?
        if ([disconnectedPeripherals containsObject:device])
        {
            [disconnectedPeripherals removeObject:device];
        }
        [self connectPeripheral:device];
    }
}

#pragma mark - Disconenct Device
- (void)disconnectDevice:(CBPeripheral*)device
{
    if (device == nil) {
        return;
    }else{
        [self disconnectPeripheral:device];
    }
}

-(void)connectPeripheral:(CBPeripheral*)peripheral
{
    NSError *error;
    if (peripheral)
    {
        if (peripheral.state != CBPeripheralStateConnected)
        {
            [centralManager connectPeripheral:peripheral options:nil];
        }
        else
        {
            if(delegate)
            {
                [delegate didFailToConnectDevice:peripheral error:error];
            }
        }
    }
    else
    {
        if(delegate)
        {
            [delegate didFailToConnectDevice:peripheral error:error];
        }
    }
}

-(void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    [self.delegate didDisconnectDevice:peripheral];
    if (peripheral)
    {
        if (peripheral.state == CBPeripheralStateConnected)
        {
            [centralManager cancelPeripheralConnection:peripheral];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceDidDisConnectNotification" object:peripheral];
        }
    }
}


-(void) updateBluetoothState
{
    [self centralManagerDidUpdateState:centralManager];
}

-(void) updateBleImageWithStatus:(BOOL)isConnected andPeripheral:(CBPeripheral*)peripheral
{
}

#pragma mark -  Search Timer Auto Connect
-(void)searchConnectedBluetooth:(NSTimer*)timer
{
    /*----Here we have Auto reconnect based on local database or saved Device----*/
    //  NSLog(@"foundDevices==hari%@",foundDevices);
    
    //    for(CBPeripheral * p in foundDevices)
    //    {
    //        //       // //  NSLog(@"CBPeripheral p hari == %@",p);
    //        //        if (p.state == CBPeripheralStateConnected)
    //        //        {
    //        //            peripheral = p ;
    //        //           // //  NSLog(@"p==%@",[p name]);
    //        //            NSMutableArray * arrIDs = [[NSMutableArray alloc] init];
    //        //            NSString *queryStr = [NSString stringWithFormat:@"Select * from User_Created_Device where device_name = '%@' AND user_id = '%@' AND connection_type='auto'",[p name],CURRENT_USER_ID];
    //        //            // //  NSLog(@"queryStr==%@",queryStr);
    //        //            [[DataBaseManager dataBaseManager] execute:queryStr resultsArray:arrIDs];
    //        //          //  //  NSLog(@"arrIDs== Connected%@",arrIDs);
    //        //
    //        //            if ([arrIDs count]>0)
    //        //            {
    //        //                if ([CURRENT_USER_ID isEqualToString:@""] || [CURRENT_USER_ID isEqual:[NSNull null]] || CURRENT_USER_ID == nil || [CURRENT_USER_ID isEqualToString:@"(null)"])
    //        //                {
    //        //                }
    //        //                else
    //        //                {
    //        //                    [[BLEService sharedInstance] readDeviceBattery:peripheral];
    //        //                }
    //        //            }
    //        //            else
    //        //            {
    //        //                [self disconnectDevice:p];
    //        //            }
    //        //            [[NSNotificationCenter defaultCenter]postNotificationName:@"DeviceConnectedNotification" object:nil];
    //        //            [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckDeviceAvailabilityNotification" object:nil userInfo:nil];
    //        //            [[NSNotificationCenter defaultCenter] postNotificationName:kBluetoothSignalUpdateNotification object:peripheral userInfo:nil];
    //        //        }
    //        //        else
    //        //        {
    //        //            NSMutableArray * arrIDs = [[NSMutableArray alloc] init];
    //        //            NSString *queryStr = [NSString stringWithFormat:@"Select * from User_Created_Device where device_name = '%@' AND user_id = '%@' AND connection_type='auto' ",[p name],CURRENT_USER_ID];
    //        //            [[DataBaseManager dataBaseManager] execute:queryStr resultsArray:arrIDs];
    //        //            //  NSLog(@"arrIDs== connecting%@",arrIDs);
    //        //
    //        //            if ([arrIDs count]>0)
    //        //            {
    //        //                //  NSLog(@"self.autoConnect==%d",V_IS_Auto_Connect);
    //        //                if ([CURRENT_USER_ID isEqualToString:@""] || [CURRENT_USER_ID isEqual:[NSNull null]] || CURRENT_USER_ID == nil || [CURRENT_USER_ID isEqualToString:@"(null)"])
    //        //                {
    //        //                }
    //        //                else
    //        //                {
    //        //                         [self connectDevice:p];
    //        //                }
    //        //                [[NSNotificationCenter defaultCenter]postNotificationName:@"DeviceConnectedNotification" object:nil];
    //        //                [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckDeviceAvailabilityNotification" object:nil userInfo:nil];
    //        //                [[NSNotificationCenter defaultCenter] postNotificationName:kBluetoothSignalUpdateNotification object:peripheral userInfo:nil];
    //        //            }
    //        //        }*/
    //    }
    
    [self rescan];
}
#pragma mark Scan Sync Timer
-(void)scanDeviceSync:(NSTimer*)timer
{
    //    NSMutableArray * arrRecord = [[NSMutableArray alloc] init];
    //    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM Scanned_Device_History_Table where device_owner_id = '%@' group by device_id order by date_time DESC ",CURRENT_USER_ID];
    //    [[DataBaseManager dataBaseManager] execute:queryStr resultsArray:arrRecord];
    //    //  NSLog(@"arrRecord==>>>>%@",arrRecord);
    
    //    if ([arrRecord count]>0)
    //    {
    //        [self saveScannedDeviceHistoryWebServiceForDevices:arrRecord];
    //    }
    
    
}

#pragma mark --> readRSSITimer
//-(void)readRSSIValueForConnectedDevice:(NSTimer*)timer
//{
//    //    for(CBPeripheral * p in arrCases)
//    for(CBPeripheral * p in foundDevices)
//    {
//        //        if (p.state == CBPeripheralStateConnected)
//        //        {
//        //            NSMutableArray * arrIDs = [[NSMutableArray alloc] init];
//        //            NSString *queryStr = [NSString stringWithFormat:@"Select * from User_Created_Device where device_name = '%@' AND user_id = '%@' ",[p name],CURRENT_USER_ID];
//        //            [[DataBaseManager dataBaseManager] execute:queryStr resultsArray:arrIDs];
//        //
//        //            if ([arrIDs count]>0)
//        //            {
//        //                if ([CURRENT_USER_ID isEqualToString:@""] || [CURRENT_USER_ID isEqual:[NSNull null]] || CURRENT_USER_ID == nil || [CURRENT_USER_ID isEqualToString:@"(null)"])
//        //                {
//        //                }
//        //                else
//        //                {
//        //                    [[BLEService sharedInstance] readDeviceRSSI:p];
//        //                }
//        //            }
//        //        }
//        //        else
//        //        {
//        //           /* if (p.state != CBPeripheralStateConnected)
//        //            {
//        //                NSMutableArray * arrIDs = [[NSMutableArray alloc] init];
//        //                NSString *queryStr = [NSString stringWithFormat:@"Select * from User_Created_Device where device_id = '%@' AND isPrimaryDevice = 'YES' AND user_id = '%@'",[p name],CURRENT_USER_ID];
//        //                [[DataBaseManager dataBaseManager] execute:queryStr resultsArray:arrIDs];
//        //
//        //                if ([arrIDs count]>0)
//        //                {
//        //                    //                    //  NSLog(@"self.autoConnect==%d",V_IS_Auto_Connect);
//        //                    if ([CURRENT_USER_ID isEqualToString:@""] || [CURRENT_USER_ID isEqual:[NSNull null]] || CURRENT_USER_ID == nil || [CURRENT_USER_ID isEqualToString:@"(null)"])
//        //                    {
//        //                    }
//        //                    else
//        //                    {
//        //                        if ([IS_Range_Alert_ON isEqualToString:@"YES"])
//        //                        {
//        //                            if (V_IS_Auto_Connect == YES)
//        //                            {
//        //                                [self playSoundWhenDeviceRSSIisLow];
//        //                            }
//        //                        }
//        //                    }
//        //                }
//        //            }*/
//        //        }
//    }
//}





#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self startScan];
    /*----Here we can come to know bluethooth state----*/
    [blutoothSearchTimer invalidate];
    blutoothSearchTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(searchConnectedBluetooth:) userInfo:nil repeats:YES];
    
    switch (central.state)
    {
        case CBPeripheralManagerStateUnknown:
            //The current state of the peripheral manager is unknown; an update is imminent.
            if(delegate)[delegate bluetoothPowerState:@"The current state of the peripheral manager is unknown; an update is imminent."];
            
            break;
        case CBPeripheralManagerStateUnauthorized:
            //The app is not authorized to use the Bluetooth low energy peripheral/server role.
            if(delegate)[delegate bluetoothPowerState:@"The app is not authorized to use the Bluetooth low energy peripheral/server role."];
            
            break;
        case CBPeripheralManagerStateResetting:
            //The connection with the system service was momentarily lost; an update is imminent.
            if(delegate)[delegate bluetoothPowerState:@"The connection with the system service was momentarily lost; an update is imminent."];
            
            break;
        case CBPeripheralManagerStatePoweredOff:
            //Bluetooth is currently powered off"
            if(delegate)[delegate bluetoothPowerState:@"Bluetooth is currently powered off."];
            
            break;
        case CBPeripheralManagerStateUnsupported:
            //The platform doesn't support the Bluetooth low energy peripheral/server role.
            if(delegate)[delegate bluetoothPowerState:@"The platform doesn't support the Bluetooth low energy peripheral/server role."];
            
            break;
        case CBPeripheralManagerStatePoweredOn:
            //Bluetooth is currently powered on and is available to use.
            if(delegate)[delegate bluetoothPowerState:@"Bluetooth is currently powered on and is available to use."];
            break;
    }
}

#pragma mark - Finding Device with in Range
-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    //  NSLog(@"peripherals==%@",peripherals);
}

#pragma mark - Discover all devices here
/*-----------if device is in range we can find in this method--------*/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    NSLog(@"AdvertiseData=%@",[advertisementData valueForKey:@"kCBAdvDataLocalName"]);
//    NSLog(@"AdvertiseData=%@",advertisementData);

    NSString * strDeviceName = [NSString stringWithFormat:@"%@",[advertisementData valueForKey:@"kCBAdvDataLocalName"]];

    NSString * strCheckString = @"SC4";
    if (isScanForLignlight == true)
    {
        strDeviceName = [NSString stringWithFormat:@"%@",[advertisementData valueForKey:@"kCBAdvDataLocalName"]];
        strCheckString = @"Succorfish Biometrics";
    }
    if ([strDeviceName rangeOfString:strCheckString].location != NSNotFound)
    {
        NSString *  strConnect = [NSString stringWithFormat:@"%@",[advertisementData valueForKey:@"kCBAdvDataIsConnectable"]];

        if ([strConnect isEqualToString:@"1"])
        {
            NSData *nameData = [advertisementData valueForKey:@"kCBAdvDataManufacturerData"];
            if ([nameData length]>0)
            {
                NSString *nameString = [NSString stringWithFormat:@"%@",nameData]; //this works
                nameString = [nameString stringByReplacingOccurrencesOfString:@" " withString:@""];
                nameString = [nameString stringByReplacingOccurrencesOfString:@">" withString:@""];
                nameString = [nameString stringByReplacingOccurrencesOfString:@"<" withString:@""];
                
                NSArray * tmpArr = [nameString componentsSeparatedByString:@"5900"];
                if([tmpArr count]>1)
                {
                    NSString * strAddress = [NSString stringWithFormat:@"%@",[tmpArr objectAtIndex:1]];
                    
                    if (![[foundDevices valueForKey:@"address"] containsObject:strAddress])
                    {
                        if(![peripheral.name isEqualToString:@"(null)"] && ![peripheral.name isEqual:[NSNull null]] && [peripheral.name length]>0)
                        {
                            NSMutableDictionary * dicta = [[NSMutableDictionary alloc] init];
                            [dicta setObject:strAddress forKey:@"address"];
                            [dicta setObject:peripheral forKey:@"peripheral"];
                            [dicta setObject:strDeviceName forKey:@"deviceName"];
                            [foundDevices addObject:dicta];
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CallNotificationforDiscover" object:peripheral userInfo:advertisementData];
                }
            }
        }
    }
}

#pragma mark - > Resttore state of devices
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    NSArray *peripherals =dict[CBCentralManagerRestoredStatePeripheralsKey];
    
    if (peripherals.count>0)
    {
        for (CBPeripheral *p in peripherals)
        {
            if (p.state != CBPeripheralStateConnected)
            {
                //[self connectPeripheral:p];
            }
        }
    }
}

#pragma mark - Fail to connect device
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    /*---This method will call if failed to connect device-----*/
    if(delegate)[delegate didFailToConnectDevice:peripheral error:error];
}

- (void)discoverIncludedServices:(nullable NSArray<CBUUID *> *)includedServiceUUIDs forService:(CBService *)service;
{
    
}
- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service;
{
    
}
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;
{
    
}


#pragma mark - Connect Delegate method
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //    [[BLEManager sharedManager] stopScan];//HARI12*-06-2017
    
    /*-------This method will call after succesfully device Ble device connect-----*/
        peripheral.delegate = self;
    
    if (peripheral.services)
    {
        [self peripheral:peripheral didDiscoverServices:nil];
    } else
    {
        [peripheral discoverServices:@[[CBUUID UUIDWithString:@"0000AB00-0100-0800-0008-05F9B34FB000"]]];
    }
    
}
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    BOOL gotService = NO;
    for(CBService* svc in peripheral.services)
    {
        gotService = YES;
          NSLog(@"service=%@",svc);
        if(svc.characteristics)
            [self peripheral:peripheral didDiscoverCharacteristicsForService:svc error:nil]; //already discovered characteristic before, DO NOT do it again
        else
            [peripheral discoverCharacteristics:nil
                                     forService:svc]; //need to discover characteristics
    }
    if (gotService == NO)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideHud" object:nil];
        [self disconnectDevice:peripheral];
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for(CBCharacteristic* c in service.characteristics)
    {
          NSLog(@"characteristics=%@",c);
        
        //Do some work with the characteristic...
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceDidConnectNotification" object:peripheral];

}

#pragma mark - Disconnect Ble Device
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceDidDisConnectNotification" object:peripheral];

}

/*
 ========================================================
 Date : 12th June 2017
 ========================================================
 Absent      		:  Bhavsang
 Half Day   		:  -
 Work from Home	:   Dhananjay
 All Present		:  -
 
 */
@end
