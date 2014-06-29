//
//  HACurrentStationService.m
//  hackcessangels
//
//  Created by Etienne Membrives on 19/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HACurrentStationService.h"
#import "HALocationService.h"
#import "HAAgentService.h"
#import "HARequestsService.h"

#import "Reachability.h"

#include <stdlib.h>

@interface HACurrentStationService()

@property (nonatomic, strong) HALocationService* locationService;
@property (nonatomic, strong) HARequestsService* requestsService;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSMutableString *communicationLog;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, assign) BOOL spaceAvailable;
@end

const uint8_t newline[] = "\n";
const int kRetryIntervalInSeconds = 30;

@implementation HACurrentStationService

+ (id)sharedInstance {
    static HACurrentStationService *sharedStationService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStationService = [[self alloc] init];
    });
    return sharedStationService;
}
- (HACurrentStationService*) init {
    self = [super init];
    if (self) {
        self.locationService = [[HALocationService alloc] init];
        self.requestsService = [HARequestsService sharedInstance];
        self.connected = false;
    }
    return self;
}

- (void)connectToServer {
    // Do a keep-alive
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self sendPosition];
    }];
    
    [self.locationService startAreaTracking];
    self.reachability = [Reachability reachabilityWithHostname:@"aidegare.membrives.fr"];
    [self.reachability startNotifier];
    self.spaceAvailable = false;
    [self connectToServerInternal];
}

- (void)connectToServerInternal {
    if (!self.reachability.isReachable) {
        // Retry in kRetryIntervalInSeconds if there is no connection available.
        [NSTimer scheduledTimerWithTimeInterval:kRetryIntervalInSeconds target:self selector:@selector(connectToServerInternal) userInfo:nil repeats:NO];
        return;
    }
    if (!self.inputStream || [self.inputStream streamStatus] != NSStreamStatusOpen) {
        // Connect to server
        DLog(@"Connecting to server");
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)(@"aidegare.membrives.fr"), 5001, &readStream, &writeStream);
        
        // Negotiate SSL connection
        NSDictionary *settings = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:
                                  [NSNumber numberWithBool:NO], kCFStreamSSLAllowsExpiredCertificates,
                                  [NSNumber numberWithBool:NO], kCFStreamSSLAllowsExpiredRoots,
                                  [NSNumber numberWithBool:NO], kCFStreamSSLAllowsAnyRoot,
                                  [NSNumber numberWithBool:YES], kCFStreamSSLValidatesCertificateChain,
                                  [NSNull null], kCFStreamSSLPeerName,
                                  kCFStreamSocketSecurityLevelNegotiatedSSL,
                                  kCFStreamSSLLevel,
                                  nil ];
        
        CFReadStreamSetProperty((CFReadStreamRef)readStream,
                                kCFStreamPropertySSLSettings, (CFTypeRef)settings);
        CFWriteStreamSetProperty((CFWriteStreamRef)writeStream,
                                 kCFStreamPropertySSLSettings, (CFTypeRef)settings);
        
        CFReadStreamSetProperty(readStream, kCFStreamNetworkServiceType,kCFStreamNetworkServiceTypeVoIP);
        CFWriteStreamSetProperty(writeStream, kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
        
        // Set input streams
        self.communicationLog = [[NSMutableString alloc] init];
        self.inputStream = (__bridge_transfer NSInputStream *)readStream;
        self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;
        [self.inputStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
        
        // 3
        [self.inputStream setDelegate:self];
        [self.outputStream setDelegate:self];
        [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        // 4
        [self.inputStream open];
        [self.outputStream open];
    }
}

#pragma mark - Communication methods

- (void)sendLogin:(HAAgent*) agent {
    if (!self.outputStream || [self.outputStream streamStatus] != NSStreamStatusOpen || !self.spaceAvailable) {
        DLog(@"No open connection");
        [self.inputStream close];
        [self.outputStream close];
        return;
    }
    
    NSDictionary *loginData = @{@"Login": agent.email};
    NSError *error;
    [NSJSONSerialization writeJSONObject:loginData toStream:self.outputStream options:0 error:&error];
    self.spaceAvailable = false;
    if (error != nil) {
        DLog(@"%@", error);
        return;
    }
    [self.outputStream write:newline maxLength:strlen((char *)newline)];
    self.spaceAvailable = false;
}

- (void)sendPosition {
    // Abort if no connection is present.
    if (!self.outputStream || [self.outputStream streamStatus] != NSStreamStatusOpen || !self.spaceAvailable) {
        DLog(@"No open connection");
        [self.inputStream close];
        [self.outputStream close];
        [self connectToServerInternal];
        return;
    }
    
    // Abort if no position data is available
    if (self.locationService.location == nil) {
        DLog(@"No location available");
        return;
    }
    
    NSDictionary *positionData = @{@"Latitude": [NSNumber numberWithDouble:self.locationService.location.coordinate.latitude],
                                   @"Longitude": [NSNumber numberWithDouble:self.locationService.location.coordinate.longitude],
                                   @"Precision": [NSNumber numberWithDouble:self.locationService.location.horizontalAccuracy]};
    NSError *error;
    [NSJSONSerialization writeJSONObject:positionData toStream:self.outputStream options:0 error:&error];
    if (error != nil) {
        DLog(@"%@", error);
        return;
    }
    // The server expects a newline to end the client's message.
    [self.outputStream write:newline maxLength:strlen((char *)newline)];
    self.spaceAvailable = false;
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:
            // do nothing.
            break;
            
        case NSStreamEventEndEncountered:
        case NSStreamEventErrorOccurred:
            NSLog(@"Connection Closed: %@", aStream.streamError);
            self.connected = false;
            // We need to reopen the connection, but first wait a bit so we are not overloading the server.
            if (aStream == self.inputStream) {
                [NSTimer scheduledTimerWithTimeInterval:kRetryIntervalInSeconds target:self selector:@selector(connectToServerInternal) userInfo:nil repeats:NO];
            }
            
            [self.inputStream close];
            [self.outputStream close];
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (aStream == self.inputStream)
            {
                uint8_t buffer[1024];
                NSInteger bytesRead = [self.inputStream read:buffer maxLength:1024];
                NSData *data = [NSData dataWithBytes:buffer length:bytesRead];
                
                NSError *error;
                NSDictionary *incomingData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                DLog(@"Received: %@", incomingData);
                
                if ([[incomingData objectForKey:@"KeepAlive"] boolValue] == YES) {
                    [self sendPosition];
                } else if ([[incomingData objectForKey:@"UpdateRequestsNow"] boolValue] == YES) {
                    [self.requestsService getRequests:^(NSArray *helpRequestList) {
                        DLog(@"%@", helpRequestList);
                    } failure:^(NSError *error) {
                        NSLog(@"%@", error);
                    }];
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            if (aStream == self.outputStream) {
                self.spaceAvailable = true;
                if (!self.connected) {
                    [[HAAgentService sharedInstance] getCurrentAgent:^(HAAgent *agent) {
                        [self sendLogin:agent];
                    } failure:^(NSError *error) {
                        DLog(@"%@", error);
                    }];
                }
                self.connected = true;
            }
            break;
            
        case NSStreamEventOpenCompleted:
            if (aStream == self.inputStream) {
                NSLog(@"Connection Opened");
            }
            break;
        default:
            break;
    }
}
@end
