//
//  CBCentralManagerViewController.h
//  CBTutorial
//
//  Created by Orlando Pereira on 10/8/13.
//  Copyright (c) 2013 Mobiletuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "SERVICES.h"

@interface CBCentralManagerViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

    /* Tutorial Bluetooth : http://code.tutsplus.com/tutorials/ios-7-sdk-core-bluetooth-practical-lesson--mobile-20741 */

    @property (strong, nonatomic) IBOutlet UITextView *textview;
    @property (strong, nonatomic) CBCentralManager *centralManager;
    @property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
    @property (strong, nonatomic) NSMutableData *data;

@end