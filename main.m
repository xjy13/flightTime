
#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "GetSchedule.h"
#import "FlightTimeDelegate.h"
#import "MapGoogle.h"
//for change to storyborad
int main(int argc, char *argv[]) {

    @autoreleasepool {
        //for delegate 讓root老闆的工作移到get小弟那邊
//        RootViewController *root = [[RootViewController alloc] init];
//        GetSchedule *getS = [[GetSchedule alloc] init];
        //set delegate value
//        root.rootdelegate = getS;
//        [root getSchdule_delegation];
      //  [root test2];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([FlightTimeDelegate class]));
    }
    
}


