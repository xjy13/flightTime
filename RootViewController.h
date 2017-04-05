
#import <ExternalAccessory/ExternalAccessory.h>

//add for 20160712
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import "FlightTimeDelegate.h"
#import "MBProgressHUD.h"
#import "GetSchedule.h"

@class RootViewController;

//他是老闆要叫getschedule這個class幫忙做事
//@protocol rootDelegate <NSObject>
//@optional
//- (NSMutableArray *)jsonArrival:(RootViewController *)rootView comeFrom:(NSString *)from;
////-(NSString *)getAirApiticket:(RootViewController *)rootView;
//@end



@interface RootViewController : UIViewController <UIActionSheetDelegate,UITableViewDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,MBProgressHUDDelegate> {
    
    NSMutableArray *_accessoryList;
    NSMutableArray *_accessoryOriginal;
    EAAccessory *_selectedAccessory;
    //EADSessionController *_eaSessionController;
    NSMutableDictionary *accessoryInfo;


  //  UIView *_noExternalAccessoriesPosterView;
   
    
    //add for 20160712
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *recordPlayer;
    AVAudioRecorder *audioRecoder;
    AVAudioSession *audioSession;
    MPRemoteCommandCenter *commandCenter;
    
}
//@property(nonatomic,assign) id<rootDelegate>rootdelegate;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *scrollView;
//@property (nonatomic,retain)id<TalkToMac> delegate;

//add for 20160712

@property(nonatomic, retain)UIButton *refreshBtn;
@property (nonatomic, retain)UIButton *arrivalBtn;
@property (nonatomic, retain)UIButton *departureBtn;
@property (nonatomic, retain)UIButton *toMapBtn;

@property (nonatomic, strong)NSMutableArray *arrivalArray;
@property (nonatomic, strong)NSMutableArray *departureArray;
@property (nonatomic, strong)NSMutableArray *airportArray;
@property (nonatomic, strong)NSMutableArray *flightArray;

// from UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

////for peer to talk
//- (void)appendOutputMessage:(NSString*)message;
@end
