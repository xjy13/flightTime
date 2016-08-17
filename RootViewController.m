
#import "RootViewController.h"
#import "EADSessionController.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPRemoteCommandEvent.h>
#import "EADemoAppDelegate.h"

#define arrivalURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Arrival/TPE?%24top=6&%24format=JSON"
#define departureURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Departure/TPE?%24top=6&%24format=JSON"

typedef enum AppFunction{
    AppFunction_GetAccessoryInformation = 0,
    AppFunction_PlayAudio,
    AppFunction_PauseAudio,
    AppFunction_ReturnButtonCount,
    AppFunction_StartVoiceRecord,
    AppFunction_StopVoiceRecord,// ( app 端 stop 後 要去算Quanlity )
    AppFunction_PlayRecordAudio,
    AppFunction_StopRecordAudio,
    AppFunction_ReturnVoiceLevel,  //(error  當還在運行 )(error code   定義)
    AppFunction_ReturnVoiceLevel_stop
}AppFunction;


@interface RootViewController(){
    UILabel *EAmaun ;
    UILabel *EAname;
    UILabel *EAConnectID;
    
    NSString *eaAccessoryName ;
    NSString *eaAccessoryConnectionID ;
    NSString *eaAccessoryManufacturer ;
    NSString *eaAccessorymodelNumber ;
    NSString *eaAccessoryserialNumber ;
    NSString *eaAccessoryFirmware ;
    NSString *eaAccessoryHarware ;
    NSString *eaAccessoryDockType ;
    
    
    NSString *airlineID;
    NSString *airlineID_full;
    NSString *flightNumber;
    NSString *arrivalRemark;
    NSString *departureAirport;
    NSString *scheduleArrivalTime;
    NSString *gateNumber ;
    NSString *terminal;

    
    UILabel *flightID;
    UILabel *IDLabel;
    UILabel *ManuLabel;
    UILabel *modelLabel;
    UILabel *serialLabel;
    UILabel *fmLabel;
    UILabel *hwLabel;
    UILabel *dockLabel;
    int failTime;
    UIAlertController *failAlert;
    UIImageView *warningSign;
    UIGestureRecognizer *tapAction;
    
    
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
    int recordStart_count;
    int recordEnd_count;
    int recordPlay_count;
    int recordPlayend_count;
    float firstVol;
    float volValue ;
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
    
    BOOL pause_test;
    BOOL enterBackgound;
    BOOL enterFront;
    BOOL isConnect;
    NSURL* url_music;
    NSURL *recordPath;
    
    MPVolumeView *volumeView;
    NSUserDefaults *volumeValueBefore;
    TalkToMac* module;
    
    NSString *recordRate;
    NSString *recordChannel;
    NSTimer *checkdB;
    NSTimer *flightSchedule;
    EADemoAppDelegate *EADemo;
}
@end

@implementation RootViewController

- (void)dealloc
{
    [super dealloc];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initialTable{
   
    NSLog(@"QQQ = %@",_accessoryList);
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, 320, 568)];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320, 800);
    [_scrollView reloadInputViews];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,130, 320, 400)];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView reloadData];
    [_tableView reloadInputViews];
    [_scrollView addSubview:_tableView];
    
    UILabel *seperate = [[UILabel alloc]initWithFrame:CGRectMake(0,125, 320, 0.8)];
    [seperate setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
    [_scrollView addSubview:seperate];
    
    [self.view addSubview:_scrollView];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    // watch for the accessory being disconnected
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    // watch for received data from the accessory
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];
    
    //EADSessionController *sessionController = [EADSessionController sharedController];
    
    //    _accessory = [[sessionController accessory] retain];
    //    [self setTitle:[sessionController protocolString]];
    //    [sessionController openSession];
}

