
#import "RootViewController.h"
#import "EADSessionController.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPRemoteCommandEvent.h>
#import "EADemoAppDelegate.h"


#define departureURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Departure/TPE?%24top=6&%24format=JSON"
#define airportInfo @"http://ptx.transportdata.tw/MOTC/v2/Air/Airport"
#define flightInfo @"http://ptx.transportdata.tw/MOTC/v2/Air/Airline"
#define arrival @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Arrival/TPE?%24filter=FlightDate%20eq%20"
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
    
    UILabel *noDatasLabelView;
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
    // Dispose of any resources that can be recreated. 00
}


-(void)initialTable{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, 320, 568)];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320, 900);
    [_scrollView reloadInputViews];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,130, 320, 600)];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Now Date = %@",[self currentDate]);
    [self jsonArrival];
    [self initialTable];
    [self initView];
    [self setupTestEnvironment];
    enterBackgound = false;
    enterFront = true;
    [self enterToFront];
    [self enterToBackground];
   
    //    flightSchedule = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(jsonDeparture) userInfo:nil repeats:YES];
    //    [flightSchedule fire];
    
   
    
}

-(NSString *)currentDate{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSString *currentDateString = [dateFormatter stringFromDate:nowDate];
    NSString *filter = [NSString stringWithFormat:@"%@%@",currentDateString,@"&%24top=6&%24format=JSON"];
    
    NSString *arrvalDate = [arrival stringByAppendingString:filter];
    NSLog(@"new format Date = %@",arrvalDate);
    return  arrvalDate;
}


-(void)viewDidAppear:(BOOL)animated{
   // [super viewDidAppear:animated];
    
    
}


#pragma mark INITIAL parameters
-(void)setupTestEnvironment{
    
    //hsu jay make device not to in sleep mode
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    //hsu jay can receive remote controller command
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    //read music in resource folder
    url_music = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]pathForResource:@"happy" ofType:@"mp3"]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_music error:nil];

//    url_music = [[NSURL alloc] initFileURLWithPath:@"mms://bcr.media.hinet.net/RA000007"];
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_music error:nil];
    
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
    //hsu jay add for when leaving this page, u need to end receive remote control
    [[UIApplication sharedApplication]endReceivingRemoteControlEvents];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self uninstallSetup];
    
}


