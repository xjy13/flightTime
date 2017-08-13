//
//  NotificationView.m
//  FlightTime
//
//  Created by mac on 2017/7/12.
//
//

#import <Foundation/Foundation.h>
#import "ExtensionView.h"

@interface ExtensionView ()


@end
@implementation ExtensionView


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
    
        self = [[[NSBundle mainBundle]loadNibNamed:@"ExtensionView" owner:self options:nil] lastObject];
        self.gateLabel.text = @"靠夭";
        self.terminalLabel.text = @"靠北";
         self.counterLabel.text = @"靠母";
    
    
    }

     return self;
}
    
        
    
    
    








@end
