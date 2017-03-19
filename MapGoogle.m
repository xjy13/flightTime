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

@interface MapGoogle()<GMSMapViewDelegate>{


}
@end
@implementation MapGoogle

GMSMapView *mapView_;
NSSet *markers;
UIButton *backBtn;
NSTimer *refreshRoute;
GMSCameraPosition *camera;
GMSMarker *marker3;
NSUserDefaults *oldLocation;
double x,y;
- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6. //-33.86 151.20
    
    [self getFlightLocation];
  
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,70,320,320) camera:camera];
    [self.view addSubview:mapView_];
    
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.scrollGestures = YES;
   // [self.view addSubview:mapView_];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(25.0049048,121.5066303);
//    marker.title = @"許狗家";
//    marker.snippet = @"新北中和";
//    marker.map = mapView_;
//    GMSMarker *marker1 = [[GMSMarker alloc] init];
//    marker1.position = CLLocationCoordinate2DMake(25.0752798,121.2091734);
//    marker1.title = @"吉娃娃人家";
//    marker1.snippet = @"桃園大園";
//    marker1.map = mapView_;
    
    
   
   

    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,30, 28, 28)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    refreshRoute = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(realTime) userInfo:nil repeats:YES];
    [refreshRoute fire];
}

-(void)viewDidDisappear:(BOOL)animated{
    [refreshRoute invalidate];
    [mapView_ clear];
    [mapView_ removeFromSuperview];

  
}
-(void)backAction:(UIButton *)btn{

    [self.navigationController popViewControllerAnimated:YES];

}
-(void)getFlightLocation{

    NSMutableArray *pointFirst = [[NSMutableArray alloc] init];
    [pointFirst addObjectsFromArray:[GetLocation jsonLocation]];
  //  NSLog(@"point array is =%@",pointFirst);
    
    NSString *longitude = [[pointFirst objectAtIndex:4] objectAtIndex:5];
    NSString *latitude = [[pointFirst objectAtIndex:4] objectAtIndex:6];
    NSString *flightName = [[pointFirst objectAtIndex:4]objectAtIndex:1];
    
    camera = [GMSCameraPosition cameraWithLatitude: [latitude floatValue]
                                         longitude: [longitude floatValue]
                                              zoom:10];
    
    oldLocation = [NSUserDefaults standardUserDefaults];
    [oldLocation setObject:flightName forKey:@"flight"];
    [oldLocation setDouble:[latitude doubleValue] forKey:@"latitude"];
    [oldLocation setDouble:[longitude doubleValue] forKey:@"longitude"];


}

-(void)realTime{
    //[mapView_ clear];
    [mapView_ clear];
    NSString *longitude;
    NSString *latitude;
    NSString *flight;
   // NSLog(@"Get in MapGoogle = %@",[GetLocation jsonLocation]);
    NSMutableArray *point = [[NSMutableArray alloc] init];
    [point addObjectsFromArray:[GetLocation jsonLocation]];
    NSLog(@"point array count = %d",point.count);
    NSLog(@"point array is =%@",point);
    for (int i = 0 ; i < point.count ; i++){
        longitude = [[point objectAtIndex:i] objectAtIndex:5];
        latitude = [[point objectAtIndex:i] objectAtIndex:6];
        flight = [[point objectAtIndex:i] objectAtIndex:1];
        if(latitude !=nil && longitude != nil && flight !=nil){
          //  [mapView_ clear];
            camera = [GMSCameraPosition cameraWithLatitude: [latitude doubleValue]
                                                 longitude: [longitude doubleValue]
                                                      zoom:10];
            marker3 = [[GMSMarker alloc] init];
            marker3.position = CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);
            if([flight hasPrefix:@"CAL"] || [flight  hasPrefix:@"MDA"] ){
             marker3.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:185.0/255.0 green:173.0/255.0 blue:200.0/255.0 alpha:1.0]];
                 marker3.snippet = flight;
            }
            if([flight hasPrefix:@"EVA"] || [flight hasPrefix:@"UIA"]){
                 marker3.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:46.0/255.0 green:141.0/255.0 blue:57.0/255.0 alpha:1.0]];
                   marker3.snippet = flight;
            }
            if([flight hasPrefix:@"FE"]){
              marker3.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                   marker3.snippet = flight;
            }
            if([flight hasPrefix:@"TTW"]){
             marker3.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:254.0/255.0 green:227.0/255.0 blue:72.0/255.0 alpha:1.0]];
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

@end
