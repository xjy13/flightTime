//
//  TalkToMac.h
//  ios_usePeertalk
//
//  Created by judy on 7/5/16.
//  Copyright © 2016 TH. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PTChannel.h"
//#import "RootViewController.h"

@protocol TalkToMacDelegate <NSObject>
-(void)showMessage:(NSString *)msg;
@end


@interface TalkToMac : NSObject<PTChannelDelegate>
- (void)sendMessage:(NSString*)message;
- (void)creatConnect;

@property (nonatomic,strong) id<TalkToMacDelegate> delegate;
@end
