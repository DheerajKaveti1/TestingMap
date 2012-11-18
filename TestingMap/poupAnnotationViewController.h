//
//  poupAnnotationViewController.h
//  TestingMap
//
//  Created by Dheeraj Kaveti on 11/13/12.
//  Copyright (c) 2012 Dheeraj Kaveti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAnnotation.h"

@interface poupAnnotationViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *titleofthen;
- (IBAction)pushButton:(id)sender;
@property(nonatomic,retain)CustomAnnotation *hello;
@property (retain, nonatomic) IBOutlet UIButton *getDirections;
@property (retain, nonatomic) IBOutlet UILabel *accountTypeLbl;
@property (retain, nonatomic) IBOutlet UILabel *emailLbl;
@property (retain, nonatomic) IBOutlet UILabel *addressLbl;
@property (retain, nonatomic) IBOutlet UILabel *stateLbl;
@property (nonatomic, assign) CLLocationCoordinate2D	coordinate;
@end