- (void)viewDidLoad {
     [super viewDidLoad];
    module = [[TalkToMac alloc] init];
    module.delegate = self;
    [module creatConnect];
    _noExternalAccessoriesLabelView = [[UILabel alloc] initWithFrame:CGRectMake(60, 180, 240, 50)];
    [_noExternalAccessoriesLabelView setText:@"No Accessories Connected"];
    [self.view addSubview:_noExternalAccessoriesLabelView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    _eaSessionController = [EADSessionController sharedController];
    
    _accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    NSLog(@"original accessory list =%@",_accessoryList);
    if([_accessoryList count] > 1 ){
        if([[[_accessoryList objectAtIndex:0]dockType] isEqualToString:@"Unknown"]){
            [_accessoryList removeObjectAtIndex:1];
        }
        else{
            [_accessoryList removeObjectAtIndex:0];
        }
    }
    NSLog(@"accessoryList = %@",_accessoryList );
    
    if ([_accessoryList count] == 0) {
        [_scrollView removeFromSuperview];
        _noExternalAccessoriesLabelView.hidden = NO;
    }
    else{
         [self initialTable];
        [self initView];
        _noExternalAccessoriesLabelView.hidden = YES;
    }

    
    [self setupTestEnvironment];
    enterBackgound = false;
    enterFront = true;
    [self enterToFront];
    [self enterToBackground];
    [self jsonArrival];
    //    flightSchedule = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(jsonDeparture) userInfo:nil repeats:YES];
//    [flightSchedule fire];
    
 

}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}


#pragma mark INITIAL parameters
-(void)setupTestEnvironment{

    //hsu jay make device not to in sleep mode
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    //hsu jay can receive remote controller command
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    //read music in resource folder
    
    url_music = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"happy" ofType:@"mp3"]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_music error:nil];
    
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
    volumeDown_count = 0;
    volumeUp_count = 0;
    firstVol = [[NSUserDefaults standardUserDefaults]floatForKey:@"before"];
    
    [self receive_harkeyCmd];
    [self volumeChanged];
    [self recoderInit];
    
    [audioPlayer play];
    [audioPlayer stop];
}




- (void)viewWillDisappear:(BOOL)animated
{
    // remove the observers
    
//    EADSessionController *sessionController = [EADSessionController sharedController];
    
//    [sessionController closeSession];
//    [_accessory release];
//    _accessory = nil;
    
    //hsu jay add for when leaving this page, u need to end receive remote control
    [[UIApplication sharedApplication]endReceivingRemoteControlEvents];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self uninstallSetup];
    
}


#pragma mark initial UI
-(void)initView{
    
    _playMuzik =[UIButton buttonWithType:UIButtonTypeCustom];
    _playMuzik = [[UIButton alloc]initWithFrame:CGRectMake(150,100, 32, 32)];
    [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [_playMuzik addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_playMuzik];
    
    _pauseMuzik = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseMuzik = [[UIButton alloc]initWithFrame:CGRectMake(150,100, 32, 32)];
    [_pauseMuzik setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [_pauseMuzik addTarget:self action:@selector(pauseMusic:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_pauseMuzik];
    _pauseMuzik.hidden = YES;
    
    
    vol = [[UILabel alloc]initWithFrame:CGRectMake(240, 20, 110, 20)];
    [vol setFont:[UIFont systemFontOfSize:15]];
    [vol setTextColor:[UIColor blackColor]];
    [vol setText:[NSString stringWithFormat:@"音量：%.0f",volValue*100]];
    [_scrollView addSubview:vol];
    
    volmeUp_label = [[UILabel alloc]initWithFrame:CGRectMake(counter.frame.origin.x, counter.frame.origin.y+25, 130, 20)];
    [volmeUp_label setFont:[UIFont systemFontOfSize:15]];
    [volmeUp_label setTextColor:[UIColor blackColor]];
    
    
    volumDown_label = [[UILabel alloc]initWithFrame:CGRectMake(vol.frame.origin.x, vol.frame.origin.y+25, 135, 20)];
    [volumDown_label setFont:[UIFont systemFontOfSize:15]];
    [volumDown_label setTextColor:[UIColor blackColor]];
    
    [volumeView reloadInputViews];
    volumeView = [[MPVolumeView alloc] init];
    [volumeView setFrame:CGRectMake(20.0, volumDown_label.frame.origin.y+10, 290.0, 20.0)];
    [_scrollView addSubview:volumeView];
    
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(280,40, 32, 32)];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"warning"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshBtn];

    
}


#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (_selectedAccessory && (buttonIndex >= 0) && (buttonIndex < [[_selectedAccessory protocolStrings] count]))
    {
        [_eaSessionController setupControllerForAccessory:_selectedAccessory
                                       withProtocolString:[[_selectedAccessory protocolStrings] objectAtIndex:buttonIndex]];
        //  EADSessionTransferViewController *sessionTransferViewController =
        //     [[EADSessionTransferViewController alloc] initWithNibName:@"EADSessionTransfer" bundle:nil];
        
        //        [[self navigationController] pushViewController:sessionTransferViewController animated:YES];
        
        
        //        [sessionTransferViewController release];
     //   [self performSegueWithIdentifier:@"testPage" sender:self];
   
    }
    
    [_selectedAccessory release];
    _selectedAccessory = nil;
    [_protocolSelectionActionSheet release];
    _protocolSelectionActionSheet = nil;
}

