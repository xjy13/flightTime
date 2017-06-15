//
//  ScheduleTableCell.h
//  FlightTime
//
//  Created by mac on 2017/6/1.
//
//

#import <UIKit/UIKit.h>

@protocol ScheduleCellDelegate<NSObject>
@optional

@end

@interface ScheduleTableCell : UITableViewCell
@property(nonatomic,weak)id<ScheduleCellDelegate>delegate;
//-(void)receiveDepartureArray:(NSMutableArray *)array;
-(void)receiveDepartureArrayxd:(int)row status:(BOOL)isArrival;
@property(weak,nonatomic)IBOutlet UILabel *flightID;
@property(weak,nonatomic)IBOutlet UILabel *IDLabel;
@property(weak,nonatomic)IBOutlet UILabel *ManuLabel;
@property(nonatomic,strong)NSString *a;
@property(weak,nonatomic)NSString *count;
@end
