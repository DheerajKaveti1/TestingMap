//
//  ViewController.m
//  TestingMap
//
//  Created by Dheeraj Kaveti on 11/12/12.
//  Copyright (c) 2012 Dheeraj Kaveti. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"
#import "poupAnnotationViewController.h"
@interface ViewController ()
@property(nonatomic,strong) NSDictionary *json;
@property(nonatomic,strong) NSMutableArray *contacts;
@property(nonatomic,strong)   MKPolyline *mapPolyline;
 @property(nonatomic,strong)CustomAnnotation *_droppedPin;
@property(nonatomic)   CLLocationCoordinate2D agentcoordinate;
@property(nonatomic,retain) NSString *searchString;
@property(nonatomic,retain) NSArray *pickerArray;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property  int pi;
@end

@implementation ViewController
@synthesize json,contacts,mapKView,agentcoordinate,pi,locationManager;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _pickerArray=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"All",nil];
       mapKView.delegate=self;
        NSData *data =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contact_list" ofType:@"json"]];
    NSError *error;
    _addressSearchBar.delegate=self;
    self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"loans: %@", json);
    NSArray* latestLoans = [[[NSArray alloc]initWithArray: json[@"contact"] ]autorelease]; //2
    NSUInteger loanCount =latestLoans.count;
    self.contacts=[[NSMutableArray alloc]initWithCapacity:loanCount];

    NSInteger i = 0;
 

    
    for (NSDictionary *stationDictionary in latestLoans) {
     CLLocationDegrees latitude =[[stationDictionary objectForKey:@"lattittude"] floatValue];
    CLLocationDegrees  longitude =[[stationDictionary objectForKey:@"longittude"] floatValue];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    CustomAnnotation *annotation =[[CustomAnnotation alloc]init];
    annotation.title =[stationDictionary objectForKey:@"LastName"];
    annotation.coordinate = coord;
    annotation.subtitle=[stationDictionary objectForKey:@"Sequoia"];
    annotation.address=[stationDictionary objectForKey:@"AddressLine1"];
    annotation.zip=[stationDictionary objectForKey:@"Zip"];
    annotation.email=[stationDictionary objectForKey:@"Email"];
    annotation.insuAgType=[stationDictionary objectForKey:@"Account"];
    annotation.state=[stationDictionary objectForKey:@"State"];
    annotation.city=[stationDictionary objectForKey:@"City"];
    [contacts addObject:annotation];
    i++;
    }
        //Setting up the Screen Region
        mapKView.showsUserLocation=YES;
        locationManager=[[[CLLocationManager alloc]init]autorelease];
        locationManager.delegate=self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
        
        CLLocation *location = [locationManager location];
        
        agentcoordinate = location.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(agentcoordinate, 100000, 100000);
        MKCoordinateRegion adjustedRegion = [mapKView regionThatFits:viewRegion];
        
        
        [mapKView setRegion:adjustedRegion animated:YES];
        
        [mapKView addAnnotations:contacts];

}
    
-(void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [mapKView release];
    [_addressSearchBar release];
    [_segmentedControlSwitch release];
    [_sliderforMiles release];
    [super dealloc];
}

#pragma mark - MAPVIEW DELEGATEMETODS
- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        static NSString *const kPinIdentifier = @"RWStation";
          MKPinAnnotationView *view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:kPinIdentifier];

        if (!view) {
            view = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinIdentifier] autorelease];
            view.canShowCallout = YES;
            view.calloutOffset = CGPointMake(-5, 5);
            view.animatesDrop = YES;
        }
        if ([[annotation subtitle]isEqualToString:@"A"] ) {
            view.pinColor=MKPinAnnotationColorGreen;
            pi++;
        }
     else if ([[annotation subtitle]isEqualToString:@"B"] ) {
            view.pinColor=MKPinAnnotationColorRed;
         pi++;
        }
       else if ([[annotation subtitle]isEqualToString:@"C"] ) 
        {
        view.pinColor=MKPinAnnotationColorPurple;
            pi++;
            
        }
        else
        {
            view.pinColor=MKPinAnnotationColorPurple;
             pi++;
        }
        
        NSLog(@"%d",pi);
        view.draggable = NO;
        return view;
    }

    return nil;
}
- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineView *overlayView =
    [[[MKPolylineView alloc] initWithPolyline:overlay ]autorelease];
    overlayView.lineWidth = 2.0f;
    overlayView.strokeColor = [UIColor greenColor];
    return overlayView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    CustomAnnotation *sendAnn = [[CustomAnnotation alloc] init];
    sendAnn = view.annotation;
    agentcoordinate=sendAnn.coordinate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    poupAnnotationViewController *controller  = [storyboard instantiateViewControllerWithIdentifier:@"annotationPopUp"];
    
    controller.hello=  sendAnn;
    controller.coordinate=mapKView.userLocation.coordinate;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    
    [popover presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ShowCurrentUSerLocation:(id)sender {
//    if (!mapKView.userLocationVisible) {
    _sliderforMiles.hidden=false;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(mapKView.userLocation.coordinate, 10000, 10000);
     _sliderforMiles.value=0.0;
        MKCoordinateRegion adjustedRegion = [mapKView regionThatFits:viewRegion];
        [mapKView setRegion:adjustedRegion animated:YES];
//    }
    
}


#pragma mark - Search Bar Delegate Methods
- (void)updateSearchString:(NSString*)aSearchString
{
    _searchString=[[NSString alloc]initWithString:aSearchString];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    [self updateSearchString:searchBar.text];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _sliderforMiles.hidden=false;
    _sliderforMiles.value=0.0;
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
     NSLog(@"%@",searchBar.text);
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"geocodeAddressString:completionHandler: Completion Handler called!");
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Wrong Address" message:@"please enter correct address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show
             ];
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks);
        CLPlacemark* mark = (CLPlacemark*)placemarks[0];
        double lat = mark.location.coordinate.latitude;
        double lng = mark.location.coordinate.longitude;
        agentcoordinate.latitude=lat;
        agentcoordinate.longitude=lng;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(agentcoordinate, 10000, 10000);
        MKCoordinateRegion adjustedRegion = [mapKView regionThatFits:viewRegion];
        [mapKView setRegion:adjustedRegion animated:YES];
        
    }];
    
}

