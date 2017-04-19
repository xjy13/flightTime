//
//  FlightInfoView.m
//  FlightTime
//
//  Created by mac on 2017/4/15.
//
//

#import <Foundation/Foundation.h>
#import "FlightInfoView.h"


@implementation FlightInfoView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"FlightInfoView" owner:self options:nil]lastObject];
                 self.frame = frame;
      
        [self.title setText:[NSString stringWithFormat:@"%@",[GetSchedule translateIATA:@"TPE"]]];
        [self.title setFont:[UIFont systemFontOfSize:16]];
        [self.title setTextColor:[UIColor redColor]];
        
        [self.title2 setText:[NSString stringWithFormat:@"%@",[GetSchedule translateIATA:@"JFK"]]];
        [self.title2 setFont:[UIFont systemFontOfSize:16]];
        [self.title2 setTextColor:[UIColor redColor]];
        
      //  [self.frame addSubview:test];
        NSLog(@"XDDD");
        
    }
    return self;
}

@end
