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
        
        //NSMutableArray *rounteArray = [[NSMutableArray alloc]init];
      //  [rounteArray addObjectsFromArray:[GetSchedule flightDestination]];
        //NSString *departureSite = [NSString stringWithFormat:@"%@",[[rounteArray objectAtIndex:0] objectForKey:@"departure"]];
        //NSString *arrivalSite = [NSString stringWithFormat:@"%@",[[rounteArray objectAtIndex:0] objectForKey:@"arrival"]];
        //[self.title setText:[NSString stringWithFormat:@"%@",departureSite]];
        //[self.title setFont:[UIFont systemFontOfSize:13]];
        //[self.title setTextColor:[UIColor redColor]];
        
        //[self.title2 setText:[NSString stringWithFormat:@"%@",arrivalSite]];
        //[self.title2 setFont:[UIFont systemFontOfSize:13]];
        //[self.title2 setTextColor:[UIColor greenColor]];
        
      
      //  [self.frame addSubview:test];
        NSLog(@"小圖示XDDD");
        
    }
    return self;
}

@end
