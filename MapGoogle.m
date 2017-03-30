//
//  MapGoogle.m
//  FlightTime
//
//  Created by mac on 2017/3/9.
//
//

#import <Foundation/Foundation.h>
#import "MapGoogle.h"
#import "GetLocation.h"
#import "Toast+UIView.h"
@interface MapGoogle()<GMSMapViewDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    
}
@end
@implementation MapGoogle

GMSMapView *mapView_;
NSSet *markers;
UIButton *backBtn;
NSTimer *refreshRoute;
GMSCameraPosition *camera;
NSUserDefaults *oldLocation;
BOOL ishidden;
NSString *loc;

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6. //-33.86 151.20
    
    //    [self getFlightLocation];
    [self initalView];
    loc = @"Taiwan";
   // [self realTime:loc];
    refreshRoute = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(realTime:) userInfo:loc repeats:YES];
    [refreshRoute fire];
}

-(void)initalView{
    
    CLLocationManager *locationCurrent = [[CLLocationManager alloc]init];
    locationCurrent.delegate = self;
    locationCurrent.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    float currentLatitude = locationCurrent.location.coordinate.latitude;
    float currentLongitude = locationCurrent.location.coordinate.longitude;
    mapView_ = [[GMSMapView alloc]init];
    camera = [GMSCameraPosition cameraWithLatitude:currentLatitude longitude:currentLongitude zoom:8];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,70,320,320) camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.scrollGestures = YES;

    
    [self.view addSubview:mapView_];
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(25.0796514,121.2320283);
//    marker.title = @"桃園機場";
//    marker.snippet = @"TPE";
//    marker.icon = [UIImage imageNamed:@"airPort"];
//    marker.map = mapView_;
//    
//    GMSMarker *marker1 = [[GMSMarker alloc] init];
//    marker1.position = CLLocationCoordinate2DMake(25.067566,121.5505103);
//    marker1.title = @"松山機場";
//    marker1.snippet = @"TSA";
//    marker1.icon = [UIImage imageNamed:@"airPort"];
//    marker1.map = mapView_;
//    
//    GMSMarker *marker2 = [[GMSMarker alloc] init];
//    marker2.position = CLLocationCoordinate2DMake(22.5746339,120.3426181);
//    marker2.title = @"小港機場";
//    marker2.snippet = @"KHH";
//    marker2.icon = [UIImage imageNamed:@"airPort"];
//    marker2.map = mapView_;
//    
//    GMSMarker *marker4 = [[GMSMarker alloc] init];
//    marker4.position = CLLocationCoordinate2DMake(24.2595672,120.6243446);
//    marker4.title = @"清泉崗機場";
//    marker4.snippet = @"RMQ";
//    marker4.icon = [UIImage imageNamed:@"airPort"];
//    marker4.map = mapView_;
    
    
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,30, 28, 28)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *pickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   pickerBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 30, 28, 28)];
    [pickerBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [pickerBtn addTarget:self action:@selector(pickerHide:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerBtn];
    
    self.pickerData = @[@"Taiwan",@"Japan",@"China",@"Korea",@"United States",@"United Kingdom",@"Germany"];
    
    self.pickers.dataSource = self;
    self.pickers.delegate = self;
//    self.pickers = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 200)];
  //  [self.view addSubview:self.pickers];
    
    self.certainBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-45, 160, 45)];
    [self.certainBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.certainBtn setTitle:@"Certain" forState:UIControlStateNormal];
    [self.view addSubview:self.certainBtn];
    self.certainBtn.hidden = YES;
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(160,self.view.frame.size.height-45, 160, 45)];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithRed:0.5 green:.3 blue:.2 alpha:1]];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.cancelBtn addTarget:self action:@selector(departureTable:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.view addSubview:self.cancelBtn];
    
    self.cancelBtn.hidden = YES;
  


}
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
   
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return self.view.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    return 40;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
         // loc = [NSString stringWithFormat:@"%@",self.pickerData[row]];
         NSLog(@"loc XDD1 = %@",self.pickerData[row]);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
               NSLog(@"loc XDD2 = %@",self.pickerData[row]);
        [self.cancelBtn addTarget:self action:@selector(pickerHide:) forControlEvents:UIControlEventTouchUpInside];
        [self.view makeToast: @"Loading.." duration:.5 position:@"center"];
        [self.view setUserInteractionEnabled:NO];
        [refreshRoute invalidate];
        refreshRoute = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(realTime:) userInfo:self.pickerData[row] repeats:YES];
        [refreshRoute fire];
        
    });

}


-(void)viewDidDisappear:(BOOL)animated{
    [refreshRoute invalidate];
    [mapView_ clear];
    [mapView_ removeFromSuperview];
  
    
    
}
-(void)backAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)pickerHide:(UIButton *)btn{

    if(!ishidden){
        _pickers.hidden = NO;
        self.cancelBtn.hidden = NO;
        self.certainBtn.hidden = NO;
        //  [self.cancelBtn addTarget:self action:@selector(setCertainBtn:) forControlEvents:UIControlEventTouchUpInside];
        ishidden = YES;
        
    }
    else{
        _pickers.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.certainBtn.hidden = YES;
        ishidden = NO;
    }
    
    
}

-(void)setCertainBtn:(UIButton *)btn {
    
    
}

