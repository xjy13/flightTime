
#import <ExternalAccessory/ExternalAccessory.h>

//add for 20160712

#import "FlightTimeDelegate.h"
#import "MBProgressHUD.h"
#import "GetSchedule.h"
#import "ScheduleTableCell.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FlightStatus) {
    arrival          = -1,
    onTime     = 0,
    scheduleChange = 1,
    delay = 2,
    cancel = 3
};


@class RootViewController;

//他是老闆要叫getschedule這個class幫忙做事
//@protocol rootDelegate <NSObject>
//@optional
//- (NSMutableArray *)jsonArrival:(RootViewController *)rootView comeFrom:(NSString *)from;
////-(NSString *)getAirApiticket:(RootViewController *)rootView;
//@end


@interface RootViewController : UIViewController <UIActionSheetDelegate,UITableViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,ScheduleCellDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>

//@property(nonatomic,assign) id<rootDelegate>rootdelegate;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *scrollView;
//@property (nonatomic,retain)id<TalkToMac> delegate;

//add for 20160712
@property(nonatomic, strong)UIButton *refreshBtn;
@property (nonatomic, strong)UIButton *arrivalBtn;
@property (nonatomic, strong)UIButton *departureBtn;
@property (nonatomic, strong)UIButton *toMapBtn;
@property (nonatomic, strong)UIRefreshControl *refresh;
@property (nonatomic, strong)NSMutableArray *arrivalArray;
@property (nonatomic, strong)NSMutableArray *departureArray;
@property (nonatomic, strong)NSMutableArray *airportArray;
@property (nonatomic, strong)NSMutableArray *flightArray;
@property (nonatomic,strong) NSTimer *flightSchedule;
// from UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

////for peer to talk
//- (void)appendOutputMessage:(NSString*)message;

@end
