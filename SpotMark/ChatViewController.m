//
//  ChatViewController.m
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 25/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "ChatViewController.h"
#import "Event.h"
#import "Message.h"
#import "User.h"
#import <Parse/Parse.h>
#import "loadParse.h"

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property User *user1;
@property (weak, nonatomic) IBOutlet UITableView *hitoricalMessagesTableView;

@end

@implementation ChatViewController{
    CGFloat _initialConstant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _user1 = [User sharedUser];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = _evt.name;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[self loadViewMessages];
}

/*-(void) loadViewMessages{
    [_tvChat setText:@""];
    loadParse *lp = [[loadParse alloc] init];
    _messages = [lp loadChat:_eventId];
    for(int i=0; i<_messages.count; i++){
        PFObject *m = [_messages objectAtIndex:i];
        if([_user1.objectId isEqualToString:m[@"userId"]]){
            _tvChat.textAlignment=NSTextAlignmentRight;
            [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ :\n %@ \n\n", m[@"userName"], m[@"message"]]]];
        }else{
             _tvChat.textAlignment=NSTextAlignmentLeft;
            [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ :\n %@ \n\n", m[@"userName"], m[@"message"]]]];
        }
    }
}
*/
//static CGFloat keyboardHeightOffset = 0.0f;

- (IBAction)sendMessage:(id)sender {
   /* Message *m = [[Message alloc]init];
    m.userName = _user1.name;
    m.userId = _user1.objectId;
    m.eventId = _eventId;
    m.message = _txtMessage.text;
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message [@"userName"] = m.userName;
    message [@"userId"] = m.userId;
    message [@"eventId"] = m.eventId;
    message [@"message"] = m.message;
    if(![m.message isEqual:@""])
        [message saveInBackground];
    [_txtMessage setText:@""];
    [self loadViewMessages];
}

//MARK: Keyboard Methods
- (IBAction)dismissKeyboard {
    // This method will resign all responders, dropping the keyboard.
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    // Getting the keyboard frame and animation duration.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstant) {
        _initialConstant = _constraintBottom.constant;
    }
    
    // If screen can fit everything, leave the constant untouched.
    _constraintBottom.constant = MAX(keyboardFrame.size.height + keyboardHeightOffset, _initialConstant);
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        // This method will automatically animate all views to satisfy new constants.
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Putting everything back to place.
    _constraintBottom.constant = _initialConstant;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
*/



@end
