//
//  SecondViewController.m
//  GeoReminders
//
//  Created by Javier Rosas on 5/21/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "CurrentRemindersController.h"
#import "User.h"
#import "Reminder.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface CurrentRemindersController ()

@property User *currentUser;
@property NSArray *reminders;

@property NSDateFormatter *dateFormatter;

@end

@implementation CurrentRemindersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentUser = [User getLoggedUser];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:self.currentUser.name delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewReminder:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setup];
    [self reloadTable];
}

- (void)setup {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterFullStyle;
}

- (void)reloadTable {
    self.reminders = [self.currentUser.reminders allObjects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger remindersCount = self.currentUser.reminders.count;
    return remindersCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentReminderCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Reminder *reminder = (Reminder *)self.reminders[indexPath.row];
    cell.textLabel.text = reminder.title;
    if (reminder.date) {
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:reminder.date];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"lat: %@, lon: %@", reminder.lat, reminder.lon];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Reminder *reminder = self.reminders[indexPath.row];
    [self performSegueWithIdentifier:@"Detail" sender:reminder];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.currentUser removeRemindersObject:self.reminders[indexPath.row]];
    NSError *error = nil;
    [self.currentUser.managedObjectContext save:&error];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}

- (void)addNewReminder:(id)sender {

    [self performSegueWithIdentifier:@"Create" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Detail"]) {
        Reminder *reminder = (Reminder *)sender;
        DetailViewController *detailController = (DetailViewController *)segue.destinationViewController;
        detailController.reminder = reminder;
    }
}

@end
