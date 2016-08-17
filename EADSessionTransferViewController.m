//hsu jay modify on July 1, 2016


#import "EADSessionTransferViewController.h"
#import "EADSessionController.h"
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPRemoteCommandEvent.h>

//#import <MediaPlayer/MPRemoteCommandCenter.h>

// record file storage in  sandbox root
@interface EADSessionTransferViewController(){
    
    BOOL isPlay;
    BOOL isRecord;
    BOOL isPlayRecord;
    int hardKeyTap_vol ;
    int volumeUp_count;
    int volumeDown_count;
    int hardKeyTap_play ;
    int hardKeyTap_pause ;
    int softKeyTap_play;
    int softKeyTap_pause;
    int failTime;
    int recordStart_count;
    int recordEnd_count;
    int recordPlay_count;
    int recordPlayend_count;
    float firstVol;
    UILabel *counter;
    UILabel *vol;
    UILabel *volmeUp_label;
    UILabel *volumDown_label;
    UILabel *hardkeyCounter_play;
    UILabel *hardkeyCounter_pause;
    
    UILabel *recordStart;
    UILabel *recordEnd;
    
    UILabel *recordPlay;
    UILabel *recordPlayend;
    
    UIAlertController *failAlert;
    BOOL pause_test;
    NSURL* url_music;
    NSURL *recordPath;
    
    NSMutableDictionary *recordSetting;
}
@end





@implementation EADSessionTransferViewController

@synthesize
receivedBytesLabel = _receivedBytesLabel,
stringToSendTextField = _stringToSendTextField,
hexToSendTextField = _hexToSendTextField;
MPVolumeView *volumeView;


// send test string to the accessory
/*- (IBAction)sendString:(id)sender;
 {
 if ([_stringToSendTextField isFirstResponder]) {
 [_stringToSendTextField resignFirstResponder];
 }
 
 const char *buf = [[_stringToSendTextField text] UTF8String];
 if (buf)
 {
 uint32_t len = strlen(buf) + 1;
 [[EADSessionController sharedController] writeData:[NSData dataWithBytes:buf length:len]];
 }
 }
 
 // Interpret a UITextField's string at a sequence of hex bytes and send those bytes to the accessory
 - (IBAction)sendHex:(id)sender;
 {
 if ([_hexToSendTextField isFirstResponder]) {
 [_hexToSendTextField resignFirstResponder];
 }
 
 const char *buf = [[_hexToSendTextField text] UTF8String];
 NSMutableData *data = [NSMutableData data];
 if (buf)
 {
 uint32_t len = strlen(buf);
 
 char singleNumberString[3] = {'\0', '\0', '\0'};
 uint32_t singleNumber = 0;
 for(uint32_t i = 0 ; i < len; i+=2)
 {
 if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
 {
 singleNumberString[0] = buf[i];
 singleNumberString[1] = buf[i + 1];
 sscanf(singleNumberString, "%x", &singleNumber);
 uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
 [data appendBytes:(void *)(&tmp) length:1];
 }
 else
 {
 break;
 }
 }
 
 [[EADSessionController sharedController] writeData:data];
 }
 }
 
 // send 10K of data to the accessory.
 - (IBAction)send10K:(id)sender
 {
 #define STRESS_TEST_BYTE_COUNT 10000
 uint8_t buf[STRESS_TEST_BYTE_COUNT];
 for(int i = 0; i < STRESS_TEST_BYTE_COUNT; i++) {
 buf[i] = (i & 0xFF);  // fill buf with incrementing bytes;
 }
 
	[[EADSessionController sharedController] writeData:[NSData dataWithBytes:buf length:STRESS_TEST_BYTE_COUNT]];
 }
 */
