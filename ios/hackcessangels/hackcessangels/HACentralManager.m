//
//  HACentralManager.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 25/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HACentralManager.h"

@implementation HACentralManager

- (id)init
{
    self = [super init];
    
    
    if (self) {
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.data = [[NSMutableData alloc]init];
    }
    
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if (central.state != CBCentralManagerStatePoweredOn) { // Check if bluetooth is active
        NSLog(@"Bluetooth is not active");
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        
        // Scan for devices
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:HELP_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"Scanning started");
    }
}

// called whenever a device is discovered
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    if (self.discoveredPeripheral != peripheral) {
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// Called when connection with device failed
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Failed to connect");
    [self cleanup];
}

// Called if we are connected with another device
// Stop scaning process
// Check for services and characteristics
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"Connected");
    
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    [self.data setLength:0];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:HELP_SERVICE_UUID]]];
}

// Check for services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        NSLog(@"Error during services test");
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:HELP_CHARACTERISTIC_UUID]] forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        NSLog(@"Error during characteristics test");
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HELP_CHARACTERISTIC_UUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error");
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        //[self.textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        
        /* Récupération des datas ici */
        
        
        // Response of central if ok
        // [peripheral writeValue:@"hehe" forCharacteristic:interestingCharacteristic type:CBCharacteristicWriteWithResponse];
        
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    
    [self.data appendData:characteristic.value];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:HELP_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.discoveredPeripheral = nil;
    
    // scan again for any new service
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:HELP_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

- (void)cleanup {
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HELP_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}


@end
