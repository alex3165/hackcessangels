//
//  HAUserTests.m
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HAUser.h"


@interface HAUserTests : XCTestCase

@end

@implementation HAUserTests

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

- (void)testInitWithDictionaryUser
{
    NSDictionary *dico;
    HAUser *user = [[HAUser alloc] initWithDictionary:dico];
    
    XCTAssertNotNil(user, @"");
}

- (void)testInitWithDictionaryUser_withEmail_and_password
{
    NSDictionary *dico = @{@"email":@"toto@titi.com",@"password":@"password"};
    HAUser *user = [[HAUser alloc] initWithDictionary:dico];
    
    XCTAssertEqualObjects(user.email, @"toto@titi.com", @"");
    XCTAssertEqualObjects(user.password, @"password", @"");
}


@end