#pragma mark access to next
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    if ([segue.identifier isEqualToString:@"testPage"]) {
//        EADSessionTransferViewController *EADTransView =[segue destinationViewController];
//    }
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSLog(@"JJJ row count: %d",[_accessoryList count]);
//    if([_accessoryList count] == 0){
//        return [_accessoryList count];
//    }
//    else{
    
        return 6;
  //  }
}


//分割線補滿
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *eaAccessoryCellIdentifier = @"eaAccessoryCellIdentifier";
    NSUInteger row = [indexPath row];
    NSLog(@"JJJJ row = %d",row);
   // NSLog(@"AIRLINE ID = %@",[[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"]);

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:eaAccessoryCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:eaAccessoryCellIdentifier] autorelease];
    }
    
    
    switch (row) {
        case 0:
            flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            IDLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15, flightID.frame.origin.y+30, 300, 20)];
            ManuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, IDLabel.frame.origin.y+30, 300, 20)];
            airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
            flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
            [self figureRegistration:airlineID];

            arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
            departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
            scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
//            gateNumber = [[arrivalArray objectAtIndex:row]objectForKey:@"Gate"];
//            terminal = [[arrivalArray objectAtIndex:row]objectForKey:@"Terminal"];
            
            [flightID setText:[NSString stringWithFormat:@"%@",airlineID_full]];
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",departureAirport]];
            [ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];

            [cell addSubview:flightID];
            [cell addSubview:IDLabel];
            [cell addSubview:ManuLabel];
            break;
        case 1:
            flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            IDLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15, flightID.frame.origin.y+30, 300, 20)];
            ManuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, IDLabel.frame.origin.y+30, 300, 20)];
            airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
            flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
            [self figureRegistration:airlineID];
            
            arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
            departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
            scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
            //            gateNumber = [[arrivalArray objectAtIndex:row]objectForKey:@"Gate"];
            //            terminal = [[arrivalArray objectAtIndex:row]objectForKey:@"Terminal"];
            
            [flightID setText:[NSString stringWithFormat:@"%@",airlineID_full]];
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",departureAirport]];
            [ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
            
            [cell addSubview:flightID];
            [cell addSubview:IDLabel];
            [cell addSubview:ManuLabel];
            break;
        case 2:
            flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            IDLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15, flightID.frame.origin.y+30, 300, 20)];
            ManuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, IDLabel.frame.origin.y+30, 300, 20)];
            airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
            flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
            [self figureRegistration:airlineID];
            
            arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
            departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
            scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
            //            gateNumber = [[arrivalArray objectAtIndex:row]objectForKey:@"Gate"];
            //            terminal = [[arrivalArray objectAtIndex:row]objectForKey:@"Terminal"];
            
            [flightID setText:[NSString stringWithFormat:@"%@",airlineID_full]];
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",departureAirport]];
            [ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
            
            [cell addSubview:flightID];
            [cell addSubview:IDLabel];
            [cell addSubview:ManuLabel];
            break;
        case 3:
            flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            IDLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15, flightID.frame.origin.y+30, 300, 20)];
            ManuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, IDLabel.frame.origin.y+30, 300, 20)];
            airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
            flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
            [self figureRegistration:airlineID];
            
            arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
            departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
            scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
            [flightID setText:[NSString stringWithFormat:@"%@",airlineID_full]];
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",departureAirport]];
            [ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
            
            [cell addSubview:flightID];
            [cell addSubview:IDLabel];
            [cell addSubview:ManuLabel];
            break;
        case 4:
            flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
            flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
            [self figureRegistration:airlineID];
            //            departureRemark = [[arrivalArray objectAtIndex:row] objectForKey:@" DepartureRemark"];
            //            scheduleDepartureTime = [[arrivalArray objectAtIndex:row]objectForKey:@"ScheduleDepartureTime"];
            //            gateNumber = [[arrivalArray objectAtIndex:row]objectForKey:@"Gate"];
            //            terminal = [[arrivalArray objectAtIndex:row]objectForKey:@"Terminal"];
            
            [flightID setText:[NSString stringWithFormat:@"%@",airlineID_full]];
            [cell addSubview:flightID];
            break;
        case 5:
            flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            IDLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15, flightID.frame.origin.y+30, 300, 20)];
            ManuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, IDLabel.frame.origin.y+30, 300, 20)];
            airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
            flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
            [self figureRegistration:airlineID];
            
            arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
            departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
            scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
            //            gateNumber = [[arrivalArray objectAtIndex:row]objectForKey:@"Gate"];
            //            terminal = [[arrivalArray objectAtIndex:row]objectForKey:@"Terminal"];
            
            [flightID setText:[NSString stringWithFormat:@"%@",airlineID_full]];
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",departureAirport]];
            [ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
            
            [cell addSubview:flightID];
            [cell addSubview:IDLabel];
            [cell addSubview:ManuLabel];
            break;
        default:;
        break;
    }
    
    return cell;
}



