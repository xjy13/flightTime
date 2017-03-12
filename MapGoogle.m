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

@interface MapGoogle(){


}
@end
@implementation MapGoogle

GMSMapView *mapView_;
NSSet *markers;
UIButton *backBtn;
- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6. //-33.86 151.20
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 25.0049048
                                                            longitude: 121.5066303
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,70,320,300) camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    [self.view addSubview:mapView_];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(25.0049048,121.5066303);
    marker.title = @"許狗家";
    marker.snippet = @"新北中和";
    marker.map = mapView_;
    GMSMarker *marker1 = [[GMSMarker alloc] init];
    marker1.position = CLLocationCoordinate2DMake(25.0752798,121.2091734);
    marker1.title = @"吉娃娃人家";
    marker1.snippet = @"桃園大園";
    marker1.map = mapView_;
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(30,30, 28, 28)];
    [backBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:backBtn];
    [self testUse];
    
    
}
-(void)backAction:(UIButton *)btn{

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)testUse{

   // NSLog(@"Get in MapGoogle = %@",[GetLocation jsonLocation]);
    NSMutableArray *point = [[NSMutableArray alloc] init];
    [point addObjectsFromArray:[GetLocation jsonLocation]];
    NSLog(@"point array is =%@",point);
    NSString *longitude = [[point objectAtIndex:0] objectAtIndex:5];
    NSString *latitude = [[point objectAtIndex:0] objectAtIndex:6];
    NSString *flight = [[point objectAtIndex:0] objectAtIndex:1];
    GMSMarker *marker3 = [[GMSMarker alloc] init];
    marker3.position = CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]);
  //  marker3.title = flight;
    marker3.snippet = flight;
    marker3.map = mapView_;
    
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