#pragma mark initial UI
-(void)initView{
    
    _playMuzik =[UIButton buttonWithType:UIButtonTypeCustom];
    _playMuzik = [[UIButton alloc]initWithFrame:CGRectMake(20,20, 32, 32)];
    [_playMuzik setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [_playMuzik addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_playMuzik];
    
    _pauseMuzik = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseMuzik = [[UIButton alloc]initWithFrame:CGRectMake(20,20, 32, 32)];
    [_pauseMuzik setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [_pauseMuzik addTarget:self action:@selector(pauseMusic:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_pauseMuzik];
    _pauseMuzik.hidden = YES;
    
    
    vol = [[UILabel alloc]initWithFrame:CGRectMake(240, 20, 110, 20)];
    [vol setFont:[UIFont systemFontOfSize:15]];
    [vol setTextColor:[UIColor blackColor]];
    [vol setText:[NSString stringWithFormat:@"音量：%.0f",volValue*100]];
   // [_scrollView addSubview:vol];
    
    volmeUp_label = [[UILabel alloc]initWithFrame:CGRectMake(counter.frame.origin.x, counter.frame.origin.y+25, 130, 20)];
    [volmeUp_label setFont:[UIFont systemFontOfSize:15]];
    [volmeUp_label setTextColor:[UIColor blackColor]];
    
    
    volumDown_label = [[UILabel alloc]initWithFrame:CGRectMake(vol.frame.origin.x, vol.frame.origin.y+25, 135, 20)];
    [volumDown_label setFont:[UIFont systemFontOfSize:15]];
    [volumDown_label setTextColor:[UIColor blackColor]];
    
    [volumeView reloadInputViews];
    volumeView = [[MPVolumeView alloc] init];
    [volumeView setFrame:CGRectMake(20.0, volumDown_label.frame.origin.y+20, 250.0, 20.0)];
    [_scrollView addSubview:volumeView];
    
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(270,30, 28, 28)];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshBtn];
    
    
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
    
    return 6;
    
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
    
    static NSString *cellIdentifier = @"scheduleCell";
    NSUInteger row = [indexPath row];
    NSLog(@"Table Row = %d",row);
    // NSLog(@"AIRLINE ID = %@",[[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"]);
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    switch (row) {
        case 0:
            flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            IDLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15, flightID.frame.origin.y+30, 300, 20)];
            ManuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, IDLabel.frame.origin.y+30, 300, 20)];
            airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
          
            flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
            [self figureRegistration:airlineID];
            [self figureRegistration_new:airlineID id:airlineID number:flightNumber];

            arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
            departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
          
            scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
            //            gateNumber = [[arrivalArray objectAtIndex:row]objectForKey:@"Gate"];
            //            terminal = [[arrivalArray objectAtIndex:row]objectForKey:@"Terminal"];
            [flightID setText:[NSString stringWithFormat:@"%@",airlineID_full]];
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",[self translateIATA:departureAirport]]];
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
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",[self translateIATA:departureAirport]]];
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
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",[self translateIATA:departureAirport]]];
            [ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
            
            [cell addSubview:flightID];
            [cell addSubview:IDLabel];
            [cell addSubview:ManuLabel];
            break;
        case 4:
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
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",[self translateIATA:departureAirport]]];
            [ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
            
            [cell addSubview:flightID];
            [cell addSubview:IDLabel];
            [cell addSubview:ManuLabel];
            
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
            [IDLabel setText:[NSString stringWithFormat:@"From : %@",[self translateIATA:departureAirport]]];
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
    else{
        [self warningMessage:@"Stop_Play_Record"];
    }
    
}


-(void)test_dBFS{
    [recordPlayer updateMeters];
    float avgdB = [recordPlayer averagePowerForChannel:0];
    float peakdB = [recordPlayer peakPowerForChannel:0];
    long valueDBFS = 20*log10(fabs(avgdB)/44100);
    float recordTime = [recordPlayer currentTime];
    
    NSLog(@"JJJ DB avg = %.2f and peak = %.2f and dBFS = %ld",avgdB,peakdB,valueDBFS);
    
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
        [self jsonArrival];
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



-(void)jsonArrival{
    [self currentDate];
 //      NSString *arrivalLink = [NSString stringWithFormat:<#(nonnull NSString *), ...#>]
    NSError *err = nil;
    NSURL *url = [NSURL URLWithString:[self currentDate]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];

    NSLog(@"get json data = %@",data);
    if(data != nil){
        NSInputStream *inStream = [[NSInputStream alloc] initWithData:data];
        [inStream open];
        _arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Departure json : %@",_arrivalArray);
        [inStream close];
        //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:arrivalURL]];
        [_tableView reloadData];
        noDatasLabelView.hidden = YES;
    }
    else{
        noDatasLabelView = [[UILabel alloc]initWithFrame:CGRectMake(115, 250, 240, 50)];
        [noDatasLabelView setText:@"No Data....."];
        [noDatasLabelView setFont:[UIFont systemFontOfSize:25]];
        [self.view addSubview:noDatasLabelView];
        noDatasLabelView.hidden = NO;
    }
    
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
    if([code isEqualToString:@"CI"]){
        airlineID_full = [NSString stringWithFormat:@"中華航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"AE"]){
        airlineID_full = [NSString stringWithFormat:@"華信航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"BR"]){
        airlineID_full = [NSString stringWithFormat:@"長榮航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"B7"]){
        airlineID_full = [NSString stringWithFormat:@"立榮航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"GE"]){
        airlineID_full = [NSString stringWithFormat:@"復興航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"VZ"]){
        airlineID_full = [NSString stringWithFormat:@"威航-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"FE"]){
        airlineID_full = [NSString stringWithFormat:@"遠東航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"CX"]){
        airlineID_full = [NSString stringWithFormat:@"國泰航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"KA"]){
        airlineID_full = [NSString stringWithFormat:@"港龍航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"HX"]){
        airlineID_full = [NSString stringWithFormat:@"香港航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"CA"]){
        airlineID_full = [NSString stringWithFormat:@"中國國際-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"MU"]){
        airlineID_full = [NSString stringWithFormat:@"中國東方-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"CZ"]){
        airlineID_full = [NSString stringWithFormat:@"中國南方-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"JL"]){
        airlineID_full = [NSString stringWithFormat:@"日本航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"NH"]){
        airlineID_full = [NSString stringWithFormat:@"全日本空輸-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"VN"]){
        airlineID_full = [NSString stringWithFormat:@"越南航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"SQ"]){
        airlineID_full = [NSString stringWithFormat:@"新加坡航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"KE"]){
        airlineID_full = [NSString stringWithFormat:@"大韓民航-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"OZ"]){
        airlineID_full = [NSString stringWithFormat:@"韓亞航-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"UA"]){
        airlineID_full = [NSString stringWithFormat:@"美國航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"DL"]){
        airlineID_full = [NSString stringWithFormat:@"達美航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"KL"]){
        airlineID_full = [NSString stringWithFormat:@"荷蘭航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"EK"]){
        airlineID_full = [NSString stringWithFormat:@"阿聯酋航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"MH"]){
        airlineID_full = [NSString stringWithFormat:@"馬來西亞航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"TG"]){
        airlineID_full = [NSString stringWithFormat:@"泰國航空-%@%@ ",airlineID,flightNumber];
    }
    else if([code isEqualToString:@"PG"]){
        airlineID_full = [NSString stringWithFormat:@"菲律賓航空-%@%@ ",airlineID,flightNumber];
    }
    else{
        airlineID_full = [NSString stringWithFormat:@"來台灣-%@%@ ",airlineID,flightNumber];
    }
    
    NSLog(@"airlineID_full departure = %@",airlineID_full);
    
    
}


-(void)figureRegistration_new:(NSString *)flightCode id:(NSString *)airlineID number:(NSString *)flightNumber{
    NSLog(@"airline code = %@",flightCode);
    
    //using ios 9.0 method
    NSURLSessionConfiguration *configObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: configObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *IATAinfo = [NSString stringWithFormat:@"%@/%@?format=JSON",flightInfo,flightCode];
    NSURL *url = [NSURL URLWithString:IATAinfo];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response,NSError *err ){
        NSHTTPURLResponse *urlResponse =(NSHTTPURLResponse *)response;
        NSLog(@"Http response = %d",[urlResponse statusCode]);
        if([urlResponse statusCode] == 200 && err == nil){
            _flightArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"flight json = %@",_flightArray);
            NSString *airlineInfo = [NSString stringWithFormat:@"%@-%@%@ ",[[_flightArray objectForKey:@"AirlineNameAlias"] objectForKey:@"Zh_tw"],airlineID,flightNumber];
             NSLog(@"flight name = %@",airlineInfo);
            
            _scrollView.hidden = NO;
            noDatasLabelView.hidden = YES;
        }
        else{
            NSLog(@"err = %@ and response code = %d",err,[urlResponse statusCode]);
            noDatasLabelView = [[UILabel alloc]initWithFrame:CGRectMake(115, 250, 240, 50)];
            [noDatasLabelView setText:@"No Data....."];
            [noDatasLabelView setFont:[UIFont systemFontOfSize:25]];
            [self.view addSubview:noDatasLabelView];
            _scrollView.hidden = YES;
            noDatasLabelView.hidden = NO;
        }
    }];
   
    [dataTask resume];
   
    
}

-(NSString *)translateIATA:(NSString *)airportCode{
    NSError *err = nil;
    NSLog(@"airport code = %@",airportCode);
    NSString *IATAinfo = [NSString stringWithFormat:@"%@/%@?format=JSON",airportInfo,airportCode];   //JFK?$format=JSON
    NSURL *url = [NSURL URLWithString:IATAinfo];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if(data != nil){
        _airportArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Airport json : %@,  %d",_airportArray,[_airportArray count]);
        _scrollView.hidden = NO;
        noDatasLabelView.hidden = YES;
        NSString *airportName = [[_airportArray objectForKey:@"AirportName"] objectForKey:@"Zh_tw"];
        if([airportName isEqualToString:@""]){
            airportName = airportCode;
        }
        return  airportName;
    }
    else{
        noDatasLabelView = [[UILabel alloc]initWithFrame:CGRectMake(115, 250, 240, 50)];
        [noDatasLabelView setText:@"No Data....."];
        [noDatasLabelView setFont:[UIFont systemFontOfSize:25]];
        [self.view addSubview:noDatasLabelView];
        _scrollView.hidden = YES;
        noDatasLabelView.hidden = NO;
    }
       //NSArray *portName = [[_airportArray objectAtIndex:4]objectForKey:@"AirportName"];
}


@end
