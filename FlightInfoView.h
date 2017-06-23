//
//  FlightInfoView.h
//  FlightTime
//
//  Created by mac on 2017/4/15.
//
//

#import "GetSchedule.h"
@interface FlightInfoView : UIView
@property(retain,nonatomic)IBOutlet UILabel *title;
@property(retain,nonatomic)IBOutlet UILabel *title2;
@property(retain,nonatomic)IBOutlet UILabel *title3;
@property(weak,nonatomic)IBOutlet UIButton *closeBtn;
+(void)getRouteArray:(NSMutableArray *)array;
+(void)getAirlineName:(NSString *)name;
@end
