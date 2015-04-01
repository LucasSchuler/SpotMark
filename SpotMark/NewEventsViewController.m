//
//  NewEventsViewController.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 24/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "NewEventsViewController.h"
#import "OneEventViewController.h"
#import "Event.h"
#import <Parse/Parse.h>
#import "User.h"

@interface NewEventsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtLocalization;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *category;
@property Event *e;
@property NSArray *listCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CreateButton;


@end

@implementation NewEventsViewController{
    CGFloat _initialConstant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    _listCategory = @[@"Esporte", @"Reunião", @"Lazer", @"Festa"];
    
    [self.datePicker setValue:[UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.70] forKeyPath:@"textColor"];
    
    
    
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self.datePicker];
    
    
    
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.7]};
    self.title = @"New Event";
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

static CGFloat keyboardHeightOffset = 0.0f;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)create:(id)sender {
    User *user1 = [User sharedUser];
    
    //CRIA O EVENTO
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    _e = [[Event alloc] init];
    _e.name = _txtName.text;
    _e.desc = _txtDescription.text;
    _e.local = _txtLocalization.text;
    [dateFormat setDateFormat:@"d/M/YYYY HH:mm"];
    _e.datetime = [dateFormat stringFromDate:_datePicker.date];
   // [dateFormat setDateFormat:@"hh:mm"];
    //_e.time = [dateFormat stringFromDate:_datePicker.date];
    _e.category = [_category titleForSegmentAtIndex:[_category selectedSegmentIndex]];
    
    //ADICIONA O EVENTO AO PARSE
    PFObject *saveObject = [PFObject objectWithClassName:@"Event"];
    saveObject[@"name"] =  _e.name;
    saveObject[@"description"] = _e.desc;
    saveObject[@"local"] = _e.local;
    saveObject[@"datetime"] = _e.datetime;
    saveObject[@"admin"] = user1.email;
    saveObject[@"category"] = _e.category;
    [saveObject save];
    _e.idEvent = saveObject.objectId;
    _e.admin = user1.email;
    
    // ADICIONA O USUARIO AO EVENTO
    PFObject *userEvent = [PFObject objectWithClassName:@"UserEvent"];
    userEvent [@"user"] = user1.objectId;
    userEvent [@"userName"] = user1.name;
    userEvent [@"event"] = _e.idEvent;
    [userEvent saveInBackground];
    
    // SE NAO OCORRER ERRO MOSTRA MENSAGEM E VAI P/ A TELA DO EVENTO
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Evento criado com sucesso!"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self performSegueWithIdentifier:@"gotoOneEvent" sender:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    OneEventViewController *oevt = (OneEventViewController *) segue.destinationViewController;
    oevt.evt = _e;
    oevt.newEvent=YES;
}

- (BOOL) hidesBottomBarWhenPushed{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (void)keyboardWillShow:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstant) {
        _initialConstant = _CreateButton.constant;
    }
    
    // If screen can fit everything, leave the constant untouched.
    _CreateButton.constant = MAX(keyboardFrame.size.height + keyboardHeightOffset, _initialConstant);
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        // This method will automatically animate all views to satisfy new constants.
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Putting everything back to place.
    _CreateButton.constant = _initialConstant;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}


@end