//-(void)getFlightLocation{
//    
//    NSMutableArray *pointFirst = [[NSMutableArray alloc] init];
//    [pointFirst addObjectsFromArray:[GetLocation jsonLocation]];
//    //  NSLog(@"point array is =%@",pointFirst);
//    
//    NSString *longitude = [[pointFirst objectAtIndex:4] objectAtIndex:5];
//    NSString *latitude = [[pointFirst objectAtIndex:4] objectAtIndex:6];
//    NSString *flightName = [[pointFirst objectAtIndex:4]objectAtIndex:1];
//    
//    camera = [GMSCameraPosition cameraWithLatitude: [latitude floatValue]
//                                         longitude: [longitude floatValue]
//                                              zoom:10];
//    
//    oldLocation = [NSUserDefaults standardUserDefaults];
//    [oldLocation setObject:flightName forKey:@"flight"];
//    [oldLocation setDouble:[latitude doubleValue] forKey:@"latitude"];
//    [oldLocation setDouble:[longitude doubleValue] forKey:@"longitude"];
//    
//    
//}

-(void)realTime:(NSTimer *)country{
  
    [mapView_ clear];
    // [self initalView];
    loc = country.userInfo;
    NSString *longitude;
    NSString *latitude;
    NSString *flight;
    // NSLog(@"Get in MapGoogle = %@",[GetLocation jsonLocation]);
    NSMutableArray *point = [[NSMutableArray alloc] init];
    [point addObjectsFromArray:[GetLocation jsonLocation:loc]];
    NSLog(@"point array count = %d",point.count);
    NSLog(@"point array is =%@",point);
    for (int i = 0 ; i < point.count ; i++){
        longitude = [[point objectAtIndex:i] objectAtIndex:5];
        latitude = [[point objectAtIndex:i] objectAtIndex:6];
        flight = [[point objectAtIndex:i] objectAtIndex:1];
        if(latitude !=nil && longitude != nil && ![flight isEqualToString:@""]){
            [self.view setUserInteractionEnabled:YES];
            camera = [GMSCameraPosition cameraWithLatitude: [latitude doubleValue]
                                                 longitude: [longitude doubleValue]
                                                      zoom:8];
            GMSMarker *marker3 = [[GMSMarker alloc] init];
            marker3.position = CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);
            marker3.map = nil;
            marker3.icon = [UIImage imageNamed:@"airplane"];
            if([flight hasPrefix:@"CAL"] || [flight  hasPrefix:@"MDA"] ){
              //  marker3.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:175.0/255.0 green:173.0/255.0 blue:200.0/255.0 alpha:1.0]];
                
                marker3.snippet = [NSString stringWithFormat:@"%@ ",flight];
            }
            if([flight hasPrefix:@"EVA"] || [flight hasPrefix:@"UIA"]){
            //    marker3.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:46.0/255.0 green:141.0/255.0 blue:57.0/255.0 alpha:1.0]];
                marker3.snippet = flight;
            }
            if([flight hasPrefix:@"FE"]){
              //  marker3.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                marker3.snippet = flight;
            }
            if([flight hasPrefix:@"TTW"]){
            //    marker3.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:254.0/255.0 green:227.0/255.0 blue:72.0/255.0 alpha:1.0]];
                marker3.snippet = flight;
            }
            else{
           //     marker3.icon = [GMSMarker markerImageWithColor:[UIColor cyanColor]];
                marker3.snippet = flight;
            }
            
            
            marker3.tracksInfoWindowChanges = YES;
            marker3.tracksViewChanges = YES;
            marker3.flat = YES;
            marker3.map = mapView_;
            
            
        }
       
    }
    //GMSMarker *marker3 = [[GMSMarker alloc] init];
    //    if(latitude !=nil && longitude != nil && flight !=nil){
    // [mapView_ clear];
    //        [mapView_ reloadInputViews];
    //   marker3.icon = [UIImage imageNamed:@"airplane"];
    
    //        if([flight isEqualToString:[oldLocation stringForKey:@"flight"]]){
    //            NSLog(@"old flight = %@",[oldLocation stringForKey:@"flight"]);
    //            [mapView_ clear];
    //            marker3.position = CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]);
    //            marker3.snippet = flight;
    //
    //            GMSMutablePath *path = [GMSMutablePath path];
    //            [path addCoordinate:CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue])];
    //            [path addCoordinate:CLLocationCoordinate2DMake([oldLocation doubleForKey:@"latitude"], [oldLocation doubleForKey: @"longitude"])];
    //            GMSPolyline *line = [GMSPolyline polylineWithPath:path];
    //            line.strokeWidth = 1.f;
    //            line.strokeColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:.8];
    //            line.geodesic = YES;
    //            line.map = mapView_;
    //            marker3.map = mapView_;
    //
    //
    //        }
    
    
    
    //self.view= mapView_;
    //        [self.view reloadInputViews];
    
    //    }
    
    //  marker3.title = flight;
    
    
    // mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,70,320,300) camera:camera];
    
    // mapView_.reloadInputViews;
    
    /*
     899015,
     "CAL5509 ",
     Taiwan,
     1489338159,
     1489338159,
     "9.48",
     "49.9266",
     "7315.2",
     0,
     "223.02",
     "260.84",
     0,
     "<null>",
     "7315.2",
     "<null>",
     0,
     0
     
     
     
     */
    
    
}

//-(void)testUse{
//
//    if ([[UIApplication sharedApplication] canOpenURL:
//         [NSURL URLWithString:@"comgooglemaps://"]]) {
//        [[UIApplication sharedApplication] openURL:
//         [NSURL URLWithString:@"comgooglemaps://?center=25.0049048,121.5066303&zoom=14&views=traffic"]];
//    } else {
//        NSLog(@"Can't use comgooglemaps://");
//    }
//
//
//}

//- (void)dealloc {
//    [_pickers release];
//    [super dealloc];
//}
@end
