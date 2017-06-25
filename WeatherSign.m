//
//  WeatherSign.m
//  FlightTime
//
//  Created by mac on 2017/6/23.
//
//

#import <Foundation/Foundation.h>
#import "WeatherSign.h"
#import "GetWeather.h"
NSString *city;
NSString *weather;
NSString *degree;
NSString *isDay;
UIImage *img;
NSString *location;
@implementation WeatherSign

+(void)loc:(NSString *)XD{
    NSLog(@"location = %@",XD);
    location = [NSString stringWithFormat:@"%@",XD];

}
-(void)getWeatherInfo{
    
    NSMutableArray *weatherArray = [[NSMutableArray alloc]init];
    weatherArray = [NSMutableArray array];
    [weatherArray addObject:[GetWeather getWeather:location]];
 //   NSLog(@"XDDDDD1 = %@",[weatherArray objectAtIndex:0]);
//    NSLog(@"XDDDDD2 = %@",[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"temp_c"] );
//    NSLog(@"XDDDDD3 = %@",[[[weatherArray objectAtIndex:0]objectForKey:@"location"] objectForKey:@"name"]);
//    NSLog(@"XDDDDD4img = %@",[[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"condition"] objectForKey:@"icon"] );
    city = [[[weatherArray objectAtIndex:0]objectForKey:@"location"] objectForKey:@"name"];
    degree = [NSString stringWithFormat:@"%.0fºC / %.0fºF", [[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"temp_c"] floatValue], [[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"temp_f"] floatValue]];
    NSString *imgURL = [@"https:" stringByAppendingString:[[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"condition"] objectForKey:@"icon"]];
    img = [[UIImage alloc]init];
    img= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
    isDay = [NSString stringWithFormat:@"%@",[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"is_day"]] ;
    
  ;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"WeatherSign" owner:self options:nil]lastObject];
        self.frame = frame;
        [self getWeatherInfo];
        [self.cityName setText:city];
        [self.weatherInfo setText:degree];
        [self.weatherInfo setFont:[UIFont systemFontOfSize:10]];
        [self.weatherImg setImage:img];
        if([isDay isEqualToString:@"1"]){
            self.backgroundColor = [[UIColor alloc]initWithRed:148.0/255.0 green:222.0/255.0 blue:255.0/255.0 alpha:0.8];
                   }
        else{
            self.backgroundColor = [[UIColor alloc]initWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.8];
            [self.cityName setTextColor:[UIColor whiteColor]];
            [self.weatherInfo setTextColor:[UIColor whiteColor]];
        }
    }
    return self;
}




@end
