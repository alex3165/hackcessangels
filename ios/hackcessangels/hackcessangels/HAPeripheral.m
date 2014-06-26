//
//  HAPeripheral.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 25/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAPeripheral.h"

@implementation HAPeripheral

- (id)initWithLongAndLat:(double)longitude latitude:(double)latitude
{
    self = [super init];
    
    if (self) {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        self.longitude = longitude;
        self.lat = latitude;
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:HELP_SERVICE_UUID]] }];
        
    }
    
    return self;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        CBMutableService *transferService;
        self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:HELP_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyNotify|CBCharacteristicPropertyWriteWithoutResponse value:nil permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
            
        transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:HELP_SERVICE_UUID] primary:YES];
        
        transferService.characteristics = @[self.transferCharacteristic];
        
        [self.peripheralManager addService:transferService];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {

        self.actualUser = [HAUser userFromKeyChain];

        NSString *userName = self.actualUser.name == nil ? @"inconnue" : self.actualUser.name;
        NSString *userPhone = self.actualUser.phone == nil ? @"inconnue" : self.actualUser.phone;
        NSString *userEmail = self.actualUser.email == nil ? @"inconnue" : self.actualUser.email;
        NSString *userDisability;
    
        switch (self.actualUser.disabilityType) {
        case Physical_wheelchair:
            userDisability = @"Handicap moteur. Je suis en chaise roulante";
            break;
        case Physical_powerchair:
            userDisability = @" Handicap moteur. Je suis en chaise électrique";
            break;
        case Physical_walk:
            userDisability = @"Handicap moteur. J'ai des problèmes de marche.";
            break;
        case Vision_blind :
            userDisability = @"Handicap visuel. Je suis aveugle.";
            break;
        case Vision_lowvision:
            userDisability = @"Handicap visuel. J'ai une mauvaise vue";
            break;
        case Hearing_call:
            userDisability = @"Handicap auditif. Je répond aux appels.";
            break;
        case Hearing_SMS:
            userDisability = @"Handicap auditif. Je répond aux sms.";
            break;
        case Mental:
            userDisability = @"Handicap Mental";
            break;
        case Other:
            userDisability = @"Handicap Autre";
            break;
        case Unknown:
            userDisability = @"Handicap inconnu";
            break;
        }

        NSDictionary *userDictionary = @{
                        @"name" : userName,
                        @"phone" : userPhone,
                        @"email" : userEmail,
                        @"disability" : userDisability,
                        @"longitude" : [[NSNumber alloc] initWithDouble:self.longitude],
                        @"latitude" : [[NSNumber alloc] initWithDouble:self.lat]
                        };

        NSError *err;
        
        self.dataToSend = [NSPropertyListSerialization dataWithPropertyList:userDictionary format:NSPropertyListXMLFormat_v1_0 options:(NSPropertyListWriteOptions)nil error:&err];
    
    self.sendDataIndex = 0;
    
    [self sendData];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    
    CBATTRequest *myRequest = [requests firstObject];
    NSString *myString = [[NSString alloc] initWithData:myRequest.value encoding:NSUTF8StringEncoding];
    
    NSLog(@"Les données : %@", myString);
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    [self sendData];
}


#pragma mark - data send snippet

- (void)sendData {
    
    static BOOL sendingEOM = NO;
    
    // end of message?
    if (sendingEOM) {
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        if (didSend) {
            // It did, so mark it as sent
            sendingEOM = NO;
        }
        // didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    
    // We're sending data
    // Is there any left to send?
    if (self.sendDataIndex >= self.dataToSend.length) {
        // No data left.  Do nothing
        return;
    }
    
    // There's data left, so send until the callback fails, or we're done.
    BOOL didSend = YES;
    
    while (didSend) {
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                NSLog(@"Sent: EOM");
            }
            
            return;
        }
    }
}


@end
