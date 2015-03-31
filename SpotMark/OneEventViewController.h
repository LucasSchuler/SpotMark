//
//  OneEventViewController.h
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 25/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Event.h"


@interface OneEventViewController : UIViewController <MKMapViewDelegate,UIAlertViewDelegate,UITableViewDelegate , UITableViewDataSource>

@property Event *evt;
@property BOOL newEvent;
@property NSMutableArray *posts;

@end
