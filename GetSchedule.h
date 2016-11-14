//
//  GetSchedule.h
//  FlightTime
//
//  Created by mac on 2016/10/28.
//
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"


//接收root那邊老闆的指示做事
@interface GetSchedule : NSObject<rootDelegate>

@property (nonatomic, retain)NSMutableArray *arrivalArray;


@end
