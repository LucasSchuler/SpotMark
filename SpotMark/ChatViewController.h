//
//  ChatViewController.h
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 25/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface ChatViewController : UIViewController <UITextViewDelegate>

@property Event *evt;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UITextView *tvChat;

- (IBAction)sendMessage:(id)sender;
-(void)sendMyMessage;

@end
