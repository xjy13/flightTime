//
//  GetSchedule.m
//  FlightTime
//
//  Created by mac on 2016/10/28.
//
//
#import <Foundation/Foundation.h>
#import "GetSchedule.h"
//#define departureURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Departure/TPE?%24top=6&%24format=JSON"
//#define diqiURL @"https://asset.diqi.us/api/v1/users/profile/"
//#define ticketNumber @"http://ptx.transportdata.tw/MOTC/v2/Account/Login?UserData.account=xjy13&UserData.password=da3dbdA%23&%24format=JSON"
@interface GetSchedule()
@end
NSMutableArray *arrivalArray;
NSMutableArray *departureArray;
NSString *status;
NSString *ticketCode;

@implementation GetSchedule
//-(void)jsonArrivalXD:(NSString *)comeFrom{
//    NSLog(@"comeFrom = %@",comeFrom);
////          if(![comeFrom isEqualToString:@""]){
//        NSError *err = nil;
//        NSURL *url = [NSURL URLWithString:arrivalURL];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
//        _arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"Departure json from Delegate : %@",_arrivalArray);
//        //        NSString *airlineID = [[_arrivalArray objectAtIndex:0] objectForKey:@"AirlineID"];
//        //        return airlineID;
//        //   }
//        NSLog(@"JJJ pass!!");
        
//    }

//-(NSString *)getAirApiticket:(RootViewController *)rootView {
//    NSError *err = nil;
//    NSHTTPURLResponse *res = nil;
//    NSURL *url = [NSURL URLWithString:ticketNumber];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSData *ticketData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
//
//    _tickGet = [NSJSONSerialization JSONObjectWithData:ticketData options:NSJSONReadingMutableContainers error:&err];
//    NSLog(@"_ticketGet = %@",_tickGet);
//    if(ticketData !=nil && [res statusCode] == 200){
//         status = [_tickGet valueForKey:@"Status"];
//         ticketCode = [_tickGet valueForKey:@"Ticket"];
//         NSLog(@"ticketCode = %@",ticketCode);
//    }
//    else{
//        NSLog(@"getTicker status_code = %d",[res statusCode]);
//        ticketCode = nil;
//    }
//    
//     return ticketCode;
//
//}

static GetSchedule *_instance = nil;
+(instancetype)shareInstance{

    dispatch_once_t oneCall;
    dispatch_once(&oneCall, ^{
        _instance = [[GetSchedule allocWithZone:NULL]init];
    });
    return _instance;

}

+(NSMutableArray *)jsonArrival:(NSString *)from{
    NSLog(@"comeFrom = %@",from);
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSURL *url = [NSURL URLWithString:[self currentDateArrival]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    
    NSLog(@"arrival status = %d",[res statusCode]);
    if(data != nil && [res statusCode]==200 && err == nil){
        arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"arrival json in GetSchedule: %@",arrivalArray);
    }
    else{
        NSLog(@"error json = %@ and status code = %d error = %@",arrivalArray,[res statusCode],[err description]);
    }
    return arrivalArray;
 
}

+(NSString *)currentDateArrival{
    // filter=hour(ScheduleArrivalTime)%20ge%2016 &$orderby=ScheduleArrivalTime%20asc&$top=25&$format=JSON

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
   // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:nowDate];
   
    //http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Arrival?$filter=hour(ScheduleArrivalTime)%20ge%2016&$orderby=ScheduleArrivalTime%20asc&$top=25&$format=JSON

    NSString *frontURL = [arrival_new stringByAppendingString:[NSString stringWithFormat:@"%d",[dateComponent hour]]];
    NSString *backURL = @"&$orderby=ScheduleArrivalTime%20asc&$top=20&$format=JSON";
    NSString *filterURL = [NSString stringWithFormat:@"%@%@",frontURL,backURL];
    NSLog(@"URL current Time = %@",filterURL);
    return  filterURL;
}

+(NSMutableArray *)jsonDepature:(NSString *)from{
    NSLog(@"comeFrom = %@",from);
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSURL *url = [NSURL URLWithString:[self currentDateDeparture]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    
    NSLog(@"departure status = %d",[res statusCode]);
    if(data != nil && [res statusCode]==200 && err == nil){
        departureArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"departure json in GetSchedule: %@",departureArray);
    }
    else{
        NSLog(@"error json = %@ and status code = %d error = %@",departureArray,[res statusCode],[err description]);
    }
    return departureArray;
    
}

