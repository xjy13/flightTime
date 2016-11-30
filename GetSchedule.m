//
//  GetSchedule.m
//  FlightTime
//
//  Created by mac on 2016/10/28.
//
//
#import <Foundation/Foundation.h>
#import "GetSchedule.h"
#define arrivalURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Arrival/TPE?%24filter=FlightDate%20eq%20"
//#define departureURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Departure/TPE?%24top=6&%24format=JSON"
#define diqiURL @"https://asset.diqi.us/api/v1/users/profile/"
#define ticketNumber @"http://ptx.transportdata.tw/MOTC/v2/Account/Login?UserData.account=xjy13&UserData.password=da3dbdA%23&%24format=JSON"
//@interface GetSchedule:NSObject<rootDelegate>
//
//@end

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

-(NSString *)getAirApiticket:(RootViewController *)rootView {
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSURL *url = [NSURL URLWithString:ticketNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *ticketData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];

    _tickGet = [NSJSONSerialization JSONObjectWithData:ticketData options:NSJSONReadingMutableContainers error:&err];
    NSLog(@"_ticketGet = %@",_tickGet);
    if(ticketData !=nil && [res statusCode] == 200){
         status = [_tickGet valueForKey:@"Status"];
         ticketCode = [_tickGet valueForKey:@"Ticket"];
         NSLog(@"ticketCode = %@",ticketCode);
    }
    else{
        NSLog(@"getTicker status_code = %d",[res statusCode]);
        ticketCode = nil;
    }
    
     return ticketCode;

}

- (NSMutableArray *)jsonArrival:(RootViewController *)rootView comeFrom:(NSString *)from{
    NSLog(@"comeFrom = %@",from);
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSURL *url = [NSURL URLWithString:[self currentDateArrival]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    
    NSLog(@"arrival status = %d",[res statusCode]);
    if(data != nil && [res statusCode]==200 && err == nil){
        _arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"arrival json in GetSchedule: %@",_arrivalArray);
    }
    else{
        NSLog(@"error json = %@ and status code = %d error = %@",_arrivalArray,[res statusCode],[err description]);
    }
    return _arrivalArray;
    

}

-(NSString *)currentDateArrival{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSString *currentDateString = [dateFormatter stringFromDate:nowDate];
    NSString *topCountString = @"&%24top=6&%24format=JSON";
    NSString *filter = [NSString stringWithFormat:@"%@%@",currentDateString,topCountString];
    
    NSString *arrvalDate = [arrivalURL stringByAppendingString:filter];
    NSLog(@"[arrival] new format Date = %@",arrvalDate);
    return  arrvalDate;
}




-(NSString *)returnTest:(RootViewController *)rootView comeFrom:(NSString *)from{

//    NSLog(@"comefrom return Test = %@",from);
//    NSError *err = nil;
//    NSURL *url = [NSURL URLWithString:diqiURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
//    NSMutableArray *diqiArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"diqi json from Delegate : %@",diqiArray);
    //        NSString *airlineID = [[_arrivalArray objectAtIndex:0] objectForKey:@"AirlineID"];
    //        return airlineID;
    //   }
    //        NSLog(@"JJJ pass!!");
    
    NSString *apiKey = @"b7vgkU3yBW8rRHcV";
    NSString *apiSecret = @"PptRxleBDg7IN2JqFmvnC9jHUH9aWAr8";
    
    /*
     -H "Authorization: Bearer f26c4e465967e5b0e41ec879ba236c08e0ab2a2c" \
    // https://asset.diqi.us/api/v1/users/5865494f8090478885fb9fc528cf8717/balance/
     
     */
    
    NSString *diqi = [NSString stringWithFormat:@"%@",diqiURL];
    NSURL *url = [NSURL URLWithString:diqi];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [request.HTTPMethod isEqualToString: @"GET"];
      NSError *err = nil;
    NSHTTPURLResponse *res =nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];

}

//func authentication2(){
//    let request = NSMutableURLRequest(URL: NSURL(string: "https://~~~/v2/authenticate/api")!)
//    request.HTTPMethod = "POST"
//    
//    var loginID = "mylogin_id"
//    var apiKey = "myapi_key"
//    var postString:NSString = "login_id=\(loginID)&api_key=\(apiKey)"
//    
//    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//        data, response, error in
//        
//        if error != nil {
//            println("error=\(error)")
//            return
//        }
//        
//        println("response = \(response)")
//        
//        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//        println("responseString = \(responseString)")
//    }
//    task.resume()
//}


@end