#pragma mark test play music on screen
-(void)playMusic:(UIButton *)sender{
    _pauseMuzik.hidden = YES;
    NSError *err = nil;
    NSLog(@"JJJ mp3 url %@",audioPlayer.url);
    if(recordPlayer.playing || audioPlayer.playing ){
        [audioPlayer stop];
        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        _pauseMuzik.hidden = YES;
        
        [recordPlayer stop];
        [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
        _stopRecord.hidden = YES;
    }
    if(err == nil){
        if(!isPlay){
            [audioPlayer play];
            _playMuzik.hidden = YES;
            _pauseMuzik.hidden = NO;
            [audioPlayer setDelegate:self];
            [_pauseMuzik setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
            [self.view addSubview:_pauseMuzik];
            isPlay = true;
            softKeyTap_play++;
            NSLog(@"JJJJ soft play %d times",softKeyTap_play);
        }
    }
    else{
        NSLog(@"JJJ print play mp3 err msg %@",err);
        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];        isPlay =  false;
        //pop up fail time msg.
        [self warningMessage:@"Soft Key play"];
    }
}
#pragma mark pause/stop music
-(void)pauseMusic:(UIButton *)sender{
    if(isPlay == true){
        [audioPlayer pause];
        softKeyTap_pause++;
        NSLog(@"JJJJ soft pause %d times",softKeyTap_pause);
        isPlay = false;
    }
    if(!audioPlayer.playing){
        _pauseMuzik.hidden = YES;
        _playMuzik.hidden = NO;
        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    }
    else{
        [self warningMessage:@"Soft Key pause"];
    }
    
}

#pragma mark detect hard key
-(void)receive_harkeyCmd{
    NSError *err = nil;
    MPRemoteCommand *playCmd = [commandCenter togglePlayPauseCommand];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_music error:&err];
    if(err == nil){
        [playCmd addTarget:self action:@selector(playmusicHardkey:) ];
    }
    
}



