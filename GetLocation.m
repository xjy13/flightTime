//
//  GetLocation.m
//  FlightTime
//
//  Created by mac on 2017/2/8.
//
//

#import <Foundation/Foundation.h>
#import "GetLocation.h"

NSMutableArray *filterArray;
@interface GetLocation()


@end


@implementation GetLocation : NSObject
//+ (instancetype)shareInstance
//{
//   return [[[self class] alloc] init];
//}
+(NSString *)currentLocationTime{
  NSString *currentTime =[NSString stringWithFormat:@"/?time=%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString *locactionURL = [locationURL stringByAppendingString:currentTime];
    return locactionURL;
}

+(NSMutableArray *)jsonLocation{
   
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSURL *url = [NSURL URLWithString:[self currentLocationTime]];
//    NSURL *url = [NSURL URLWithString:locationOwn];
   // NSLog(@"locaton URL = %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    NSLog(@"Location status = %d",[res statusCode]);
    
    if(data != nil && [res statusCode]==200 && err == nil){
       // NSMutableArray *json = [[NSMutableArray alloc]init];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *add = [[NSMutableArray alloc]init];
        [add addObjectsFromArray:json[@"states"]];
      //  NSLog(@"location json_1= %@",add);
        filterArray = [NSMutableArray array];
        for(int i = 0 ; i < add.count ; i++){
            if([[[add objectAtIndex:i] objectAtIndex:2]isEqualToString:@"Taiwan"] && [[add objectAtIndex:i] objectAtIndex:5] != [NSNull null] && [[add objectAtIndex:i]objectAtIndex:6]!= [NSNull null] && [[add objectAtIndex:i] objectAtIndex:1]!= [NSNull null] ){
                [filterArray addObject:[add objectAtIndex:i]];
            }
                   }

           NSLog(@"filter add = %@",filterArray);
           return filterArray;
    }
    else{
        NSLog(@"status code = %d error = %@",[res statusCode],[err description]);
    }
   // return _arrivalArray;



}

@end
