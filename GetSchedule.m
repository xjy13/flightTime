//
//  GetSchedule.m
//  FlightTime
//
//  Created by mac on 2016/10/28.
//
//
#import <Foundation/Foundation.h>
#import "GetSchedule.h"
#import <FirebaseCore/FirebaseCore.h>
#import "Firebase.h"

@interface GetSchedule()
@end
NSMutableArray *arrivalArray;
NSMutableArray *departureArray;
NSDictionary *dicDepart;
NSMutableArray *routeArray;
NSString *status;
NSString *ticketCode;
NSString *IATACodeCompelete;

@implementation GetSchedule

static GetSchedule *_instance = nil;
+(instancetype)shareInstance{
    dispatch_once_t oneCall;
    dispatch_once(&oneCall, ^{
        _instance = [[GetSchedule allocWithZone:NULL]init];
      //  flightName = [[FlightInfoView alloc]init];
    });
    return _instance;

}


+(NSMutableArray *)jsonArrival:(NSString *)from{
    NSLog(@"comeFrom = %@",from);
      //NSURL *url = [NSURL URLWithString:[self currentDateArrival]];
     
//     dispatch_semaphore_t sem = dispatch_semaphore_create(1);
//     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     
    // dispatch_async(queue, ^{
         // dispatch_semaphore_signal(sem);
     NSError *err = nil;
     NSHTTPURLResponse *res = nil;
     @autoreleasepool {
          NSURL *url = [NSURL URLWithString:[jsonURLTool currentDateArrival:true]];
          NSURLRequest *request = [NSURLRequest requestWithURL:url];
          NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
          NSLog(@"arrival status = %ld",[res statusCode]);
          if(data != nil && [res statusCode]==200 && err == nil){
               arrivalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
               //  NSLog(@"arrival json in GetSchedule: %@",arrivalArray);
          }
          else{
               NSLog(@"error json = %@ and status code = %ld error = %@",arrivalArray,[res statusCode],[err description]);
          }
     }
     
     return arrivalArray;
    
   
     
}


+(NSMutableArray *)jsonDepature:(NSString *)from{
    NSLog(@"comeFrom = %@",from);
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
     @autoreleasepool {
          //NSURL *url = [NSURL URLWithString:[self currentDateDeparture]];
          NSURL *url = [NSURL URLWithString: [jsonURLTool currentDateArrival:false]];
          NSURLRequest *request = [NSURLRequest requestWithURL:url];
          NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
          
          NSLog(@"departure status = %ld",[res statusCode]);
          if(data != nil && [res statusCode]==200 && err == nil){
               departureArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"departure json in GetSchedule: %@",departureArray);
          }
          else{
               NSLog(@"error json = %@ and status code = %ld error = %@",departureArray,[res statusCode],[err description]);
          }
  
     }
     return departureArray;
    
}

+(NSString *)translateIATA:(NSString *)airportCode{
    NSError *err = nil;
    NSLog(@"airport code = %@",airportCode);
    NSString *IATAinfo = [NSString stringWithFormat:@"%@/%@?format=JSON",airportInfo,airportCode];   //JFK?$format=JSON
    NSURL *url = [NSURL URLWithString:IATAinfo];

     @autoreleasepool {
          NSURLRequest *request = [NSURLRequest requestWithURL:url];
          NSHTTPURLResponse *response = nil;
          NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
          
          
          NSLog(@"translateIATA status = %ld",[response statusCode]);
          
          if(data != nil &&[response statusCode] ==200){
               NSDictionary *airportDictionary = [[NSDictionary alloc]init];
               //airportArray = [NSMutableArray array];
               airportDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"Airport json : %@,  %ld",airportDictionary,[airportDictionary count]);
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
               NSLog(@"Get problem The status code = %ld",[response statusCode]);
          }
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
             @autoreleasepool {
                  flightArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"flight json = %@",flightArray);
                  NSString *airlineCode = [NSString stringWithFormat:@"%@-%@%@",[[flightArray objectForKey:@"AirlineNameAlias"] objectForKey:@"Zh_tw"],flightCode,flightNum];
                  NSLog(@"flight name  = %@",airlineCode);
                  //[self returnCode];
                  //            scrollView.hidden = NO;
                  //            noDatasLabelView.hidden = YES;
                  return airlineCode;
             }
        }
        else{
            NSLog(@"err = %@ and response code = %ld",err,[res statusCode]);
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

+(void)flightDestination:(NSString *)code{
    NSString *IATAinfo;
    NSLog(@"IATACodeCompelete 2 = %@",code);
    if([code isEqualToString:@""]||code == NULL || code == nil){
        IATAinfo = [NSString stringWithFormat:@"%@%@",flight_info,@"MU2048"];
    }
    else{
        IATAinfo = [NSString stringWithFormat:@"%@%@",flight_info,code];   //JFK?$format=JSON
    }
    
    NSURL *url = [NSURL URLWithString:IATAinfo];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *err = nil;
    NSHTTPURLResponse *res =nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    if([res statusCode] == 200 && err == nil){
        NSDictionary *routeDictionary = [[NSDictionary alloc]init];
        routeDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"route json = %@",routeDictionary);
        routeArray = [[NSMutableArray alloc]init];
        [routeArray addObjectsFromArray:routeDictionary[@"response"]];
        if([routeArray count] > 0){
           NSLog(@"routeArray = %@",[routeArray objectAtIndex:0]);
            [FlightInfoView getRouteArray:routeArray];
        }
       
    }



}


+(void)flightCodeConverter:(NSString *)code{
    
    //http://ptx.transportdata.tw/MOTC/v2/Air/Airline?$filter=AirlineICAO%20eq%20'JAL'&$format=JSON"
    NSString *IACOcode = [code substringWithRange:NSMakeRange(0, 3)];
    int codeNumber = [[code substringWithRange:NSMakeRange(3, 4)] intValue];
    NSLog(@"IACO code = %@",IACOcode);
    
    NSString *flightCode = [NSString stringWithFormat:@"%@'%@'&$format=JSON",flightcodeConverter,IACOcode];
    NSURL *url = [NSURL URLWithString:flightCode];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *err = nil;
    NSHTTPURLResponse *res =nil;
     @autoreleasepool {
          NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
          if([res statusCode] == 200 && err == nil && data !=nil){
               //NSDictionary *test = [[NSDictionary alloc]init];
               NSMutableArray *converterCode = [[NSMutableArray alloc]init];
               converterCode = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               //        NSLog(@"IATA code convert json = %@",converterCode);
               NSString *IATAcode = [NSString stringWithFormat:@"%@",[[converterCode objectAtIndex:0] objectForKey:@"AirlineIATA"]];
               NSLog(@"Convert result = %@",IATAcode);
               NSString *IATACodeCompelete = [NSString stringWithFormat:@"%@%d",IATAcode,codeNumber];
               NSLog(@"IATAcompelete 1 = %@",IATACodeCompelete);
               //return IATACodeCompelete;
               [self flightDestination:IATACodeCompelete];
               [FlightInfoView getAirlineName:IATACodeCompelete];
          }
          else{
               NSLog(@"IATA code convert error = %@",err.description);
               
          }
     }
}

 @end
