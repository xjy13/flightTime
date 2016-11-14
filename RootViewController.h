/*
 
     File: RootViewController.h
 Abstract: n/a
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 
 */

#import <ExternalAccessory/ExternalAccessory.h>

//add for 20160712
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
//#import "EADemoAppDelegate.h"
#import "FlightTimeDelegate.h"
#import "MBProgressHUD.h"

//@class EADSessionController;
@class RootViewController;

//他是老闆要叫getschedule這個class幫忙做事
@protocol rootDelegate <NSObject>
@optional
//-(void)jsonArrivalXD:(NSString *)comeFrom;
- (void)jsonArrivalXD:(RootViewController *)rootView:(NSString *)comeFrom;

@end



@interface RootViewController : UIViewController <UIActionSheetDelegate,UITableViewDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,MBProgressHUDDelegate> {
    
    NSMutableArray *_accessoryList;
    NSMutableArray *_accessoryOriginal;
    EAAccessory *_selectedAccessory;
    //EADSessionController *_eaSessionController;
    NSMutableDictionary *accessoryInfo;


  //  UIView *_noExternalAccessoriesPosterView;
   
    
    //add for 20160712
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *recordPlayer;
    AVAudioRecorder *audioRecoder;
    AVAudioSession *audioSession;
    MPRemoteCommandCenter *commandCenter;
    
}
@property(nonatomic,assign) id<rootDelegate>rootdelegate;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *scrollView;
//@property (nonatomic,retain)id<TalkToMac> delegate;

//add for 20160712
@property(nonatomic, retain)UIButton *playMuzik;
@property(nonatomic, retain)UIButton *pauseMuzik;
@property (nonatomic, retain)UIButton *startRecord;
@property (nonatomic, retain)UIButton *stopRecord;
@property (nonatomic, retain)UIButton *playRecord;
@property (nonatomic, retain)UIButton *stop_playRecord;
@property(nonatomic, retain)UIButton *refreshBtn;
@property (nonatomic, retain)UIButton *arrivalBtn;
@property (nonatomic, retain)UIButton *departureBtn;

@property (nonatomic, retain)NSMutableArray *arrivalArray;
@property (nonatomic, retain)NSMutableArray *departureArray;
@property (nonatomic, retain)NSMutableArray *airportArray;
@property (nonatomic, retain)NSMutableArray *flightArray;

// from UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

////for peer to talk
//- (void)appendOutputMessage:(NSString*)message;
@end
