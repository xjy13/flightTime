
#import "RootViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPRemoteCommandEvent.h>
#import "FlightTimeDelegate.h"
#import "Toast+UIView.h"
#import "GetLocation.h"
#import "MapGoogle.h"
#import "GetWeather.h"
#import "WeatherSign.h"
@interface RootViewController(){

    
    NSString *airlineID;
    NSString *airlineID_full;
    NSString *flightNumber;
    NSString *arrivalRemark;
    NSString *departureAirport;
    NSString *scheduleArrivalTime;
    NSString *gateNumber ;
    NSString *terminal;
    NSString *ticketCode;
    
    UILabel *noDatasLabelView;
    UILabel *flightID;
    UILabel *IDLabel;
    UILabel *ManuLabel;
    UILabel *serialLabel;
    UILabel *IDLabel_D;
    
    UIImageView *warningSign;
    UIGestureRecognizer *tapAction;
    


    float firstVol;
    float volValue ;
    UILabel *counter;
    UILabel *vol;
    UILabel *volmeUp_label;
    UILabel *volumDown_label;
    UILabel *hardkeyCounter_play;
    UILabel *hardkeyCounter_pause;
    
//    BOOL pause_test;
//    BOOL enterBackgound;
//    BOOL enterFront;
    BOOL isConnect;
    BOOL isArrival;
    NSURL* url_music;
    NSURL *recordPath;
    
    MPVolumeView *volumeView;
    NSUserDefaults *volumeValueBefore;
    
    
    NSString *recordRate;
    NSString *recordChannel;
    NSTimer *checkdB;
    NSTimer *flightSchedule;
    MBProgressHUD *hudView;
    GetSchedule *Get;
    ScheduleTableCell *scheduleCell;
    WeatherSign *weatherSign;
}
@end

@implementation RootViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. 00
}



- (void)viewDidLoad {
    [super viewDidLoad];
    hudView.delegate = self;
    hudView = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hudView];
     isArrival = true;
    self.refresh = [[UIRefreshControl alloc]init];
    [self.refresh addTarget:self action:@selector(refreshXD) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:self.refresh];
    [self initialTable];
    [self initView];
//    [self setupTestEnvironment];
//    enterBackgound = false;
//    enterFront = true;
//    [self enterToFront];
//    [self enterToBackground];
   
    flightSchedule = [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    [flightSchedule fire];
  
    
    
}

-(void)refreshXD{

    
    NSLog(@"refresh~~~~");

}
#pragma mark initial Table
-(void)initialTable{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, 320, 568)];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320, 2210);
    [_scrollView reloadInputViews];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,130, 320, 2000)];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
     [self.tableView registerNib:[UINib nibWithNibName:@"SchduleTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView reloadData];
    [_tableView reloadInputViews];
    [_scrollView addSubview:_tableView];
    
//    UILabel *seperate = [[UILabel alloc]initWithFrame:CGRectMake(0,125, 320, 0.8)];
//    [seperate setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
//    [_scrollView addSubview:seperate];
    [self.view addSubview:_scrollView];
  }


#pragma mark delegate use
-(void)getSchdule_delegation{
     self.arrivalArray =  [GetSchedule jsonArrival:@"root"];
    self.departureArray = [GetSchedule jsonDepature:@"root"];
     NSLog(@"at rootView arrival = %@ ", _arrivalArray);
    NSLog(@"at rootView departure = %@ ", _departureArray);
 
}


- (void)viewWillDisappear:(BOOL)animated
{
    //hsu jay add for when leaving this page, u need to end receive remote control
    [[UIApplication sharedApplication]endReceivingRemoteControlEvents];
}

-(void)viewDidDisappear:(BOOL)animated{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshTable) object:nil];
     
}