+(NSString *)currentDateDeparture{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:nowDate];
    
    NSString *frontURL = [departure_new stringByAppendingString:[NSString stringWithFormat:@"%d",[dateComponent hour]]];
    NSString *backURL = @"&$orderby=ScheduleDepartureTime%20asc&$top=20&$format=JSON";
    NSString *filterURL = [NSString stringWithFormat:@"%@%@",frontURL,backURL];
    NSLog(@"URL current Time = %@",filterURL);
    return  filterURL;

}

+(NSString *)translateIATA:(NSString *)airportCode{
    NSError *err = nil;
    NSLog(@"airport code = %@",airportCode);
    NSString *IATAinfo = [NSString stringWithFormat:@"%@/%@?format=JSON",airportInfo,airportCode];   //JFK?$format=JSON
    NSURL *url = [NSURL URLWithString:IATAinfo];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    
    NSLog(@"translateIATA status = %d",[response statusCode]);
    
    if(data != nil &&[response statusCode] ==200){
        NSDictionary *airportDictionary = [[NSDictionary alloc]init];
        //airportArray = [NSMutableArray array];
        airportDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Airport json : %@,  %d",airportDictionary,[airportDictionary count]);
        //_scrollView.hidden = NO;
        //noDatasLabelView.hidden = YES;
        NSString *airportName = [[airportDictionary objectForKey:@"AirportName"] objectForKey:@"Zh_tw"];
        NSLog(@"airport name = %@",airportName);
        if([airportName isEqualToString:@""]){
            airportName = airportCode;
        }
        return  airportName;
    }
    else{
        //        noDatasLabelView = [[UILabel alloc]initWithFrame:CGRectMake(115, 250, 240, 50)];
        //        [noDatasLabelView setText:@"No Data....."];
        //        [noDatasLabelView setFont:[UIFont systemFontOfSize:25]];
        //        [self.view addSubview:noDatasLabelView];
        //        _scrollView.hidden = YES;
        //        noDatasLabelView.hidden = NO;
        NSLog(@"Get problem The status code = %d",[response statusCode]);
    }
    //NSArray *portName = [[_airportArray objectAtIndex:4]objectForKey:@"AirportName"];
}

+(NSString *)figureRegistration:(NSString *)flightCode number:(NSString *)flightNum{
    NSLog(@"airline code = %@",flightCode);
    
    if(flightCode != nil){
        NSString *IATAinfo = [NSString stringWithFormat:@"%@/%@?format=JSON",flightInfo,flightCode];
        NSURL *url = [NSURL URLWithString:IATAinfo];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *err = nil;
        NSHTTPURLResponse *res =nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
        if([res statusCode] == 200 && err == nil && ![flightCode isEqualToString:@""]){
            NSDictionary *flightArray = [[NSDictionary alloc]init];
            flightArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"flight json = %@",flightArray);
            NSString *airlineCode = [NSString stringWithFormat:@"%@-%@%@",[[flightArray objectForKey:@"AirlineNameAlias"] objectForKey:@"Zh_tw"],flightCode,flightNum];
            NSLog(@"flight name  = %@",airlineCode);
            //[self returnCode];
//            scrollView.hidden = NO;
//            noDatasLabelView.hidden = YES;
            return airlineCode;
        }
        else{
            NSLog(@"err = %@ and response code = %d",err,[res statusCode]);
//            noDatasLabelView = [[UILabel alloc]initWithFrame:CGRectMake(115, 250, 240, 50)];
//            [noDatasLabelView setText:@"No Data....."];
//            [noDatasLabelView setFont:[UIFont systemFontOfSize:25]];
//            [self.view addSubview:noDatasLabelView];
//            _scrollView.hidden = YES;
//            noDatasLabelView.hidden = NO;
        }
        
    }else{
        NSLog(@"flight code is null");
        NSString *nullDisplayCode = [flightCode stringByAppendingString:flightNum];
        return nullDisplayCode;
    }
    
    
}
@end
