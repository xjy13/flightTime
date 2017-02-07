//
//  GetLocation.h
//  FlightTime
//
//  Created by mac on 2017/2/8.
//
//
#import "RootViewController.h"
@class GetLocation;

@interface GetLocation : NSObject
+(instancetype)shareInstance;
-(void)jsonLocation;
@end
