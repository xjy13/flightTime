//
//  ScheduleTableCell.m
//  FlightTime
//
//  Created by mac on 2017/6/1.
//
//



#import "ScheduleTableCell.h"
#import "GetSchedule.h"
int row;
BOOL arrival;
NSUserDefaults *usrDefault;
@implementation ScheduleTableCell

-(void)awakeFromNib{
    [super awakeFromNib];
}
//-(void)receiveDepartureArrayxd:(int)count status:(BOOL)isArrival{
//
//    NSLog(@"count = %d",count);
//    row = count;
//    arrival = isArrival;
//     usrDefault = [NSUserDefaults standardUserDefaults];
//    [usrDefault setInteger:row forKey:@"row"];
//}
//
//
//
//- (void)drawRect:(CGRect)rect{
//    [self showInfo:row status:arrival];
//
//
//}
//
//-(void)showInfo:(int)row status:(BOOL)isArrival{
//  
//    NSMutableArray *departArray = [[NSMutableArray alloc]init];
//    NSString *airlineID ;
//    NSString *flightNumber ;
//    NSString *arrivalRemark ;
//    NSString *departureAirport ;
//    NSString *scheduleArrivalTime ;
//
//    if(isArrival == true){
//        //入境的
//       // [GetSchedule jsonArrival:@"cellView"];
//        [departArray addObjectsFromArray:[GetSchedule jsonArrival:@"cellView"]];
//        airlineID = [NSString stringWithFormat:@"%@",[[departArray objectAtIndex:row] objectForKey:@"AirlineID"]];
//        NSLog(@"arrival ---> %@",airlineID);
//        NSLog(@"arrival + 1 --> %@",[[departArray objectAtIndex:row+1] objectForKey:@"AirlineID"]);
//        flightNumber = [NSString stringWithFormat:@"%@",[[departArray objectAtIndex:row] objectForKey:@"FlightNumber"]];
//        arrivalRemark = [[departArray objectAtIndex:row] objectForKey:@"ArrivalRemark"];
//        departureAirport = [[departArray objectAtIndex:row] objectForKey:@"DepartureAirportID"];
//        scheduleArrivalTime = [[departArray objectAtIndex:row]objectForKey:@"ScheduleArrivalTime"];
//        [self.IDLabel setText:[NSString stringWithFormat:@"From : %@",[GetSchedule translateIATA:departureAirport]]];
//    }
//    else{
//        //離境的
//       // [GetSchedule jsonDepature:@"cellView"];
//        
//        [departArray addObjectsFromArray:[GetSchedule jsonDepature:@"cellView"]];
//        airlineID = [[departArray objectAtIndex:row] objectForKey:@"AirlineID"];
//          NSLog(@"departure ---> %@",airlineID);
//        flightNumber = [[departArray objectAtIndex:row] objectForKey:@"FlightNumber"];
//        arrivalRemark = [[departArray objectAtIndex:row] objectForKey:@"DepartureRemark"];
//        departureAirport = [[departArray objectAtIndex:row] objectForKey:@"ArrivalAirportID"];
//        scheduleArrivalTime = [[departArray objectAtIndex:row]objectForKey:@"ScheduleDepartureTime"];
//        [self.IDLabel setText:[NSString stringWithFormat:@"To : %@",[GetSchedule translateIATA:departureAirport]]];
//    }
//
//    
//    
//    [self.flightID setText:[NSString stringWithFormat:@"%@", [GetSchedule figureRegistration:airlineID number:flightNumber]]];
//    
//    
//    NSRange delayNote = [arrivalRemark rangeOfString:@"DELAY" options:NSBackwardsSearch];
//    NSRange changeNote = [arrivalRemark rangeOfString:@"SCHEDULE CHANGE" options:NSBackwardsSearch];
//    NSRange cancelNote = [arrivalRemark rangeOfString:@"CANCEL" options:NSBackwardsSearch];
//    self.ManuLabel.numberOfLines = 0;
//    self.ManuLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.ManuLabel setFont:[UIFont systemFontOfSize:16]];
//    if(delayNote.length > 0 || changeNote.length > 0 ||cancelNote.length > 0){
//        [self.ManuLabel setTextColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]];
//    }
//    else{
//        [self.ManuLabel setTextColor:[UIColor colorWithRed:0.0 green:0.6 blue:0.3 alpha:0.5]];
//    }
//    
//    
//    [self.ManuLabel setText:[NSString stringWithFormat:@"%@, at幹: %@",arrivalRemark,scheduleArrivalTime]];
//
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
