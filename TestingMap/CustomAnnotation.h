//
//  CustomAnnotation.h
//  TestingMap
//
//  Created by Dheeraj Kaveti on 11/12/12.
//  Copyright (c) 2012 Dheeraj Kaveti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
@interface CustomAnnotation : NSObject<MKAnnotation>{
	
	CLLocationCoordinate2D	coordinate;
	NSString *title,*type;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString *title,*type,*subtitle,*accounttype,*email,*address,*city,*zip,*state,*insuAgType;
- (MKMapItem*)mapItem;
@end
