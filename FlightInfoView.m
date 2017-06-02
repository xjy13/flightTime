//
//  FlightInfoView.m
//  FlightTime
//
//  Created by mac on 2017/4/15.
//
//

#import <Foundation/Foundation.h>
#import "FlightInfoView.h"
#import "MapGoogle.h"
#import "GetSchedule.h"
NSString *departureSite;
NSString *arrivalSite;
@implementation FlightInfoView


+(void)getRouteArray:(NSMutableArray *)array{
    NSMutableArray *rounteArray = [[NSMutableArray alloc]init];
    [rounteArray addObjectsFromArray:array];
    departureSite = [NSString stringWithFormat:@"%@",[[rounteArray objectAtIndex:0] objectForKey:@"departure"]];
    arrivalSite = [NSString stringWithFormat:@"%@",[[rounteArray objectAtIndex:0] objectForKey:@"arrival"]];
    if( ![departureSite isEqualToString:@""] && ![arrivalSite isEqualToString:@""]){
       
        departureSite = [GetSchedule translateIATA:departureSite];
        arrivalSite = [GetSchedule translateIATA:arrivalSite];

    }
    
   
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"FlightInfoView" owner:self options:nil]lastObject];
        self.frame = frame;
        
       // UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.title setText:[NSString stringWithFormat:@"出發：%@",departureSite]];
            [self.title2 setText:[NSString stringWithFormat:@"抵達：%@",arrivalSite]];
        
        });
        
        [self.title setFont:[UIFont systemFontOfSize:13]];
        [self.title setTextColor:[UIColor blackColor]];
        
      
        [self.title2 setFont:[UIFont systemFontOfSize:13]];
        [self.title2 setTextColor:[UIColor blackColor]];
        
        
        NSLog(@"小圖示XDDD");
        
    }
    return self;
}
-(IBAction)setCloseBtn:(id)sender{
    [MapGoogle closeExtension];
    departureSite = @"瓦窯溝國際雞場";
    arrivalSite =   @"福美路冠強炸雞坊";
}

@end
