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
#define ticketNumber @"http://ptx.transportdata.tw/MOTC/v2/Account/Login?UserData.account=xjy13&UserData.password=da3dbdA%23&%24format=JSON"
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

+(NSMutableArray *)jsonArrival:(NSString *)from{
    NSLog(@"comeFrom = %@",from);
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSURL *url = [NSURL URLWithString:[self currentDateArrival]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    
    NSLog(@"arrival status = %d",[res statusCode]);
    if(data != nil && [res statusCode]==200 && err == nil){
        arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
    
    NSLog(@"arrival status = %d",[res statusCode]);
    if(data != nil && [res statusCode]==200 && err == nil){
        departureArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"arrival json in GetSchedule: %@",departureArray);
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



@end
