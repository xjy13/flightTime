//
//  ScheduleTableCell.m
//  FlightTime
//
//  Created by mac on 2017/6/1.
//
//



#import "ScheduleTableCell.h"
#import "GetSchedule.h"

@implementation ScheduleTableCell

-(void)awakeFromNib{
    [super awakeFromNib];

}
//-(void)receiveDepartureArray:(NSMutableArray *)array{
//
//    NSLog(@"aaaa ----> %@",[[array objectAtIndex:0] objectForKey:@"ArrivalRemark"]);
//    self.a = [[array objectAtIndex:0] objectForKey:@"ArrivalRemark"];
//    
//
//}

-(void)receiveDepartureArrayxd:(int)row{
    NSLog(@"xdd = %d",row);
//    [GetSchedule jsonArrival:@"cellView"];
//    NSMutableArray *departArray = [[NSMutableArray alloc]init];
//    [departArray addObjectsFromArray:[GetSchedule jsonArrival:@"cellView"]];
//    NSLog(@"XDDDD ----> %@",[[departArray objectAtIndex:row] objectForKey:@"DepartureAirportID"]);
//    self.a = [NSString stringWithFormat:@"%@",[[departArray objectAtIndex:row] objectForKey:@"DepartureAirportID"]];
}


- (void)drawRect:(CGRect)rect{
    [GetSchedule jsonArrival:@"cellView"];
    NSMutableArray *departArray = [[NSMutableArray alloc]init];
    [departArray addObjectsFromArray:[GetSchedule jsonArrival:@"cellView"]];
    self.a = [NSString stringWithFormat:@"%@",[[departArray objectAtIndex:9] objectForKey:@"DepartureAirportID"]];

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
     NSLog(@"self.a = %@",self.a);
        self.title.text = self.a;
    });
   
  //  [self.title setText:@"ob''ov"];


}
//-(void)receiveDepartureArray:(NSMutableArray *)array status:(BOOL)isArrival{
//
//}

@end

/*
 
 case 0:
 
 
 "FlightDate": "2017-02-18",
 "FlightNumber": "100",
 "AirRouteType": 1,
 "AirlineID": "JW",
 "DepartureAirportID": "TPE",
 "ArrivalAirportID": "NRT",
 "ScheduleDepartureTime": "2017-02-18T02:05",
 "ActualDepartureTime": "2017-02-18T02:44",
 "DepartureRemark": "出發",
 "DepartureTerminal": "1",
 "DepartureGate": "A2",
 "CheckCounter": "1",
 "UpdateTime": "2017-02-18T14:56:06+08:00"
 



flightID = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
IDLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15, flightID.frame.origin.y+30, 300, 20)];
ManuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, IDLabel.frame.origin.y+30, 300, 25)];


if(isArrival == true){
    //入境的
    airlineID = [[_arrivalArray objectAtIndex:row] objectForKey:@"AirlineID"];
    flightNumber = [[_arrivalArray objectAtIndex:row] objectForKey:@"FlightNumber"];
    arrivalRemark = [[_arrivalArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
    departureAirport = [[_arrivalArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
    scheduleArrivalTime = [[_arrivalArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
    [IDLabel setText:[NSString stringWithFormat:@"From : %@",[GetSchedule translateIATA:departureAirport]]];
    
}
else{
    //離境的
    airlineID = [[_departureArray objectAtIndex:row] objectForKey:@"AirlineID"];
    flightNumber = [[_departureArray objectAtIndex:row] objectForKey:@"FlightNumber"];
    arrivalRemark = [[_departureArray objectAtIndex:row] objectForKey:@"DepartureRemark"];
    departureAirport = [[_departureArray objectAtIndex:row] objectForKey:@"ArrivalAirportID"];
    scheduleArrivalTime = [[_departureArray objectAtIndex:row]objectForKey:@"ScheduleDepartureTime"];
    [IDLabel setText:[NSString stringWithFormat:@"To : %@",[GetSchedule translateIATA:departureAirport]]];
}

[flightID setText:[NSString stringWithFormat:@"%@", [GetSchedule figureRegistration:airlineID number:flightNumber]]];


NSRange delayNote = [arrivalRemark rangeOfString:@"DELAY" options:NSBackwardsSearch];
NSRange changeNote = [arrivalRemark rangeOfString:@"SCHEDULE CHANGE" options:NSBackwardsSearch];
NSRange cancelNote = [arrivalRemark rangeOfString:@"CANCEL" options:NSBackwardsSearch];
ManuLabel.numberOfLines = 0;
ManuLabel.lineBreakMode = NSLineBreakByWordWrapping;
[ManuLabel setFont:[UIFont systemFontOfSize:16]];
if(delayNote.length > 0 || changeNote.length > 0 ||cancelNote.length > 0){
    [ManuLabel setTextColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]];
}
else{
    [ManuLabel setTextColor:[UIColor colorWithRed:0.0 green:0.6 blue:0.3 alpha:0.5]];
}

[ManuLabel setText:[NSString stringWithFormat:@"%@, at: %@",arrivalRemark,scheduleArrivalTime]];
[cell addSubview:flightID];
[cell addSubview:IDLabel];
[cell addSubview:ManuLabel];
break;



 */
