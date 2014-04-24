//
//  HACentralManager.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 25/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "HASERVICES.h"
#import "HAMapViewController.h"

@interface HACentralManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;
@property (nonatomic, assign) BOOL needHelp;
//@property (nonatomic, copy) HAMapViewController *agentController;

@end
