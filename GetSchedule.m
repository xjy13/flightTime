//
//  GetSchedule.m
//  FlightTime
//
//  Created by mac on 2016/10/28.
//
//
#import <Foundation/Foundation.h>
#import "GetSchedule.h"
#define arrivalURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Arrival/TPE?%24top=6&%24format=JSON"
//#define departureURL @"http://ptx.transportdata.tw/MOTC/v2/Air/FIDS/Airport/Departure/TPE?%24top=6&%24format=JSON"
#define diqiURL @"https://asset.diqi.us/api/v1/users/f3c7a287e97c4bcd8f9c50a2bec76118/balance/"
//@interface GetSchedule:NSObject<rootDelegate>
//
//@end

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

- (void)jsonArrivalXD:(RootViewController *)rootView comeFrom:(NSString *)from{
    NSLog(@"comeFrom = %@",from);
           //   if(![comeFrom isEqualToString:@""]){
            NSError *err = nil;
            NSURL *url = [NSURL URLWithString:arrivalURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
            _arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Departure json from Delegate : %@",_arrivalArray);
            //        NSString *airlineID = [[_arrivalArray objectAtIndex:0] objectForKey:@"AirlineID"];
            //        return airlineID;
            //   }
    //        NSLog(@"JJJ pass!!");
    

}
-(NSString *)returnTest:(RootViewController *)rootView1 comeFrom:(NSString *)from{

    NSLog(@"comefrom return Test = %@",from);
   // return @"哈哈哈";

}




@end
