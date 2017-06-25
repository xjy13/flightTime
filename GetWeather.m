//
//  SearchBar.m
//  FlightTime
//
//  Created by mac on 2017/6/23.
//
//

#import <Foundation/Foundation.h>
#import "GetWeather.h"
NSMutableArray *weatherArray;


@implementation GetWeather
static GetWeather *_instance = nil;
+(instancetype)shareInstance{
    dispatch_once_t oneCall;
    dispatch_once(&oneCall, ^{
        _instance = [[GetWeather allocWithZone:NULL]init];
        
    });
    return _instance;
    
}

+(NSMutableArray *)getWeather:(NSString *)location{

    if(location !=nil){
        NSLog(@"weather loc = %@",location);
        NSError *err = nil;
        NSHTTPURLResponse *res = nil;
        NSURL *url = [NSURL URLWithString:[weatherCurrent stringByAppendingString:location]];
        NSLog(@"weather url  = %@",url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
        
        NSLog(@"weather status = %ld",[res statusCode]);
        if(data != nil && [res statusCode]==200 && err == nil){
            weatherArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            //  NSLog(@"arrival json in GetSchedule: %@",arrivalArray);
        }
        else{
            NSLog(@"error json = %@ and status code = %ld error = %@",weatherArray,[res statusCode],[err description]);
        }
        return weatherArray;
    }
   

}
@end
