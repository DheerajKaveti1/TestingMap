//
//  CustomAnnotation.m
//  TestingMap
//
//  Created by Dheeraj Kaveti on 11/12/12.
//  Copyright (c) 2012 Dheeraj Kaveti. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize title,type;
@synthesize coordinate,subtitle;
@synthesize address,accounttype,state,city,zip;
- (MKMapItem*)mapItem {
    // 1
    NSDictionary *addressDict = @{
    (NSString*)kABPersonAddressCountryKey : @"USA",
    (NSString*)kABPersonAddressCityKey :city,
    (NSString*)kABPersonAddressStreetKey :address,
    (NSString*)kABPersonAddressZIPKey : zip
    };
    
    // 2
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    
    // 3
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    mapItem.phoneNumber = @"573-356-2598";
    mapItem.url = [NSURL URLWithString:@"http://www.raywenderlich.com/"];
    return mapItem;
}

@end
