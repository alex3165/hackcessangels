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

@protocol HACentralManagerDelegate <NSObject>

- (void)helpValueChanged:(BOOL)newValue user:(NSDictionary *)user uuid:(NSUUID *)uuid;

@end

@interface HACentralManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (weak, nonatomic) id<HACentralManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableData *data;
@property (nonatomic, assign) BOOL needHelp;

- (void)takeRequest:(NSUUID *)uuid;

- (void)cleanup;

@end
