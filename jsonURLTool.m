//
//  jsonURLTool.m
//  FlightTime
//
//  Created by hsuj on 2017/9/2.
//
//

#import <Foundation/Foundation.h>
#import "jsonURLTool.h"

@implementation jsonURLTool


+(NSString *)currentDateArrival:(BOOL)isArrival{
     // filter=hour(ScheduleArrivalTime)%20ge%2016 &$orderby=ScheduleArrivalTime%20asc&$top=25&$format=JSON
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
     [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
     [dateFormatter setDateFormat:@"YYYY-MM-dd"];
     NSDate *nowDate = [NSDate date];
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *dateComponent = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute|NSCalendarUnitSecond ) fromDate:nowDate];
     
     NSString *dot = @"%3A";
    
     NSString *month;
     
     
     if([dateComponent month] >= 10){
          
          month = [NSString stringWithFormat:@"%ld",[dateComponent month]];
     }
     else{
          month = [NSString stringWithFormat:@"0%ld",[dateComponent month]];
          
     }
     NSString *frontURL;
    // NSLog(@"frontURL = %@",frontURL);

     NSString *yeardate;
     NSString *midURL;
     NSString *backURL;

     if(isArrival == true){
          frontURL = [arrival_new stringByAppendingString:[NSString stringWithFormat:@"%ld%@%ld%@%ld",[dateComponent hour],dot,[dateComponent minute],dot,[dateComponent second]]];
          NSLog(@"frontURL = %@",frontURL);
          yeardate = [NSString stringWithFormat:@"%ld-%@-%ld",[dateComponent year],month,[dateComponent day]];
          midURL = @"%20and%20date(ScheduleArrivalTime)%20eq%20";
          backURL = [NSString stringWithFormat:@"%@&$top=20&$format=JSON",yeardate];
     }
     else{
          frontURL = [departure_new stringByAppendingString:[NSString stringWithFormat:@"%ld%@%ld%@%ld",[dateComponent hour],dot,[dateComponent minute],dot,[dateComponent second]]];
          NSLog(@"frontURL = %@",frontURL);
          yeardate = [NSString stringWithFormat:@"%ld-%@-%ld",[dateComponent year],month,[dateComponent day]];
          midURL = @"%20and%20date(ScheduleDepartureTime)%20eq%20";
          backURL = [NSString stringWithFormat:@"%@&$top=20&$format=JSON",yeardate];
     }
     
     NSString *filterURL = [NSString stringWithFormat:@"%@%@%@",frontURL,midURL,backURL];
     NSLog(@"URL current Time Schedule= %@",filterURL);
     
     return  filterURL;
}


@end
