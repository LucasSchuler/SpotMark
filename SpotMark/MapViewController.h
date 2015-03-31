//
//  MapViewController.h
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 27/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Event.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property Event *evt;
@property NSString *txtAdress;

@end
