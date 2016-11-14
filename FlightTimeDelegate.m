//
//  FlightTimeDelegate.m
//  FlightTime
//
//  Created by mac on 2016/11/15.
//
//

#import "FlightTimeDelegate.h"
//#import "RootViewController.h"
#define arrivalURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Arrival/TPE?%24top=6&%24format=JSON"
#define departureURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Departure/TPE?%24top=6&%24format=JSON"

@implementation FlightTimeDelegate

//@synthesize window;
//@synthesize navigationController;

//- (void)applicationDidFinishLaunching:(UIApplication *)application {

// Override point for customization after app launch


//	[window addSubview:[navigationController view]];


// 在ios 9.x 要用下面這個 ref. by http://goo.gl/O18DYG
//    [window setRootViewController:navigationController];
//    [window makeKeyAndVisible];


//}

//- (void)applicationWillTerminate:(UIApplication *)application {
// Save data if appropriate
//}

//- (void)dealloc {
//	[navigationController release];
//	[window release];
//	[super dealloc];
//}





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    [window setRootViewController:nav];
    [window makeKeyAndVisible];
    return YES;
    
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


//-(void)jsonArrival:(NSString *)comeFrom{
//    if(![comeFrom isEqualToString:@""]){
//        NSError *err = nil;
//        NSURL *url = [NSURL URLWithString:arrivalURL];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
//        _arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"Departure json from Delegate : %@",_arrivalArray);
//    }
//    
//}



- (void)dealloc {
    [UINavigationController release];
    [window release];
    [super dealloc];
}


@end