#pragma mark initial UI
-(void)initView{
    
//    vol = [[UILabel alloc]initWithFrame:CGRectMake(260, 25, 110, 20)];
//    [vol setFont:[UIFont systemFontOfSize:14]];
//    [vol setTextColor:[UIColor blackColor]];
//    [vol setText:[NSString stringWithFormat:@"VOL:%.0f",volValue*100]];
//    [_scrollView addSubview:vol];
    
//    volmeUp_label = [[UILabel alloc]initWithFrame:CGRectMake(counter.frame.origin.x, counter.frame.origin.y+25, 130, 20)];
//    [volmeUp_label setFont:[UIFont systemFontOfSize:15]];
//    [volmeUp_label setTextColor:[UIColor blackColor]];
    
    
//    volumDown_label = [[UILabel alloc]initWithFrame:CGRectMake(vol.frame.origin.x, vol.frame.origin.y+25, 135, 20)];
//    [volumDown_label setFont:[UIFont systemFontOfSize:15]];
//    [volumDown_label setTextColor:[UIColor blackColor]];
    
//    [volumeView reloadInputViews];
//    volumeView = [[MPVolumeView alloc] init];
//    [volumeView setFrame:CGRectMake(60, 25, 190.0, 20.0)];
//    [_scrollView addSubview:volumeView];
    
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(270,30, 28, 28)];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshBtn];
    
    
    _toMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _toMapBtn = [[UIButton alloc]initWithFrame:CGRectMake(28,30, 30, 30)];
    [_toMapBtn setBackgroundImage:[UIImage imageNamed:@"place"] forState:UIControlStateNormal];
    [_toMapBtn addTarget:self action:@selector(setToMapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toMapBtn];

    
    _arrivalBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,80, 160, 45)];
    [_arrivalBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:.2 blue:.3 alpha:.5]];
     [_arrivalBtn setTitleColor:[UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:23.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_arrivalBtn setTitle:@"Arrival" forState:UIControlStateNormal];
    [_arrivalBtn addTarget:self action:@selector(arrivalTable:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_arrivalBtn];
   
    _departureBtn = [[UIButton alloc]initWithFrame:CGRectMake(160,80, 160, 45)];
    [_departureBtn setBackgroundColor:[UIColor colorWithRed:0.1 green:.3 blue:.2 alpha:.5]];
    [_departureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_departureBtn addTarget:self action:@selector(departureTable:) forControlEvents:UIControlEventTouchUpInside];
    [_departureBtn setTitle:@"Departure" forState:UIControlStateNormal];
    [_scrollView addSubview:_departureBtn];
//    
    weatherSign = [[WeatherSign alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
  
    [_scrollView addSubview:weatherSign];


}



#pragma mark access to next

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
      return [self.arrivalArray count];
   
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, , 10)];
//    footer.backgroundColor = [UIColor clearColor];
//    
//    UILabel *lbl = [[UILabel alloc]initWithFrame:footer.frame];
//    lbl.backgroundColor = [UIColor clearColor];
//    lbl.text = @"下面還有喔";
//    lbl.textAlignment = NSTextAlignmentCenter;
//    [footer addSubview:lbl];
//    
//    return footer;
//}



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
    
//    static NSString *cellIdentifier = @"scheduleCell";
//    static NSString *reUseIndetifier =@"cell";
//     static NSString *reUseIndetifier1 =@"cell1";
    NSUInteger row = [indexPath row];
    NSLog(@"Table Row = %ld",row);
  
     scheduleCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     scheduleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self scheduleBoard:row];
    return scheduleCell;
  
}