#pragma mark - Button ANd Picker Delegates
-(IBAction)changeSeg{
    NSMutableArray *filterContacts=[[[NSMutableArray alloc]init]autorelease];
    BOOL filtercontactsselected = 0;
    if(_segmentedControlSwitch.selectedSegmentIndex == 0){
        if(filtercontactsselected==true)
        {
        [mapKView removeAnnotations:filterContacts];
        }
        else
        {
            [mapKView removeAnnotations:contacts];
        }
        pi=0;
        [mapKView addAnnotations:contacts];
    
	}
	else if(_segmentedControlSwitch.selectedSegmentIndex == 1){
         [mapKView removeAnnotations:contacts];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subtitle == %@",@"A"];
        filterContacts = (NSMutableArray *)[contacts filteredArrayUsingPredicate:predicate];
        filtercontactsselected=true;
         [mapKView removeOverlay:_mapPolyline];
        [mapKView addAnnotations:filterContacts];
	}
   else if(_segmentedControlSwitch.selectedSegmentIndex == 2){
        [mapKView removeAnnotations:contacts];
       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subtitle == %@",@"B"];
       filterContacts = (NSMutableArray *)[contacts filteredArrayUsingPredicate:predicate];
       filtercontactsselected=true;
        [mapKView removeOverlay:_mapPolyline];
        [mapKView addAnnotations:filterContacts];
	}
  else  if(_segmentedControlSwitch.selectedSegmentIndex == 3){
        [mapKView removeAnnotations:contacts];
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subtitle == %@",@"C"];
       [mapKView removeOverlay:_mapPolyline];
      filtercontactsselected=true;
          
      filterContacts = (NSMutableArray *)[contacts filteredArrayUsingPredicate:predicate];
          
          
        [mapKView addAnnotations:filterContacts];
	}
}
#pragma mark - Drawing Directions
- (IBAction)drawDirections:(id)sender {
    [mapKView removeOverlay:_mapPolyline];
     _sliderforMiles.value=0.0;
    CLLocationCoordinate2D *polylineCoords =malloc(sizeof(CLLocationCoordinate2D) * 2);
    polylineCoords[0] = mapKView.userLocation.coordinate;
    polylineCoords[1]=agentcoordinate;
    _mapPolyline =[MKPolyline polylineWithCoordinates:polylineCoords count:2];
    free(polylineCoords);
    [self.mapKView addOverlay:_mapPolyline];
}
#pragma mark - SliderMethods
- (IBAction) sliderValueChanged:(UISlider *)sender {
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(agentcoordinate, 10000*[sender value], 10000*[sender value]);
    MKCoordinateRegion adjustedRegion = [mapKView regionThatFits:viewRegion];
    [mapKView setRegion:adjustedRegion animated:YES];
    

	
}
- (IBAction)showEntireUSA:(id)sender {
    agentcoordinate=mapKView.userLocation.coordinate;
     _sliderforMiles.value=0.0;
    _sliderforMiles.hidden=true;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(agentcoordinate, 8000000, 8000000);
    MKCoordinateRegion adjustedRegion = [mapKView regionThatFits:viewRegion];
    [mapKView setRegion:adjustedRegion animated:YES];
}
#pragma mark - CLLlocation Delegate Methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}


@end
