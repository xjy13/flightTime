//
//  MapGoogle.h
//  FlightTime
//
//  Created by mac on 2017/3/9.
//
//
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "FlightInfoView.h"
@class MapGoogle;
@interface MapGoogle : UIViewController

//typedef NS_ENUM(NSInteger, _airways) {
//    CAL = 0,
//    MDA = 1,
//    EVA = 2,
//    UIA = 3,
//    FET = 4
//};

@property (retain, nonatomic) IBOutlet UIPickerView *pickers;
@property(strong,nonatomic)NSArray *pickerData;
@property (strong,nonatomic)UIButton *cancelBtn;
@property (strong,nonatomic)UIButton *certainBtn;
+(void)closeExtension;

@end
