//
//  FlightTimeDelegate.h
//  FlightTime
//
//  Created by mac on 2016/11/15.
//
//

#import <UIKit/UIKit.h>
#import <FirebaseCore/FirebaseCore.h>
#import <GoogleMaps/GoogleMaps.h>
//@protocol MyDemoAppDelegate <NSObject>
//@optional
//
//
//@end

@interface FlightTimeDelegate: UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    UINavigationController *nav;
    
}
//@property (weak) id<EADemoAppDelegate> delegate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;
@property (nonatomic, retain)NSMutableArray *arrivalArray;
//+(void)jsonArrival:(NSString *)comeFrom;
@end

