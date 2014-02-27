//
//  HAUserTests.m
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HAUser.h"
#import "UICKeyChainStore.h"

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

- (void)testInitWithDictionaryUser_name_and_description
{
    NSDictionary *dico = @{@"email":@"toto@titi.com",@"password":@"password", @"name":@"toto", @"description":@"toto est gentil"};
    HAUser *user = [[HAUser alloc] initWithDictionary:dico];
    
    XCTAssertEqualObjects(user.email, @"toto@titi.com", @"");
    XCTAssertEqualObjects(user.password, @"password", @"");
    XCTAssertEqualObjects(user.name, @"toto", @"");
    XCTAssertEqualObjects(user.userdescription, @"toto est gentil", @"");
}

- (void)test_SaveUserToKeyChain
{
    NSDictionary *dico = @{@"email":@"toto@titi.com",@"password":@"password", @"name":@"toto", @"description":@"toto est gentil"};
    HAUser *user = [[HAUser alloc] initWithDictionary:dico];
    [user saveUserToKeyChain];
    
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:kEmailKey service:@"HAUser"], @"toto@titi.com", @"");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:kPasswordKey service:@"HAUser"], @"password", @"");
}

- (void) test_UserFromKeyChain {
    [UICKeyChainStore setString:@"email@domain.tld" forKey:kEmailKey service:@"HAUser"];
    [UICKeyChainStore setString:@"secret" forKey:kPasswordKey service:@"HAUser"];
    
    HAUser *user = [HAUser userFromKeyChain];
    XCTAssertEqualObjects(user.email, @"email@domain.tld", @"");
    XCTAssertEqualObjects(user.password, @"secret", @"");
}

- (void)testSendrequest
{
//    HAUserService *userService;
//    self.userService = [[HAUserService alloc] init];
//    [self.userService POSTrequest:@"user" withParameters:@{@"email":@"julia.dirand@gmail.com",@"password":@"motdepasse"} success:^(NSDictionary *dico){
//        
//        NSLog(@"Success");
//        
//    } failure:^(NSError *error){
//        
//        NSLog(@"Failure");
//    }];
}
@end