#pragma mark test by headset hard key
-(void)playmusicHardkey:(MPRemoteCommand *)cmd{
    _pauseMuzik.hidden = YES;
    NSError *err = nil;
    if(recordPlayer.playing || audioPlayer.playing ){
        [audioPlayer stop];
        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        _pauseMuzik.hidden = YES;
        [recordPlayer stop];
        [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
        _stopRecord.hidden = YES;
    }
    if(err == nil){
        //isPlay = true;
        if(!isPlay)
        {
            [audioPlayer play];
            if(audioPlayer.playing){
                _playMuzik.hidden = YES;
                _pauseMuzik.hidden = NO;
                [_pauseMuzik setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
                [self.view addSubview:_pauseMuzik];
                isPlay = true;
                hardKeyTap_play++;
                [audioPlayer setDelegate:self];
                [hardkeyCounter_play setText:[NSString stringWithFormat:@"Play pass %d time",hardKeyTap_play]];
                NSLog(@"JJJJ play %d times",hardKeyTap_play);
                
            }
        }
        else{
            [audioPlayer pause];
            _playMuzik.hidden = NO;
            _pauseMuzik.hidden = YES;
            if(!audioPlayer.playing){
                [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
                isPlay =false;
                hardKeyTap_pause++;
                [hardkeyCounter_pause setText:[NSString stringWithFormat:@"Pause pass %d time",hardKeyTap_pause]];
                NSLog(@"JJJJ pause %d times",hardKeyTap_pause);
            }
            else{
            }
        }
    }
    
    else{
        NSLog(@"JJJ print play mp3 err msg %@",err);
        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        isPlay =  false;
        //pop up fail time msg
        [self warningMessage:@"Hard Key"];
    }
}


#pragma mark test music control
-(void)volumeChanged{
    volumeView = [[MPVolumeView alloc] init];
    [volumeView setFrame:CGRectMake(20.0, 145.0, 290.0, 23.0)];
    [self.view addSubview:volumeView];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(volumeChange:)
                               name:@"AVSystemController_SystemVolumeDidChangeNotification"
                             object:nil];
    
}

#pragma mark volume notification
-(void)volumeChange:(NSNotification *)notification{
    
    NSLog(@"JJJJ noti info %@",notification);
    
    [counter removeFromSuperview];
    [vol removeFromSuperview];
    
    
    
    float volValue = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
    
    
    if(notification) {
        if(volValue == 1.0 || volValue == 0.0){
            
            [self warningMessage:@"vol"];
            
        }
        
        
        if(hardKeyTap_vol == 0){
            if(firstVol > volValue){
                NSLog(@"volume down = %d",volumeDown_count);
                audioPlayer.volume = volValue;
            }
            if(firstVol < volValue){
                NSLog(@"volume up = %d",volumeUp_count);
                audioPlayer.volume = volValue;
            }
        }
        if(hardKeyTap_vol > 0){
            if(audioPlayer.volume > volValue){
                volumeDown_count++;
                NSLog(@"volume down = %d",volumeDown_count);
                [volumDown_label setText:[NSString stringWithFormat:@"Vol down %d time(s)",volumeDown_count]];
                [self.view addSubview:volumDown_label];
                audioPlayer.volume = volValue;
            }
            if(audioPlayer.volume < volValue){
                volumeUp_count++;
                NSLog(@"volume up = %d",volumeUp_count);
                [volmeUp_label setText:[NSString stringWithFormat:@"Vol up %d time(s)",volumeUp_count]];
                [self.view addSubview:volmeUp_label];
                audioPlayer.volume = volValue;
            }
        }
        
        
        hardKeyTap_vol++;
        NSLog(@"JJJ get tap noti %d",hardKeyTap_vol);
        NSString *count_string = [NSString stringWithFormat:@"Vol pass %d times",hardKeyTap_vol];
        [counter setText:count_string];
        [counter setTextColor:[UIColor blackColor]];
    }
    else{
        [counter setText:[NSString stringWithFormat:@"fail in %d",hardKeyTap_vol]];
        [vol setText:@" volume fail!!!!!!!!"];
        [self warningMessage:@"Volume"];
    }
    [vol setText:[NSString stringWithFormat:@"音量：%.0f",volValue*100]];
    [self.view addSubview:counter];
    [self.view addSubview:vol];
    
}


//-(void)headsetPauseControl:(UIEvent *)event{
//    int pauseCounter = 0;
//
//    if(event.type == UIEventTypeRemoteControl){
//        switch (event.subtype) {
//            case UIEventSubtypeRemoteControlTogglePlayPause:
//                pauseCounter++;
//                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause = %d time",pauseCounter);
//                break;
//            case  UIEventSubtypeRemoteControlPlay:
//                NSLog(@" UIEventSubtypeRemoteControlPlay");
//                [self pauseMusic_test];
//                break;
//            default:
//                break;
//        }
//    }
//    else{
//
//        NSLog(@"JJJ cannot remote control");
//
//    }
//
//    if(event.subtype == UIEventSubtypeRemoteControlTogglePlayPause ){
//        [self pauseMusic_test];
//
//    }
//    else{}
//
//}

#pragma mark keep it , becasue it will be used in future.
-(void)statusMusic_test{
    // musicDetect = [[MPMusicPlayerController applicationMusicPlayer]playbackState];
    //[[MPMusicPlayerController applicationMusicPlayer]beginGeneratingPlaybackNotifications];
    
    switch ([[MPMusicPlayerController applicationMusicPlayer]playbackState]) {
        case  MPMusicPlaybackStateStopped:
            NSLog(@"JJJJ status is stop");
            break;
        case MPMusicPlaybackStatePlaying:
            NSLog(@"JJJJ status is playing");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"JJJJ status is pause");
            break;
        case MPMusicPlaybackStateInterrupted:
            NSLog(@"JJJJ status is interrupted");
            break;
        case MPMusicPlaybackStateSeekingForward:
            NSLog(@"JJJJ status is Seeking forward");
            break;
        case MPMusicPlaybackStateSeekingBackward:
            NSLog(@"JJJJ status is Backward");
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseMusic_statusList:) name:@"MPMusicPlayerControllerPlaybackStateDidChangeNotification" object:nil];
    
    
}

#pragma mark Warning message when get failure
-(void)warningMessage:(NSString *)from{
    NSString *failTitle;
    NSString *failTimes;
    failTime++;
    if([from isEqualToString:@"vol"]){
        failAlert = [UIAlertController alertControllerWithTitle:@"ATTENTION!!" message:@"You volume value is Min/Max value" preferredStyle:UIAlertControllerStyleAlert];
    }
    else{
        failTitle = [NSString stringWithFormat:@" %@ WARNING",from];
        failTimes = [NSString stringWithFormat:@"Total fail time is %d",failTime];
        failAlert = [UIAlertController alertControllerWithTitle:failTitle message:failTimes preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
    }];
    [failAlert addAction:confirm];
    [self presentViewController:failAlert animated:YES completion:nil];
}

