//
//  ViewController.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 21/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet __block FBLoginView *loginView;

@end

