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
#import "OHHTTPStubs.h"
#import "UICKeyChainStore.h"

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
    [OHHTTPStubs removeAllStubs];
}

- (void)test_createUserWithEmailAndPassword_Create_Success
{
    HAUserService *userService = [[HAUserService alloc] init];
    
    [self prepare];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        
        return [OHHTTPStubsResponse responseWithData:nil statusCode:200 headers:nil];
        
    }];
    
    [userService createUserWithEmailAndPassword:@"julia.dirand@gmail.com" password:@"motdepasse" success:^(id obj, id obj2){
        
        [self notify:kXCTUnitWaitStatusSuccess];
        
    } failure:^(id obj, NSError *error) {
        
        [self notify:kXCTUnitWaitStatusFailure];
        
    } ];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}


- (void)test_deleteUserWithEmail_delete_Success
{
    HAUserService *userService = [[HAUserService alloc] init];
    
    [self prepare];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:nil statusCode:200 headers:nil];
    }];
    
    [userService loginWithEmailAndPassword:@"julia.dirand@gmail.com" password:@"motdepasse" success:^(id obj, id obj2){
        [userService deleteUserWithEmail:@"julia@gmail.com" success:^(id obj, id obj2){
            [self notify:kXCTUnitWaitStatusSuccess];
        } failure:^(id obj, NSError *error) {
            [self notify:kXCTUnitWaitStatusFailure];
        }];
    } failure:^(id obj, NSError *error) {
        [self notify:kXCTUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}


- (void)test_getUserWithEmail_Success{
    
    HAUserService *userService = [[HAUserService alloc] init];
    
    [self prepare];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        
        NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"user" withExtension:@"json"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        
    }];
    
    [userService getUserWithEmail:@"julia.dirand@gmail.com" success:^(id obj){
        XCTAssertEqualObjects(NSStringFromClass([obj class]), NSStringFromClass([HAUser class]), @"Wrong class");
        HAUser *user = obj;
        XCTAssertEqualObjects(user.name, @"John", @"Wrong name");
        XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"email" service:@"HAUser"], @"John@example.com", @"");
        XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"HAUser"], @"secret", @"");
        [self notify:kXCTUnitWaitStatusSuccess];
    }
        failure:^(NSError *error) {
    
        [self notify:kXCTUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)test_updateUser_Success {
    
    HAUserService *userService = [[HAUserService alloc] init];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
     return YES; // Stub ALL requests without any condition
     } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
     
     return [OHHTTPStubsResponse responseWithData:nil statusCode:200 headers:nil];
     
     }];
    
    [self prepare];
    [userService updateUser:@"julia.dirand@gmail.com" withUpdatedEmail:@"julia@gmail.com" password:@"motdepasse" withUpdatedPassword:@"nouveau_motdepasse" success:^(id obj, id obj2){
        [self notify:kXCTUnitWaitStatusSuccess];
    } failure:^(id obj, NSError *error) {
        [self notify:kXCTUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}

- (void)test_loginWithEmailAndPassword_Success{
    
    HAUserService *userService = [[HAUserService alloc] init];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        
        return [OHHTTPStubsResponse responseWithData:nil statusCode:200 headers:nil];
        
    }];
    
    [self prepare];
    [userService loginWithEmailAndPassword:@"julia.dirand@gmail.com" password:@"motdepasse" success:^(id obj, id obj2){
        [self notify:kXCTUnitWaitStatusSuccess];
    
    } failure:^(id obj, NSError *error){
        [self notify:kXCTUnitWaitStatusFailure];
    }];

    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.0];
}



@end
