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

@end

@implementation NewEventsViewController

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
}
//
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
    [dateFormat setDateFormat:@"d/M/YYYY hh:mm"];
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
    
    // ADICIONA O USUARIO AO EVENTO
    PFObject *userEvent = [PFObject objectWithClassName:@"UserEvent"];
    userEvent [@"user"] = user1.objectId;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
