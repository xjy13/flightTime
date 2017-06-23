//
//  WeatherSign.h
//  FlightTime
//
//  Created by mac on 2017/6/23.
//
//

#import <UIKit/UIkit.h>
@interface WeatherSign:UIView
@property(retain,nonatomic)IBOutlet UILabel *cityName;
@property(retain,nonatomic)IBOutlet UILabel *weatherInfo;
@property(retain,nonatomic)IBOutlet UIImageView *weatherImg;
@end
