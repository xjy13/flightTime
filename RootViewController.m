
#import "RootViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "FlightTimeDelegate.h"
#import "Toast+UIView.h"
#import "GetLocation.h"
#import "MapGoogle.h"
#import "GetWeather.h"
#import "WeatherSign.h"
#import "ExtensionView.h"

@interface RootViewController(){

    
    NSString *airlineID;
    NSString *airlineID_full;
    NSString *flightNumber;
    NSString *arrivalRemark;
    NSString *departureAirport;
    NSString *scheduleArrivalTime;
    NSString *EstimatedTime;
    NSString *ActualTime;
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
    UITapGestureRecognizer *tapAction;
    UITapGestureRecognizer *tapAction2;


    float firstVol;
    float volValue ;
    UILabel *counter;
    UILabel *vol;
    UILabel *volmeUp_label;
    UILabel *volumDown_label;
    UILabel *hardkeyCounter_play;
    UILabel *hardkeyCounter_pause;
    
    BOOL isConnect;
    BOOL isArrival;
    NSURL* url_music;
    NSURL *recordPath;
    
    
    NSString *recordRate;
    NSString *recordChannel;
    NSTimer *checkdB;
   
    MBProgressHUD *hudView;
  //  GetSDelegate *Get;
    ScheduleTableCell *scheduleCell;
    WeatherSign *weatherSign_1;
    WeatherSign *weatherSign_2;
    
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
    // [self testSemphore];
    hudView.delegate = self;
    hudView = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hudView];
     isArrival = true;
    [self initialTable];
    [self initView];
//    [self setupTestEnvironment];
//    enterBackgound = false;
//    enterFront = true;
//    [self enterToFront];
//    [self enterToBackground];
   
    self.flightSchedule = [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    [self.flightSchedule fire];
//    ExtensionView *extView = [[ExtensionView alloc]init];
//     extView = [[ExtensionView alloc]initWithFrame:CGRectMake(0, 150, 200, 30)];
//    extView.gateLabel.text = @"第五號登機門";
//    extView.terminalLabel.text = @"第二航廈";
//    extView.counterLabel.text = @"第八號轉盤" ;
//    [self.view addSubview:extView];

    
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
//-(void)getSchdule_delegation{
//     self.arrivalArray =  [GetSchedule jsonArrival:@"root"];
//    self.departureArray = [GetSchedule jsonDepature:@"root"];
//     NSLog(@"at rootView arrival = %@ ", _arrivalArray);
//    NSLog(@"at rootView departure = %@ ", _departureArray);
// 
//}


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

    [self weatherSignShow:@"TPE"];
    

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
    
     scheduleCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     scheduleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self scheduleBoard:row];
    return scheduleCell;
  
}


