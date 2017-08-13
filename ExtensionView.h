//
//  NotificationView.h
//  FlightTime
//
//  Created by mac on 2017/7/12.
//
//

//#ifndef NotificationView_h
//#define NotificationView_h
//
//
//#endif /* NotificationView_h */
#import <UIKit/UIkit.h>
@interface ExtensionView : UIView
@property(nonatomic,strong)IBOutlet UILabel *gateLabel;
@property(nonatomic,strong)IBOutlet UILabel *terminalLabel;
@property(nonatomic,strong)IBOutlet UILabel *counterLabel;

@end
