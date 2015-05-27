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
    self.detailsField.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    self.detailsField.layer.cornerRadius = 5;
    
    // Populate in edit mode
    if (self.reminder) {
        self.titleField.text = self.reminder.title;
        self.detailsField.text = self.reminder.details;
        if (self.reminder.date) {
            self.dateField.date = self.reminder.date;
            self.modeSelector.selectedSegmentIndex = 0;
        } else {
            // TODO: populate lat and lon in map View
            self.modeSelector.selectedSegmentIndex = 1;
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveTapped:(id)sender {
    if (self.reminder) {
        [self editCurrentReminder];
    } else {
        [self createReminder];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createReminder {
    User *user = [User getLoggedUser];
    Reminder *newReminder = [[Reminder alloc] initWithEntity:[NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:user.managedObjectContext] insertIntoManagedObjectContext:user.managedObjectContext];
    newReminder.title = self.titleField.text;
    newReminder.details = self.detailsField.text;
    if (self.modeSelector.selectedSegmentIndex == 0) {
        newReminder.lat = nil;
        newReminder.lon = nil;
        newReminder.date = self.dateField.date;
    } else {
        newReminder.date = nil;
        // TODO: set lat and lon from map View
    }
    
    [user addRemindersObject:newReminder];
    NSError *error = nil;
    [user.managedObjectContext save:&error];
}

- (void)editCurrentReminder {
    self.reminder.title = self.titleField.text;
    self.reminder.details = self.detailsField.text;
    if (self.modeSelector.selectedSegmentIndex == 0) {
        self.reminder.lat = nil;
        self.reminder.lon = nil;
        self.reminder.date = self.dateField.date;
    } else {
        self.reminder.date = nil;
        // TODO: set lat and lon from map View
    }
    NSError *error = nil;
    [self.reminder.managedObjectContext save:&error];
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