#pragma mark test play music on screen
-(void)playMusic:(UIButton *)sender{
    _pauseMuzik.hidden = YES;
    NSError *err = nil;
    NSLog(@"JJJ mp3 url %@",audioPlayer.url);
    if(err == nil){
        if(!isPlay){
            [audioPlayer play];
            _playMuzik.hidden = YES;
            _pauseMuzik.hidden = NO;
            [audioPlayer setDelegate:self];
            [_pauseMuzik setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
            [_scrollView addSubview:_pauseMuzik];
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
    NSLog(@"JJJ hard cmd start");
        NSError *err = nil;
    if(!isPlay){
        MPRemoteCommand *playCmd = [commandCenter togglePlayPauseCommand];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_music error:&err];
        // if we set loops to -1, it will play infinity.
        audioPlayer.numberOfLoops = 5;
        [playCmd addTarget:self action:@selector(playAudioHardkey:)];
    }
    
}
-(void)receive_harkeyCmdStop:(NSNotification *)noti{
    
    NSLog(@"JJJ hard cmd stop = %@",noti);
    NSError *err = nil;
    if(!isPlay){
        MPRemoteCommand *pauseCmd = [commandCenter togglePlayPauseCommand];
        [pauseCmd addTarget:self action:@selector(stopAudioHardkey:) ];
    }
}


#pragma mark test by headset hard key
-(void)playAudioHardkey:(MPRemoteCommand *)cmd{
    NSLog(@"JJJJ  remote command = %@",cmd);
   
    _pauseMuzik.hidden = YES;
    NSError *err = nil;
    if(err == nil && cmd !=nil){
        if(!isPlay){
             [audioPlayer play];
            if(audioPlayer.playing){
                _playMuzik.hidden = YES;
                _pauseMuzik.hidden = NO;
                [_pauseMuzik setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
                [_scrollView addSubview:_pauseMuzik];
                isPlay = true;
                hardKeyTap_play++;
                [audioPlayer setDelegate:self];
                [hardkeyCounter_play setText:[NSString stringWithFormat:@"Play pass %d time",hardKeyTap_play]];
                NSLog(@"JJJJ play %d times",hardKeyTap_play);
            }
        }
        else{
            [self stopAudioHardkey:cmd];
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



#pragma mark stop audio
-(void)stopAudioHardkey:(MPRemoteCommand *)cmd{
    NSError *err = nil;
    if(cmd != nil && err == nil){
          [audioPlayer pause];
        if(!audioPlayer.playing){
            _playMuzik.hidden = NO;
            _pauseMuzik.hidden = YES;
            if(!audioPlayer.playing){
                [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
                isPlay =false;
                hardKeyTap_pause++;
                [hardkeyCounter_pause setText:[NSString stringWithFormat:@"Pause pass %d time",hardKeyTap_pause]];
                NSLog(@"JJJJ pause %d times",hardKeyTap_pause);
            }
        }
    }else{
        NSLog(@"JJJ print play mp3 err msg %@",err);
        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        isPlay =  false;
        //pop up fail time msg
        [self warningMessage:@"Hard Key"];
    }
}

#pragma mark test music control
-(void)volumeChanged{
    [[NSNotificationCenter defaultCenter]addObserver:self
     selector:@selector(volumeChange:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
  }

#pragma mark adjust volume up and down
-(void)volumeChange:(NSNotification *)notification{
    
    NSLog(@"JJJJ noti info %@",notification);
    
    [counter removeFromSuperview];
    [vol removeFromSuperview];
    
    volValue = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if(notification){
            if(hardKeyTap_vol == 0){
                if(firstVol > volValue){
                    volumeDown_count++;
                    NSLog(@"volume down = %d",volumeDown_count);
//                    [volumDown_label setText:[NSString stringWithFormat:@"Vol down %d time(s)",volumeDown_count]];
//                    [_scrollView addSubview:volumDown_label];
                    audioPlayer.volume = volValue;
                }
                if(firstVol < volValue){
                    volumeUp_count++;
                    NSLog(@"volume up = %d",volumeUp_count);
//                    [volmeUp_label setText:[NSString stringWithFormat:@"Vol up %d time(s)",volumeUp_count]];
//                    [_scrollView addSubview:volmeUp_label];
                    audioPlayer.volume = volValue;
                }
            }
            if(hardKeyTap_vol > 0){
                if(audioPlayer.volume > volValue){
                    volumeDown_count++;
                    NSLog(@"volume down = %d",volumeDown_count);
//                    [volumDown_label setText:[NSString stringWithFormat:@"Vol down %d time(s)",volumeDown_count]];
//                    [_scrollView addSubview:volumDown_label];
                    audioPlayer.volume = volValue;
                }
                if(audioPlayer.volume < volValue){
                    volumeUp_count++;
                    NSLog(@"volume up = %d",volumeUp_count);
                    [volmeUp_label setText:[NSString stringWithFormat:@"Vol up %d time(s)",volumeUp_count]];
                //    [_scrollView addSubview:volmeUp_label];
                    audioPlayer.volume = volValue;
                }
                //volume is 0 or 1 max min
                else{
                    NSLog(@"MAX or MIN");
                }
            }
            hardKeyTap_vol = volumeDown_count+volumeUp_count;
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
//    [_scrollView addSubview:counter];
    [_scrollView addSubview:vol];
    
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

#pragma mark Record setting
-(void)recoderInit{
    NSError *err = nil;
    NSArray *pathComponents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *componentsDir = [pathComponents objectAtIndex:0];
    recordPath  = [NSURL fileURLWithPath:[componentsDir stringByAppendingPathComponent:@"test.m4a"]];
    
    // 設定錄音格式
     NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
  
    
    audioRecoder = [[AVAudioRecorder alloc] initWithURL:recordPath settings:recordSetting error:&err];
    audioRecoder.delegate = self;
    audioRecoder.meteringEnabled = YES;
    
   // [audioRecoder prepareToRecord];
  //  audioSession = [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
  
    
}
#pragma mark recording
-(void)setStartRecord:(UIButton *)sender{
  //  NSLog(@"sender = %@",sender);
     NSError *err;
    AVAudioSession *recordSession = [AVAudioSession sharedInstance];
    [recordSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
//    if(audioPlayer.playing || recordPlayer.playing){
//        [audioPlayer stop];
//        [_playMuzik setTitle:@"Play Music" forState:UIControlStateNormal];
//        _pauseMuzik.hidden = YES;
//        
//        [recordPlayer stop];
//        [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
//        
//        _stopRecord.hidden = YES;
//    }
   
    if(!isRecord){
        if(!audioRecoder.recording){
            [recordSession setActive:YES error:&err];
            [audioRecoder record];
            recordStart_count++;
            NSLog(@"JJJJ record pass %d time",recordStart_count);
            [audioRecoder updateMeters];
          
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
    else{
        if(err == nil){
            if(!isPlayRecord){
                recordPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecoder.url error:&err];
                recordPlayer.meteringEnabled = true;
                [recordPlayer play];
                [recordPlayer setDelegate:self];
                _playRecord.hidden = YES;
                _stop_playRecord.hidden = NO;
                [_stop_playRecord setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [_scrollView addSubview:_stop_playRecord];
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
//    if(!audioPlayer.playing){
//        _stop_playRecord.hidden = YES;
//        _playRecord.hidden = NO;
//        [_playRecord setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    }
    else{
        [self warningMessage:@"Stop_Play_Record"];
    }
    
}

 NSMutableArray *avg_dBfs;
-(void)test_dBFS{
    [recordPlayer updateMeters];
     float avgdB = [recordPlayer averagePowerForChannel:0];
     float peakdB = [recordPlayer peakPowerForChannel:0];
     long valueDBFS = 20*log10(fabs(avgdB)/44100);
     float recordTime = [recordPlayer currentTime];
    
     NSLog(@"JJJ DB avg = %.2f and peak = %.2f and dBFS = %ld",avgdB,peakdB,valueDBFS);
     [module sendMessage:[NSString stringWithFormat:@"averge dB = %f",avgdB]];
     [module sendMessage:[NSString stringWithFormat:@"peak dB = %f",peakdB]];
     [module sendMessage:[NSString stringWithFormat:@"dBFS  = %ld",valueDBFS]];
}


#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [_startRecord setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
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
        [checkdB invalidate];
        checkdB = nil;
        [checkdB release];
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
//    if(isPlay == true){
//        [audioPlayer pause];
//        softKeyTap_pause++;
//        NSLog(@"JJJJ soft pause %d times",softKeyTap_pause);
//        isPlay = false;
//    }
//    if(!audioPlayer.playing){
//        _pauseMuzik.hidden = YES;
//        _playMuzik.hidden = NO;
//        [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
//    }
//    else{
//        [self warningMessage:@"Finish playing fail"];
//    }
    
    
}



#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //   NSUInteger row = [indexPath row];
    _selectedAccessory = [[_accessoryList objectAtIndex:0] retain];
    
    _protocolSelectionActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Protocol" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    NSArray *protocolStrings = [_selectedAccessory protocolStrings];
    for(NSString *protocolString in protocolStrings) {
        [_protocolSelectionActionSheet addButtonWithTitle:protocolString];
    }
    
    [_protocolSelectionActionSheet setCancelButtonIndex:[_protocolSelectionActionSheet addButtonWithTitle:@"Cancel"]];
    [_protocolSelectionActionSheet showInView:[self tableView]];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Internal

- (void)_accessoryDidConnect:(NSNotification *)notification {
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    NSLog(@"EAAccessory key = %@",connectedAccessory);
    [_accessoryList addObject:connectedAccessory];
    
    if ([_accessoryList count] == 0) {
        _noExternalAccessoriesLabelView.hidden = NO;
        [_scrollView removeFromSuperview];
        [self uninstallSetup];
    }
    else {
        [_scrollView removeFromSuperview];
        [self setupTestEnvironment];
        [self initialTable];
        [self initView];
        _noExternalAccessoriesLabelView.hidden = YES;
        
    }
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([_accessoryList count] - 1) inSection:0];
    
    //[_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)_accessoryDidDisconnect:(NSNotification *)notification {
    EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if (_selectedAccessory && [disconnectedAccessory connectionID] == [_selectedAccessory connectionID])
    {
        [_protocolSelectionActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }
    
    int disconnectedAccessoryIndex = 0;
    for(EAAccessory *accessory in _accessoryList) {
        NSLog(@"disconnect accessory = %@",accessory);
        if ([disconnectedAccessory connectionID] == [accessory connectionID]) {
            break;
        }
        disconnectedAccessoryIndex++;
    }
    NSLog(@"JJJJ disconnectedAccessoryIndex = %d",disconnectedAccessoryIndex);
    if (disconnectedAccessoryIndex < [_accessoryList count]) {
        [_accessoryList removeObjectAtIndex:disconnectedAccessoryIndex];
        } else {
        NSLog(@"could not find disconnected accessory in accessory list");
    }
    
    if ([_accessoryList count] == 0) {
        [_scrollView removeFromSuperview];
        [self uninstallSetup];
        _noExternalAccessoriesLabelView.hidden = NO;
        
    }
    else {
         [_scrollView removeFromSuperview];
        _noExternalAccessoriesLabelView.hidden = YES;
        [self setupTestEnvironment];
        [self initialTable];
        [self initView];
    }
}


-(void)uninstallSetup{

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
    volumeUp_count = 0;
    volumeDown_count = 0;
    [audioPlayer stop];
    [audioRecoder stop];
    [recordPlayer stop];
    volumeValueBefore = [NSUserDefaults standardUserDefaults];
    NSLog(@"volume = %f",firstVol);
    [volumeValueBefore setFloat:firstVol forKey:@"before"];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:@"MPMusicPlayerControllerPlaybackStateDidChangeNotification" object:nil];
    [[MPMusicPlayerController applicationMusicPlayer]endGeneratingPlaybackNotifications];
   
}

-(void)enterToFront{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toFront:) name:UIApplicationWillEnterForegroundNotification object:nil];

}
-(void)toFront:(NSNotification *)noti{
    if(!enterFront){
        [self setupTestEnvironment];
        [self enterToBackground];
        enterBackgound = false;
    }
}


-(void)enterToBackground{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterToBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

-(void)enterToBackground:(NSNotification *)nofi{
    if(!enterBackgound){
            dispatch_after(1, dispatch_get_main_queue(), ^(void){
                [self uninstallSetup];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(receive_harkeyCmd:) object:nil];
                 NSLog(@"really go to background!!");
        });
        
        enterBackgound = true;
        enterFront = false;
    }

}


#pragma mark  TalkToMac Delegate
-(void)showMessage:(NSString *)message{
    NSLog(@"message=%@",message);
    NSArray *strArray = [message componentsSeparatedByString:@":"];
    if ([strArray count]<3) {
        return;
    }
    int functionNumber =[[strArray objectAtIndex:2] intValue];
    NSLog(@"message=%@",message);
    NSLog(@"functionNumber=%d",functionNumber);
    NSString *result;
    NSError *err = nil;
    
    switch (functionNumber) {
        case AppFunction_GetAccessoryInformation: //--->0
            //Todo
            [module sendMessage:eaAccessoryName];
//            [module sendMessage:accessoryData_ConnectionID];
            [module sendMessage:eaAccessoryManufacturer];
            [module sendMessage:eaAccessorymodelNumber];
            [module sendMessage:eaAccessoryserialNumber];
            [module sendMessage:eaAccessoryFirmware];
            [module sendMessage:eaAccessoryHarware];
            [module sendMessage:eaAccessoryDockType];
            break;
        case AppFunction_PlayAudio: //--->1
            if(!isPlay && err == nil){
                NSLog(@"control console play");
               [self playAudioHardkey:[commandCenter togglePlayPauseCommand]];
            }
            break;
        case AppFunction_PauseAudio: //--->2
            //Todo
            if(isPlay == true && err == nil){
            [self playAudioHardkey:[commandCenter togglePlayPauseCommand]];
            }
            break;
        case AppFunction_ReturnButtonCount: //--->3
            result= [NSString stringWithFormat:@"volume count = %d , volume up = %d , volume down =%d , play = %d , pause = %d",hardKeyTap_vol,volumeUp_count,volumeDown_count,hardKeyTap_play,hardKeyTap_pause];
            [module sendMessage:result];
            break;
        case AppFunction_StartVoiceRecord: //--->4
            //Todo
            [self setStartRecord:_startRecord.tag];
            break;
        case AppFunction_StopVoiceRecord: //--->5
            [self setStopRecord:_stopRecord.tag];
            //Todo
            break;
        case  AppFunction_PlayRecordAudio: //--->6
            //todo
            [self playReord:_playRecord.tag];
            break;
        case  AppFunction_StopRecordAudio: //--->7
            [self pauseRecordSound:_stop_playRecord.tag];
            break;
        case AppFunction_ReturnVoiceLevel: //--->8
            //Todo 錄音品質
            [self playReord:_playRecord.tag];
            checkdB = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(test_dBFS) userInfo:nil repeats:YES];
            [checkdB fire];
            break;
        case AppFunction_ReturnVoiceLevel_stop: //--->9
            [checkdB invalidate];
        default:
            break;
    }
}

-(void)jsonArrival{
    NSError *err = nil;
    NSURL *url = [NSURL URLWithString:arrivalURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    _arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Departure json : %@",_arrivalArray);
   
}
// refresh schedule
-(void)refreshTable:(UIButton *)btn {
    NSLog(@"refresh schedule");
    [self jsonArrival];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

/*-(void)jsonDeparture{
    NSError *err = nil;
    NSURL *url = [NSURL URLWithString:departureURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    

    NSMutableArray *departureArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Departure json : %@",departureArray);
    //  NSDictionary
    NSString *airlineID = [[departureArray objectAtIndex:0] objectForKey:@"AirlineID"];
    NSString *airlineID_full;
    NSString *flightNumber = [[departureArray objectAtIndex:0] objectForKey:@"FlightNumber"];
    NSString *departureRemark = [[departureArray objectAtIndex:0] objectForKey:@" DepartureRemark"];
    NSString *scheduleDepartureTime = [[departureArray objectAtIndex:0]objectForKey:@"ScheduleDepartureTime"];
    NSString *gateNumber = [[departureArray objectAtIndex:0]objectForKey:@"Gate"];
    NSString *terminal = [[departureArray objectAtIndex:0]objectForKey:@"Terminal"];
    
    NSLog(@"Flight ID: %@",airlineID);
    if([airlineID isEqualToString:@"CI"]){
        airlineID_full = [NSString stringWithFormat:@"中華航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"BR"]){
        airlineID_full = [NSString stringWithFormat:@"長榮航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"GE"]){
        airlineID_full = [NSString stringWithFormat:@"復興航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"CX"]){
        airlineID_full = [NSString stringWithFormat:@"國泰航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"MU"]){
        airlineID_full = [NSString stringWithFormat:@"中國東方-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"CZ"]){
        airlineID_full = [NSString stringWithFormat:@"中國南方-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"JL"]){
        airlineID_full = [NSString stringWithFormat:@"日本航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"KE"]){
        airlineID_full = [NSString stringWithFormat:@"大韓民航-%@%@ ",airlineID,flightNumber];
    }
    else{
         airlineID_full = [NSString stringWithFormat:@"離開台灣-%@%@ ",airlineID,flightNumber];
    }
    
    NSLog(@"airlineID_full departure = %@",airlineID_full);


}*/

-(void)figureRegistration:(NSString *)code{
    if([airlineID isEqualToString:@"CI"]){
        airlineID_full = [NSString stringWithFormat:@"中華航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"BR"]){
        airlineID_full = [NSString stringWithFormat:@"長榮航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"GE"]){
        airlineID_full = [NSString stringWithFormat:@"復興航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"CX"]){
        airlineID_full = [NSString stringWithFormat:@"國泰航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"CA"]){
     airlineID_full = [NSString stringWithFormat:@"中國國際-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"MU"]){
        airlineID_full = [NSString stringWithFormat:@"中國東方-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"CZ"]){
        airlineID_full = [NSString stringWithFormat:@"中國南方-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"JL"]){
        airlineID_full = [NSString stringWithFormat:@"日本航空-%@%@ ",airlineID,flightNumber];
    }
    else if([airlineID isEqualToString:@"KE"]){
        airlineID_full = [NSString stringWithFormat:@"大韓民航-%@%@ ",airlineID,flightNumber];
    }
    else{
        airlineID_full = [NSString stringWithFormat:@"來台灣-%@%@ ",airlineID,flightNumber];
    }
    
    NSLog(@"airlineID_full departure = %@",airlineID_full);



}

@end
