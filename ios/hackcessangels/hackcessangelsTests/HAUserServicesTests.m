//
//  HAUserServicesTests.m
//  hackcessangels
//
//  Created by boris charp on 20/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HAUserService.h"
#import "XCTAsyncTestCase.h"

@interface HAUserServicesTests : XCTAsyncTestCase

@end

@implementation HAUserServicesTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_loginWithEmailAndPassword_login_success
{
    HAUserService *userService = [[HAUserService alloc] init];
    
    [self prepare];
    
    __block NSString *test;
    
    [userService loginWithEmailAndPassword:@"julia@gmail.com" password:@"motdepasse" success:^{
        
        test = @"youpi";
        [self notify:kXCTUnitWaitStatusSuccess];
        
    } failure:^(NSError *error) {
        
        [self notify:kXCTUnitWaitStatusFailure];
        
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
    
    XCTAssertEqualObjects(test, @"youpi", @"");
}

@end
