//
//  FlightInfoView.h
//  FlightTime
//
//  Created by mac on 2017/4/15.
//
//

#import "GetSchedule.h"
@interface FlightInfoView : UIView
@property(weak,nonatomic)IBOutlet UILabel *title;
@property(weak,nonatomic)IBOutlet UILabel *title2;
@property(weak,nonatomic)IBOutlet UILabel *title3;
@property(weak,nonatomic)IBOutlet UIButton *closeBtn;
+(void)getRouteArray:(NSMutableArray *)array;
+(void)getAirlineName:(NSString *)name;
@end
