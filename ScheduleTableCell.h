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
-(void)receiveDepartureArrayxd:(int)row;
@property(weak,nonatomic)IBOutlet UILabel *title;
@property(weak,nonatomic)NSString *a;
@end
