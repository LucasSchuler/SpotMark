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
#import "AppDelegate.h"

@interface NewEventsViewController ()< UIGestureRecognizerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtLocalization;
@property (weak, nonatomic) IBOutlet UISegmentedControl *category;
@property Event *e;
@property NSArray *listCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CreateButton;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property UIActionSheet *pickerViewPopup;
@property UIDatePicker *dtPicker;

@end

@implementation NewEventsViewController{
    CGFloat _initialConstant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _listCategory = @[@"Sport", @"Party", @"Laisure", @"Meeting"];
    [self createDatePicker];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = @"New Event";
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    _txtDescription.delegate = self;
    _txtDescription.text = @"Description";
    _txtDescription.textColor = [UIColor colorWithRed:0.29803922 green:0.5333333 blue:0.48235294 alpha:0.8 ];
    

}

-(void)createDatePicker{
    _dtPicker = [[UIDatePicker alloc]init];
    _dtPicker.datePickerMode=UIDatePickerModeDateAndTime;
    [_txtDate setInputView:_dtPicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn,nil]];
    [_txtDate setInputAccessoryView:toolBar];
}

-(void) ShowSelectedDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"d/M/YYYY HH:mm"];
    _txtDate.text = [formatter stringFromDate:_dtPicker.date];
    [_txtDate resignFirstResponder];
}

static CGFloat keyboardHeightOffset = 0.0f;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)create:(id)sender {
    User *user1 = [User sharedUser];
    
    //CRIA O EVENTO
    @try {
        
        NSDate *now = [NSDate date];
        NSLog(@"%@",_dtPicker.date);
        if([now compare: _dtPicker.date] == NSOrderedDescending){
            NSException *exception = [NSException exceptionWithName:@"" reason:@"This date already passed" userInfo:nil];
            @throw exception;
        }
            _e = [[Event alloc]initWithValues:_txtName.text : _txtDescription.text : _txtLocalization.text : _txtDate.text : [_category titleForSegmentAtIndex:[_category selectedSegmentIndex]] : user1.email];
        
        //ADICIONA O EVENTO AO PARSE
        NSMutableArray *usuario = [[NSMutableArray alloc]init];
        [usuario addObject:user1.objectId];
        PFObject *saveObject = [PFObject objectWithClassName:@"Event"];
        saveObject[@"name"] =  _e.name;
        saveObject[@"description"] = _e.desc;
        saveObject[@"local"] = _e.local;
        saveObject[@"datetime"] = _e.datetime;
        saveObject[@"admin"] = user1.email;
        saveObject[@"category"] = _e.category;
        saveObject[@"members"] = usuario;
        [saveObject save];
        _e.idEvent = saveObject.objectId;
        // _e.admin = user1.email;
        
        
        
        // SE NAO OCORRER ERRO MOSTRA MENSAGEM E VAI P/ A TELA DO EVENTO
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfully created event!"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
//        [self performSegueWithIdentifier:@"gotoOneEvent" sender:nil];
        
        
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        app.eventCreated = _e;
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    @catch (NSException *e) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:[NSString stringWithFormat:@"%@", e]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    OneEventViewController *oevt = (OneEventViewController *) segue.destinationViewController;
    oevt.evt = _e;
    oevt.newEvent=YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return NO;
}



- (BOOL) hidesBottomBarWhenPushed{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Description"]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Description";
        textView.textColor = [UIColor colorWithRed:0.29803922 green:0.5333333 blue:0.48235294 alpha:0.8]; //optional
    }
    [textView resignFirstResponder];
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
