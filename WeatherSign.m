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
UIImage *img;
@implementation WeatherSign


-(void)getWeatherInfo{

    NSMutableArray *weatherArray = [[NSMutableArray alloc]init];
    weatherArray = [NSMutableArray array];
    [weatherArray addObject:[GetWeather getWeather:@"Taipei"]];
//    NSLog(@"XDDDDD1 = %@",[weatherArray objectAtIndex:0]);
//    NSLog(@"XDDDDD2 = %@",[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"temp_c"] );
//    NSLog(@"XDDDDD3 = %@",[[[weatherArray objectAtIndex:0]objectForKey:@"location"] objectForKey:@"name"]);
//    NSLog(@"XDDDDD4img = %@",[[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"condition"] objectForKey:@"icon"] );
    city = [[[weatherArray objectAtIndex:0]objectForKey:@"location"] objectForKey:@"name"];
    degree = [NSString stringWithFormat:@"%@ ºC / %@ ºF",[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"temp_c"],[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"temp_f"]];
    NSString *imgURL = [@"https:" stringByAppendingString:[[[[weatherArray objectAtIndex:0] objectForKey:@"current"] objectForKey:@"condition"] objectForKey:@"icon"]];
    img = [[UIImage alloc]init];
    img= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
  
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
        [self.weatherImg setImage:img];
    
    }
    return self;
}




@end
