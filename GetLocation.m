//
//  GetLocation.m
//  FlightTime
//
//  Created by mac on 2017/2/8.
//
//

#import <Foundation/Foundation.h>
#import "GetLocation.h"

@interface GetLocation()


@end


@implementation GetLocation : NSObject
+ (instancetype)shareInstance
{
   return [[[self class] alloc] init];
}

-(void)jsonLocation{
 
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSURL *url = [NSURL URLWithString:@"https://opensky-network.org/api/states/all"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    
    NSLog(@"Location status = %d",[res statusCode]);
    if(data != nil && [res statusCode]==200 && err == nil){
        NSMutableArray *arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"arrival json in GetSchedule: %@",_arrivalArray);
        NSLog(@"Location data = %@",arrivalArray);
    }
    else{
        NSLog(@"status code = %d error = %@",[res statusCode],[err description]);
    }
   // return _arrivalArray;



}

@end
