//
//  CreateViewController.m
//  GeoReminders
//
//  Created by Javier Rosas on 5/26/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "CreateViewController.h"
#import "User.h"
#import "Reminder.h"

@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateField;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)setupView {
    // Add save button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTapped:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Style detailsField TextView
    self.detailsField.layer.borderWidth = 1;
    self.detailsField.layer.borderColor = [[[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:1] CGColor];
    self.detailsField.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveTapped:(id)sender {
    User *user = [User getLoggedUser];
    Reminder *newReminder = [[Reminder alloc] initWithEntity:[NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:user.managedObjectContext] insertIntoManagedObjectContext:user.managedObjectContext];
    newReminder.title = self.titleField.text;
    newReminder.details = self.detailsField.text;
    newReminder.date = self.dateField.date;
    
    [user addRemindersObject:newReminder];
    NSError *error = nil;
    [user.managedObjectContext save:&error];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