-(void)scheduleBoard:(NSUInteger)row{
    
    if(isArrival == true){
        //入境的
//        [_departureArray removeAllObjects];
        [_arrivalArray addObjectsFromArray:[GetSchedule jsonArrival:@"cellView"]];
        airlineID = [NSString stringWithFormat:@"%@",[[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"]];
        
        flightNumber = [NSString stringWithFormat:@"%@",[[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"]];
        arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
        departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
        scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
        EstimatedTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"EstimatedArrivalTime"];
        ActualTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ActualArrivalTime"];

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
//        [_airportArray removeAllObjects];
        [_departureArray addObjectsFromArray:[GetSchedule jsonDepature:@"cellView"]];
        airlineID = [[_departureArray objectAtIndex:row] objectForKey:@"AirlineID"];
        NSLog(@"departure ---> %@",airlineID);
        flightNumber = [[_departureArray objectAtIndex:row] objectForKey:@"FlightNumber"];
        arrivalRemark = [[_departureArray objectAtIndex:row] objectForKey:@"DepartureRemark"];
        departureAirport = [[_departureArray objectAtIndex:row] objectForKey:@"ArrivalAirportID"];
        scheduleArrivalTime = [[_departureArray objectAtIndex:row]objectForKey:@"ScheduleDepartureTime"];
        EstimatedTime = [[_departureArray objectAtIndex:row]objectForKey:@"EstimatedDepartureTime"];
        ActualTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ActualDepartureTime"];
        [scheduleCell.IDLabel setText:[NSString stringWithFormat:@"To : %@",[GetSchedule translateIATA:departureAirport]]];
     }
    
   
    [scheduleCell.flightID setText:[NSString stringWithFormat:@"%@", [GetSchedule figureRegistration:airlineID number:flightNumber]]];
    NSRange delayNote = [arrivalRemark rangeOfString:@"DELAY" options:NSBackwardsSearch];
     NSRange changeNote = [arrivalRemark rangeOfString:@"SCHEDULE CHANGE" options:NSBackwardsSearch];
     NSRange cancelNote = [arrivalRemark rangeOfString:@"CANCEL" options:NSBackwardsSearch];
    scheduleCell.ManuLabel.numberOfLines = 0;
    scheduleCell.ManuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if(delayNote.length > 0 || changeNote.length > 0 ||cancelNote.length > 0){
        [scheduleCell.ManuLabel setTextColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]];
        scheduleCell.backgroundColor = [[UIColor alloc]initWithRed:240.0/255.0 green:200.0/255.0 blue:70.0/255.0 alpha:0.8];
        [scheduleCell.ManuLabel setFont:[UIFont systemFontOfSize:14]];
        [self warningMessage:[[GetSchedule figureRegistration:airlineID number:flightNumber] stringByAppendingString:arrivalRemark]];

       
//        NSLog(@"flightStatus ---->%@",arrivalRemark);
        if([arrivalRemark hasPrefix:@"時間更改"]){
            [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@,at: %@",[arrivalRemark substringToIndex:4],EstimatedTime]];
        }
        else if ([arrivalRemark hasPrefix:@"取消"]){
            [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@,at: %@",arrivalRemark,scheduleArrivalTime]];
        }
        else{
            [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@,at: %@",arrivalRemark,EstimatedTime]];
        }
        
    }
    else{
        [scheduleCell.ManuLabel setTextColor:[UIColor colorWithRed:0.0 green:0.6 blue:0.3 alpha:0.5]];
        if([arrivalRemark hasPrefix:@"已到"] || [arrivalRemark hasPrefix:@"出發"]){
           [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,ActualTime]];
        }
        if([arrivalRemark hasPrefix:@"準時"]){
           [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
        }
        else{
            [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
        }
      
    }
     //  [scheduleCell.ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
  
    
    tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFunction:)];
    tapAction.numberOfTapsRequired = 1;
    tapAction.numberOfTouchesRequired = 1;
   
     scheduleCell.IDLabel.userInteractionEnabled = YES;
    [scheduleCell.IDLabel addGestureRecognizer:tapAction];
     scheduleCell.IDLabel.tag = row;
  
     tapAction2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFunction:)];
     [scheduleCell.flightID addGestureRecognizer:tapAction2];
     scheduleCell.flightID.userInteractionEnabled = YES;
     scheduleCell.flightID.tag =row+101;
     
//    [scheduleCell.ManuLabel addGestureRecognizer:tapAction];
//    scheduleCell.ManuLabel.tag = row;
//    scheduleCell.ManuLabel.userInteractionEnabled = YES;
    

}

-(void)tapFunction:(UIGestureRecognizer *)gesture {
    int i = (int)gesture.view.tag;
     NSLog(@"gesture info %@",gesture);
     if(i < 100){
          NSString *airport ;
          if(isArrival == true){
                  airport =[NSString stringWithFormat:@"%@",[[_arrivalArray objectAtIndex:i] objectForKey:@"DepartureAirportID"]];
              }
          else{
                  airport =[NSString stringWithFormat:@"%@",[[_departureArray objectAtIndex:i] objectForKey:@"ArrivalAirportID"]];
              }
          NSLog(@"i am in %d row  ---> %@",i,airport);
             [self weatherSignShow:airport];

     }
     else{
     
     }
         
    
    

}

#pragma mark Warning message when get failure
-(void)warningMessage:(NSString *)msg{
    UIAlertController *alertMsg = [[UIAlertController alloc]init];
    if([msg length] > 0){
        alertMsg = [UIAlertController alertControllerWithTitle:@"注意" message:msg preferredStyle: UIAlertControllerStyleActionSheet];
      
    }

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"打電話問" style:UIAlertActionStyleCancel handler:^(UIAlertAction *confirm)
    {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://0987654321"]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertMsg addAction:confirm];
    [alertMsg addAction:cancel];
    [self presentViewController:alertMsg animated:YES completion:nil];
}


// refresh schedule
-(void)refreshTable:(UIButton *)btn {
    NSLog(@"refresh schedule");
   
    hudView.labelText = @"載入中";
    [_tableView addSubview:hudView];
    [hudView show:YES];
    
    if(isArrival == true){
        _refreshBtn.userInteractionEnabled = NO;
        [self refreshTable];
       // [self weatherSignShow];
   //     [hudView setHidden:YES];
       //   [self.view makeToast:@"哈哈哈哈哈哈哈哈" duration:2.0 position:@"center"];
        
        
    }else{
      //  [self jsonDeparture];
    }
    [hudView hide:YES afterDelay:5];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

}
-(void)refreshTable{
    NSLog(@"refresh schedule");
    self.arrivalArray =  [GetSchedule jsonArrival:@"root"];
    self.departureArray = [GetSchedule jsonDepature:@"root"];
    NSLog(@"at rootView arrival = %@ ", _arrivalArray);
    NSLog(@"at rootView departure = %@ ", _departureArray);

    
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
   // [self weatherSignShow:@"TPE"];
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
      [hudView hide:YES afterDelay:5];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)departureTable:(UIButton *)btn{
    NSLog(@"show departure table");
    [_departureBtn setTitleColor:[UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:23.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     [_arrivalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    isArrival = false;
    [GetSchedule jsonDepature:@"root"];
      [hudView hide:YES afterDelay:5];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)weatherSignShow:(NSString *)iataCode{
    
    dispatch_queue_t getWeatherQueue = dispatch_queue_create("getWeather", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(getWeatherQueue, ^{
        CLLocationManager *locationCurrent = [[CLLocationManager alloc]init];
        locationCurrent.delegate = self;
        locationCurrent.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        float currentLatitude = locationCurrent.location.coordinate.latitude;
        float currentLongitude = locationCurrent.location.coordinate.longitude;
        if(currentLatitude != 0.0 && currentLongitude != 0.0){
               [WeatherSign loc:[NSString stringWithFormat:@"%.2f,%.2f",currentLatitude,currentLongitude]];
        }
        else{
            [WeatherSign loc:[NSString stringWithFormat:@"25.0051539,121.5060025"]];

        }
        
        [weatherSign_1 removeFromSuperview];
        weatherSign_1 = [[WeatherSign alloc]initWithFrame:CGRectMake(0.5, 0, self.view.frame.size.width/2, 80)];
        [_scrollView addSubview:weatherSign_1];
    
    });
   
   
    dispatch_sync(getWeatherQueue, ^{
     
        [WeatherSign loc:iataCode];
        [weatherSign_2 removeFromSuperview];
        weatherSign_2 = [[WeatherSign alloc]initWithFrame:CGRectMake(160.5,0, self.view.frame.size.width/2, 80)];
        [_scrollView addSubview:weatherSign_2];
        
        
    });


}

-(void)testSemphore{

     NSLog(@"Happy Start");
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
     NSLog(@"Ssem number!! %@",sem);
    // dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
     //[NSThread sleepForTimeInterval:3];
     dispatch_semaphore_signal(sem);
     dispatch_async(dispatch_get_main_queue(), ^{
          NSLog(@"signal");
//          dispatch_semaphore_signal(sem);
          NSLog(@"XDDDD--->1");
         dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
          NSLog(@"wait");
        //  dispatch_semaphore_signal(sem);
           NSLog(@"XDDDD--->2");
          dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
          NSLog(@"wait");
          //dispatch_semaphore_signal(sem);
          NSLog(@"XDDDD--->3");
         // dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
          NSLog(@"waitXDDDDFFFGSDF");
            NSLog(@"Ssem number!! %@",sem);

     });
//
     
//     NSLog(@"Before wait");
//     dispatch_semaphore_wait(sem,DISPATCH_TIME_FOREVER);
//     NSLog(@"After wait");
    

}
#pragma mark 新的





@end
