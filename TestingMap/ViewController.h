//
//  ViewController.h
//  TestingMap
//
//  Created by Dheeraj Kaveti on 11/12/12.
//  Copyright (c) 2012 Dheeraj Kaveti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *mapKView;
typedef NS_ENUM(NSInteger, RWMapMode) {
    RWMapModeNormal = 0,
    RWMapModeLoading,
    RWMapModeDirections,
};
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlSwitch;
@property (retain, nonatomic) IBOutlet UISlider *sliderforMiles;

@property (retain, nonatomic) IBOutlet UISearchBar *addressSearchBar;

-(void)showInMaps:(id)sender ;
-(IBAction)changeSeg;
- (IBAction) sliderValueChanged:(id)sender;
@end
