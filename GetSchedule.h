//
//  GetSchedule.h
//  FlightTime
//
//  Created by mac on 2016/10/28.
//
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"
#import "FlightInfoView.h"

//接收root那邊老闆的指示做事
//@interface GetSchedule : NSObject<rootDelegate>
//
//@property (nonatomic, retain)NSMutableArray *arrivalArray;
//@property (nonatomic, retain)NSMutableArray *tickGet;
//
//@end


@class GetSchedule;

@interface GetSchedule : NSObject
//@property (nonatomic, retain)NSMutableArray *arrivalArray;
//@property (nonatomic, retain)NSMutableArray *tickGet;
+(instancetype)shareInstance;
+(NSMutableArray *)jsonArrival:(NSString *)from;
+(NSMutableArray *)jsonDepature:(NSString *)from;
+(NSString *)translateIATA:(NSString *)airportCode;
+(NSString *)figureRegistration:(NSString *)flightCode number:(NSString *)flightNum;
+(void)flightDestination:(NSString *)code;
+(void)flightCodeConverter:(NSString *)code;
@end
