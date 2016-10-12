
#import <ExternalAccessory/ExternalAccessory.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>

@class EADSessionController;


@interface EADSessionTransferViewController : UIViewController <UITextFieldDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate> {
    EAAccessory *_accessory;
    UILabel *_receivedBytesLabel;
    UITextField *_stringToSendTextField;
    UITextField *_hexToSendTextField;


    uint32_t _totalBytesRead;
    
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *recordPlayer;
    AVAudioRecorder *audioRecoder;
    AVAudioSession *audioSession;
    MPRemoteCommandCenter *commandCenter;
    NSMutableArray *accessoryInfo;
    
    
}

//- (IBAction)sendString:(id)sender;
//- (IBAction)sendHex:(id)sender;
//- (IBAction)send10K:(id)sender;
@property(nonatomic, retain)UIButton *playMuzik;
@property(nonatomic, retain)UIButton *pauseMuzik;
@property (nonatomic, retain)UIButton *startRecord;
@property (nonatomic, retain)UIButton *stopRecord;
@property (nonatomic, retain)UIButton *playRecord;
@property (nonatomic, retain)UIButton *stop_playRecord;
@property (nonatomic, retain)UIButton *backBtn;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIScrollView *scrollView;
//- (IBAction)sendMusicControl:(id)sender;

// UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@property(nonatomic, retain) IBOutlet UILabel *receivedBytesLabel;
@property(nonatomic, retain) IBOutlet UITextField *stringToSendTextField;
@property(nonatomic, retain) IBOutlet UITextField *hexToSendTextField;

@end