-(void)scheduleBoard:(int)row{

    if(isArrival == true){
        //入境的
        [_departureArray removeAllObjects];
        [_arrivalArray addObjectsFromArray:[GetSchedule jsonArrival:@"cellView"]];
        airlineID = [NSString stringWithFormat:@"%@",[[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"]];
        
        flightNumber = [NSString stringWithFormat:@"%@",[[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"]];
        arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
        departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
        scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
        [scheduleCell.IDLabel setText:[NSString stringWithFormat:@"From : %@",[GetSchedule translateIATA:departureAirport]]];

     
    }
    else{
        
        /*
         "FlightDate": "2017-06-19",
         "FlightNumber": "809",
         "AirlineID": "BR",
         "DepartureAirportID": "TPE",
         "ArrivalAirportID": "HKG",
         "ScheduleDepartureTime": "2017-06-19T19:00",
         "ActualDepartureTime": "2017-06-19T19:04",
         "EstimatedDepartureTime": "2017-06-19T19:04",
         "DepartureRemark": "出發DEPARTED",
         "Terminal": "2",
         "Gate": "C5R",
         "CheckCounter": "12",
         "UpdateTime": "2017-06-20T19:04:45+08:00"
         */
        
        //離境的
        [_airportArray removeAllObjects];
        [_departureArray addObjectsFromArray:[GetSchedule jsonDepature:@"cellView"]];
        airlineID = [[_departureArray objectAtIndex:row] objectForKey:@"AirlineID"];
        NSLog(@"departure ---> %@",airlineID);
        flightNumber = [[_departureArray objectAtIndex:row] objectForKey:@"FlightNumber"];
        arrivalRemark = [[_departureArray objectAtIndex:row] objectForKey:@"DepartureRemark"];
        departureAirport = [[_departureArray objectAtIndex:row] objectForKey:@"ArrivalAirportID"];
        scheduleArrivalTime = [[_departureArray objectAtIndex:row]objectForKey:@"ScheduleDepartureTime"];
         [scheduleCell.IDLabel setText:[NSString stringWithFormat:@"To : %@",[GetSchedule translateIATA:departureAirport]]];
     }
    
   
    [scheduleCell.flightID setText:[NSString stringWithFormat:@"%@", [GetSchedule figureRegistration:airlineID number:flightNumber]]];
    NSRange delayNote = [arrivalRemark rangeOfString:@"DELAY" options:NSBackwardsSearch];
     NSRange changeNote = [arrivalRemark rangeOfString:@"SCHEDULE CHANGE" options:NSBackwardsSearch];
     NSRange cancelNote = [arrivalRemark rangeOfString:@"CANCEL" options:NSBackwardsSearch];
    scheduleCell.ManuLabel.numberOfLines = 0;
    scheduleCell.ManuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [scheduleCell.ManuLabel setFont:[UIFont systemFontOfSize:16]];
    if(delayNote.length > 0 || changeNote.length > 0 ||cancelNote.length > 0){
        [scheduleCell.ManuLabel setTextColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]];
        scheduleCell.backgroundColor = [[UIColor alloc]initWithRed:240.0/255.0 green:200.0/255.0 blue:70.0/255.0 alpha:0.8];
        [self warningMessage:[[GetSchedule figureRegistration:airlineID number:flightNumber] stringByAppendingString:arrivalRemark]];
    }
    else{
        [scheduleCell.ManuLabel setTextColor:[UIColor colorWithRed:0.0 green:0.6 blue:0.3 alpha:0.5]];
       
    }
    
    [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];

}

#pragma mark Warning message when get failure
-(void)warningMessage:(NSString *)msg{
    UIAlertController *alertMsg = [[UIAlertController alloc]init];
    if([msg length] > 0){
        alertMsg = [UIAlertController alertControllerWithTitle:@"注意" message:msg preferredStyle:UIAlertControllerStyleAlert];
    }

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel)
    {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertMsg addAction:confirm];
    [alertMsg addAction:cancel];
    [self presentViewController:alertMsg animated:YES completion:nil];
}


//-(void)enterToFront{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toFront:) name:UIApplicationWillEnterForegroundNotification object:nil];
//    
//}
//-(void)toFront:(NSNotification *)noti{
//    if(!enterFront){
//     //   [self setupTestEnvironment];
//        [self refreshTable];
//        [self enterToBackground];
//       // [flightSchedule fire];
//        enterBackgound = false;
//    }
//}


//-(void)enterToBackground{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterToBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    
//}

//-(void)enterToBackground:(NSNotification *)nofi{
//    if(!enterBackgound){
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_MSEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
//           // [self uninstallSetup];
//            [flightSchedule invalidate];
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(receive_harkeyCmd:) object:nil];
//            NSLog(@"really go to background!!");
//        });
//        
//        enterBackgound = true;
//        enterFront = false;
//    }
//    
//}


// refresh schedule
-(void)refreshTable:(UIButton *)btn {
    NSLog(@"refresh schedule");
   
    hudView.labelText = @"載入中";
    [hudView show:YES];
    if(isArrival == true){
        _refreshBtn.userInteractionEnabled = NO;
        [self getSchdule_delegation];
        
   //     [hudView setHidden:YES];
       //   [self.view makeToast:@"哈哈哈哈哈哈哈哈" duration:2.0 position:@"center"];
        
        
    }else{
      //  [self jsonDeparture];
    }
    [hudView hide:YES afterDelay:20];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

}
-(void)refreshTable{
    NSLog(@"refresh schedule");
    [self getSchdule_delegation];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

-(void)setToMapBtn:(UIButton *)btn{
    [self performSegueWithIdentifier:@"googleMap" sender:btn];


}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"googleMap"]) {
        MapGoogle *mapView = [segue destinationViewController];
      //  goodView.userUID = self.userUid;
    }
}


-(void)arrivalTable:(UIButton *)btn{
    NSLog(@"show arrival table");
    [_arrivalBtn setTitleColor:[UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:23.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_departureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    isArrival = true;
    //原本的
    [GetSchedule jsonArrival:@"root"];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)departureTable:(UIButton *)btn{
    NSLog(@"show departure table");
    [_departureBtn setTitleColor:[UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:23.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     [_arrivalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    isArrival = false;
    [GetSchedule jsonDepature:@"root"];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark 新的





@end
