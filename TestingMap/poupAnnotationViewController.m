//
//  poupAnnotationViewController.m
//  TestingMap
//
//  Created by Dheeraj Kaveti on 11/13/12.
//  Copyright (c) 2012 Dheeraj Kaveti. All rights reserved.
//

#import "poupAnnotationViewController.h"

@interface poupAnnotationViewController ()

@end

@implementation poupAnnotationViewController
@synthesize coordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initwithDetails:(id)sender
{
    return sender;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleofthen.text=_hello.title;
    _addressLbl.text=_hello.address;
    _emailLbl.text=_hello.email;
    _accountTypeLbl.text=_hello.insuAgType;
    _stateLbl.text=_hello.state;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)navigatetoDirections:(id)sender {
    MKMapItem *mapItem =[_hello mapItem];
    NSDictionary *launchOptions =
    @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [mapItem openInMapsWithLaunchOptions:launchOptions];
}


- (void)dealloc {
    [_titleofthen release];
    [_getDirections release];
    [_accountTypeLbl release];
    [_emailLbl release];
    [_addressLbl release];
    [_stateLbl release];
    [super dealloc];
}
@end
