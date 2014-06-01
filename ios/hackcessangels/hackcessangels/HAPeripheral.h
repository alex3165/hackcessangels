//
//  HAPeripheral.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 25/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "HASERVICES.h"
#import "HAUser.h"

@interface HAPeripheral : NSObject < CBPeripheralDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;

@property (nonatomic, strong) HAUser *actualUser;
@property (nonatomic, strong) NSMutableData *temporaryData;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double longitude;
//-(void)setPositionUser:(double)lat longitude:(double)longitude;
- (id)initWithLongAndLat:(double)longitude latitude:(double)latitude;

@end
