//
//  AppDelegateAgents.m
//  HackcessAngelsAgents
//

#import "AppDelegateAgents.h"

#import "HACurrentStationService.h"
#import "HAHelpRequest.h"
#import "HAMapViewController.h"
#import "HAAgentHomeViewController.h"

@interface AppDelegateAgents()

@property (nonatomic, strong) HACurrentStationService* currentStationService;

@end

@implementation AppDelegateAgents

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Periodically report location to server.
    if (self.currentStationService == nil) {
        self.currentStationService = [[HACurrentStationService alloc] init];
        [self.currentStationService startReportingLocation];
    }
    
    // In case of notification, load the right view controller
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        [self application:application didReceiveLocalNotification:localNotif];
    }
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APN device token: %@", deviceToken);
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"%@",deviceTokenString);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    HAHelpRequest *helpRequest = [[HAHelpRequest alloc] initWithDictionary: [notification.userInfo valueForKey:@"helpRequest"]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Agent" bundle:nil];
    UITabBarController *tabBarController = (UITabBarController*) self.window.rootViewController;
    UINavigationController *navigationController = (UINavigationController *) tabBarController.viewControllers[1];
    HAMapViewController *mapViewController = (HAMapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"agentMapViewController"];
    mapViewController.helpRequest = helpRequest;
    [tabBarController setSelectedIndex:1];
    [navigationController pushViewController:mapViewController animated:FALSE];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