//-(void)pauseMusic_statusList:(NSNotificationCenter *)notification{
//    NSLog(@"JJJ pause %@",notification);
//
//    switch ([[MPMusicPlayerController applicationMusicPlayer]playbackState]) {
//        case  MPMusicPlaybackStateStopped:
//            NSLog(@"receive stop");
//            break;
//        case MPMusicPlaybackStatePlaying:
//            NSLog(@"receive playing");
//            break;
//        case MPMusicPlaybackStatePaused:
//            NSLog(@"receive pause");
//            break;
//        case MPMusicPlaybackStateInterrupted:
//            NSLog(@"receive interrupted");
//            break;
//        case MPMusicPlaybackStateSeekingForward:
//            NSLog(@"receive forward");
//            break;
//        case MPMusicPlaybackStateSeekingBackward:
//            NSLog(@"receive Backward");
//        default:
//            break;
//    }
//}
#pragma mark Record setting
-(void)recoderInit{
    NSError *err = nil;
    /*
     会话类型	说明	是否要求输入	是否要求输出	是否遵从静音键
     AVAudioSessionCategoryAmbient	混音播放，可以与其他音频应用同时播放	否	是	是
     AVAudioSessionCategorySoloAmbient	独占播放	否	是	是
     AVAudioSessionCategoryPlayback	后台播放，独占	否	是	否
     AVAudioSessionCategoryRecord	录音模式	是	否	否
     AVAudioSessionCategoryPlayAndRecord	播放和录音，此时可以录音也可以播放	是	是	否
     AVAudioSessionCategoryAudioProcessing	硬件解码音频，此时不能播放和录制	否	否	否
     AVAudioSessionCategoryMultiRoute	多种输入输出，例如可以耳机、USB设备同时播放	是	是
     */
    
    NSArray *pathComponents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *componentsDir = [pathComponents objectAtIndex:0];
    recordPath  = [NSURL fileURLWithPath:[componentsDir stringByAppendingPathComponent:@"test.m4a"]];
    
    // 設定錄音格式
    recordSetting = [[NSMutableDictionary alloc]init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    audioRecoder = [[AVAudioRecorder alloc] initWithURL:recordPath settings:recordSetting error:&err];
    audioRecoder.delegate = self;
    audioRecoder.meteringEnabled = YES;
    [audioRecoder prepareToRecord];
    audioSession = [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    
}
#pragma mark recording
-(void)setStartRecord:(UIButton *)sender{
    AVAudioSession *recordSession = [AVAudioSession sharedInstance];
    
    if(audioPlayer.playing || recordPlayer.playing){
        [audioPlayer stop];
        [_playMuzik setTitle:@"Play Music" forState:UIControlStateNormal];
        _pauseMuzik.hidden = YES;
        
        [recordPlayer stop];
        [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
        
        _stopRecord.hidden = YES;
    }
    NSError *err;
    if(!isRecord){
        if(!audioRecoder.recording){
            [recordSession setActive:true error:&err];
            [audioRecoder record];
            recordStart_count++;
            NSLog(@"JJJJ record pass %d time",recordStart_count);
            [recordStart setText:[NSString stringWithFormat:@"Record %d times",recordStart_count]];
            _startRecord.hidden = YES;
            _stopRecord.hidden = NO;
            [_stopRecord setBackgroundImage:[UIImage imageNamed:@"stop_recording"] forState:UIControlStateNormal];
            isRecord = true;
            
        }
        else{
            NSLog(@"JJJ start to record fail");
            [audioRecoder stop];
            [self warningMessage:@"Record fail"];
            [recordSession setActive:false error:&err];
            [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
            _stopRecord.hidden = YES;
            isRecord = false;
        }
    }
}
#pragma mark stop recording
-(void)setStopRecord:(UIButton *)sender{
    NSError *err;
    AVAudioSession *recordSession = [AVAudioSession sharedInstance];
    if(isRecord == true){
        [audioRecoder stop];
        [recordSession setActive:NO error:&err];
        if(!audioRecoder.recording){
            recordEnd_count++;
            [recordEnd setText:[NSString stringWithFormat:@"Stop Record %d times",recordEnd_count]];
            NSLog(@"JJJJ stop recording pass %d",recordEnd_count);
            _startRecord.hidden = NO;
            [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
            _stopRecord.hidden = YES;
            isRecord = false;
        }
        else{
            NSLog(@"JJJJ stop recording fail");
            [recordSession setActive:NO error:&err];
            [self warningMessage:@"Stop-record fail"];
            _startRecord.hidden = NO;
            [_stopRecord setBackgroundImage:[UIImage imageNamed:@"stop_recording"] forState:UIControlStateNormal];
            isRecord = true;
        }
        
    }
    
}
#pragma mark play record file
-(void)playReord:(UIButton *)sender{
    NSError *err = nil;
    NSLog(@"JJJ record file url %@",audioRecoder.url);
    if(audioRecoder.url == nil){
        [self warningMessage:@"Record URL NULL"];
    }
    if(err == nil){
        if(!isPlayRecord){
            recordPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecoder.url error:&err];
            [recordPlayer play];
            [recordPlayer setDelegate:self];
            _playRecord.hidden = YES;
            _stop_playRecord.hidden = NO;
            [_stop_playRecord setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            [self.view addSubview:_stop_playRecord];
            isPlayRecord = true;
            recordPlay_count++;
            NSLog(@"JJJJ record play %d times",recordPlay_count);
            [recordPlay setText:[NSString stringWithFormat:@"Play_R %d times",recordPlay_count]];
            
        }
    }
    else{
        NSLog(@"JJJ print play mp3 err msg %@",err);
        [_playRecord setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        isPlayRecord =  false;
        //pop up fail time msg.
        [self warningMessage:@"Play_Record"];
    }
}
#pragma mark play record file
-(void)pauseRecordSound:(UIButton *)sender{
    
    if(isPlayRecord == true){
        [recordPlayer stop];
        recordPlayend_count++;
        NSLog(@"JJJJ record pause %d times",recordPlayend_count);
        [recordPlayend setText:[NSString stringWithFormat:@"Stop_R %d times",recordPlayend_count]];
        isPlayRecord = false;
    }
    if(!audioPlayer.playing){
        _stop_playRecord.hidden = YES;
        _playRecord.hidden = NO;
        [_playRecord setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else{
        [self warningMessage:@"Stop_Play_Record"];
    }
    
}



#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
    //    [stopButton setEnabled:NO];
    //    [playButton setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSString *failTitle = [NSString stringWithFormat:@"Finish!!"];
    NSString *failTimes = [NSString stringWithFormat:@"Finish Playing "];
    UIAlertController *finishPlay = [UIAlertController alertControllerWithTitle:failTitle message:failTimes preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
    }];
    [finishPlay addAction:confirm];
    [self presentViewController:finishPlay animated:YES completion:nil];
    
    // for recording play
    if(isPlayRecord == true){
        isPlayRecord = false;
    }
    if(!audioPlayer.playing){
        recordPlayend_count++;
        NSLog(@"JJJJ record pause %d times",recordPlayend_count);
        [recordPlayend setText:[NSString stringWithFormat:@"Stop_R %d times",recordPlayend_count]];
        _stop_playRecord.hidden = YES;
        _playRecord.hidden = NO;
        
        [_playRecord setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
    }
    else{
        [self warningMessage:@"Finish playing fail"];
    }
    
    
    // for music play
    if(isPlay == true){
        [audioPlayer pause];
        softKeyTap_pause++;
        NSLog(@"JJJJ soft pause %d times",softKeyTap_pause);
        isPlay = false;
    }
    if(!audioPlayer.playing){
        _pauseMuzik.hidden = YES;
        _playMuzik.hidden = NO;
        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    }
    else{
        [self warningMessage:@"Finish playing fail"];
    }
    
    
}



#pragma mark UIViewController
- (void)viewWillAppear:(BOOL)animated
{
    // watch for the accessory being disconnected
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    // watch for received data from the accessory
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];
    
    EADSessionController *sessionController = [EADSessionController sharedController];
    
    _accessory = [[sessionController accessory] retain];
    [self setTitle:[sessionController protocolString]];
    [sessionController openSession];
}

-(void)viewDidLoad{
    
    //hsu jay make device not to in sleep mode
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    
    
    //hsu jay can receive remote controller command
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    //read music in resource folder
    url_music = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"happy" ofType:@"mp3"]];
    
    //flag for music is played or not
    isPlay = false;
    isRecord = false;
    isPlayRecord = false;
    // counter initialize
    hardKeyTap_vol = 0 ;
    volumeUp_count = 0;
    volumeDown_count = 0;
    hardKeyTap_play = 0 ;
    hardKeyTap_pause = 0 ;
    softKeyTap_play = 0;
    softKeyTap_pause = 0;
    recordEnd_count = 0;
    recordStart_count = 0;
    recordPlay_count = 0;
    recordPlayend_count = 0;
    
    
    firstVol = audioPlayer.volume;
    [self initAccessory];
    [self initView];
    [self receive_harkeyCmd];
    [self volumeChanged];
    [self statusMusic_test];
    [self recoderInit];
}

-(void)initAccessory{

   accessoryInfo = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
   
}

-(void)initView{
    
    _backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,25, 32, 32)];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    _playMuzik =[UIButton buttonWithType:UIButtonTypeCustom];
    _playMuzik = [[UIButton alloc]initWithFrame:CGRectMake(40,350, 32, 32)];
    [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [_playMuzik addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playMuzik];
    
    _pauseMuzik = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseMuzik = [[UIButton alloc]initWithFrame:CGRectMake(40,350, 32, 32)];
    [_pauseMuzik setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [_pauseMuzik addTarget:self action:@selector(pauseMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pauseMuzik];
    _pauseMuzik.hidden = YES;
    
    _startRecord = [[UIButton alloc]initWithFrame:CGRectMake(40, 175, 35, 35)];
    [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
    [_startRecord addTarget:self action:@selector(setStartRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startRecord];
    
    _stopRecord = [[UIButton alloc]initWithFrame:CGRectMake(40, 175, 35, 35)];
    [_stopRecord setBackgroundImage:[UIImage imageNamed:@"stop_recording"] forState:UIControlStateNormal];
    [_stopRecord addTarget:self action:@selector(setStopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopRecord];
    _stopRecord.hidden = YES;
    
    _playRecord = [[UIButton alloc]initWithFrame:CGRectMake(40, 260, 40, 40)];
    [_playRecord setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playRecord addTarget:self action:@selector(playReord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playRecord];
    
    
    _stop_playRecord = [[UIButton alloc]initWithFrame:CGRectMake(40, 260, 35, 35)];
    [_stop_playRecord setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [_stop_playRecord addTarget:self action:@selector(pauseRecordSound:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stop_playRecord];
    _stop_playRecord.hidden = YES;
    
    
    counter = [[UILabel alloc]initWithFrame:CGRectMake(18, 80, 130, 20)];
    [counter setText:@"Vol 0 time"];
    [counter setFont:[UIFont systemFontOfSize:15]];
    [counter setTextColor:[UIColor blackColor]];
    [self.view addSubview:counter];
    
    
    
    vol = [[UILabel alloc]initWithFrame:CGRectMake(190, 80, 110, 20)];
    [vol setFont:[UIFont systemFontOfSize:15]];
    [vol setTextColor:[UIColor blackColor]];
    
    
    volmeUp_label = [[UILabel alloc]initWithFrame:CGRectMake(counter.frame.origin.x, counter.frame.origin.y+25, 130, 20)];
    [volmeUp_label setFont:[UIFont systemFontOfSize:15]];
    [volmeUp_label setTextColor:[UIColor blackColor]];
    
    
    volumDown_label = [[UILabel alloc]initWithFrame:CGRectMake(vol.frame.origin.x, vol.frame.origin.y+25, 130, 20)];
    [volumDown_label setFont:[UIFont systemFontOfSize:15]];
    [volumDown_label setTextColor:[UIColor blackColor]];
    
    
    hardkeyCounter_play =  [[UILabel alloc]initWithFrame:CGRectMake(18, _pauseMuzik.frame.origin.y+50, 120, 20)];
    [hardkeyCounter_play setText:@"Play 0 time"];
    [hardkeyCounter_play setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:hardkeyCounter_play];
    
    hardkeyCounter_pause = [[UILabel alloc]initWithFrame:CGRectMake(160, _pauseMuzik.frame.origin.y+50, 150, 20)];
    [hardkeyCounter_pause setText:@"Pause 0 time"];
    [hardkeyCounter_pause setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:hardkeyCounter_pause];
    
    
    recordStart = [[UILabel alloc]initWithFrame:CGRectMake(18, _startRecord.frame.origin.y+45, 130, 20)];
    [recordStart setText:@"Record 0 time"];
    [recordStart setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:recordStart];
    
    recordEnd = [[UILabel alloc]initWithFrame:CGRectMake(160, _startRecord.frame.origin.y+45, 150, 20)];
    [recordEnd setText:@"Stop Record 0 time"];
    [recordEnd setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:recordEnd];
    
    recordPlay = [[UILabel alloc]initWithFrame:CGRectMake(18, _playRecord.frame.origin.y+45, 140, 20)];
    [recordPlay setText:@"Play Record 0 time"];
    [recordPlay setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:recordPlay];
    
    recordPlayend = [[UILabel alloc]initWithFrame:CGRectMake(160, _playRecord.frame.origin.y+45, 150, 20)];
    [recordPlayend setText:@"Stop Play_R 0 time"];
    [recordPlayend setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:recordPlayend];
    
}
-(void)backBtn:(UIButton *)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // remove the observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EADSessionDataReceivedNotification object:nil];
    
    EADSessionController *sessionController = [EADSessionController sharedController];
    
    [sessionController closeSession];
    [_accessory release];
    _accessory = nil;
    
    //hsu jay add for when leaving this page, u need to end receive remote control
    [[UIApplication sharedApplication]endReceivingRemoteControlEvents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.receivedBytesLabel = nil;
    self.stringToSendTextField = nil;
    self.hexToSendTextField = nil;
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    hardKeyTap_vol = 0 ;
    volumeUp_count = 0;
    volumeDown_count = 0;
    hardKeyTap_play = 0 ;
    hardKeyTap_pause = 0 ;
    softKeyTap_play = 0;
    softKeyTap_pause = 0;
    failTime = 0;
    recordEnd_count = 0;
    recordStart_count = 0;
    recordPlay_count = 0;
    recordPlayend_count = 0;
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:@"MPMusicPlayerControllerPlaybackStateDidChangeNotification" object:nil];
    [[MPMusicPlayerController applicationMusicPlayer]endGeneratingPlaybackNotifications];
    [audioPlayer stop];
    [audioPlayer release];
    [audioRecoder stop];
    [audioRecoder release];
    [recordPlayer stop];
    [recordPlayer release];
}

-(void)dealloc{
    //removeObserver:(id)observer name:(nullable NSString *)aName object:(nullable id)anObject
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Internal

- (void)_accessoryDidDisconnect:(NSNotification *)notification
{
    if ([[self navigationController] topViewController] == self)
    {
        EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
        if ([disconnectedAccessory connectionID] == [_accessory connectionID])
        {
            [[self navigationController] popViewControllerAnimated:YES];
            
        }
    }
}

// Data was received from the accessory, real apps should do something with this data but currently:
//    1. bytes counter is incremented
//    2. bytes are read from the session controller and thrown away
- (void)_sessionDataReceived:(NSNotification *)notification
{
    EADSessionController *sessionController = (EADSessionController *)[notification object];
    uint32_t bytesAvailable = 0;
    
    while ((bytesAvailable = [sessionController readBytesAvailable]) > 0) {
        NSData *data = [sessionController readData:bytesAvailable];
        if (data) {
            _totalBytesRead += bytesAvailable;
        }
    }
    
    [_receivedBytesLabel setText:[NSString stringWithFormat:@"Bytes Received from Session: %d", _totalBytesRead]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
