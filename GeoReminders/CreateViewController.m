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
#import "AppDelegate.h"
//#import "NotificationService.h"
#import "GeoReminders-Swift.h"
#import <MapKit/MapKit.h>

@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coordinateToRemind;

@property (nonatomic) BOOL hasCenteredMap;

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Fix scrollView problems
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.mapView.delegate = self;
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
            [self switchToTimeMode];
        } else {
            self.modeSelector.selectedSegmentIndex = 1;
            [self switchToLocationMode];
            self.coordinateToRemind = CLLocationCoordinate2DMake([self.reminder.lat doubleValue], [self.reminder.lon doubleValue]);
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = @"Remind here";
            annotation.coordinate = self.coordinateToRemind;
            [self.mapView addAnnotation:annotation];
        }
    }
    
    // Set view title
    if (self.reminder)
        self.title = @"Edit";
    else
        self.title = @"Create";
    
    // Reset validation to center map at user location
    self.hasCenteredMap = NO;
    
    // Add handler for map long press
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapLongPress:)];
    [self.mapView addGestureRecognizer:longPressRecognizer];
    
    self.coordinateToRemind = kCLLocationCoordinate2DInvalid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchToTimeMode {
    self.dateField.hidden = false;
    self.mapView.hidden = true;
    self.coordinateToRemind = kCLLocationCoordinate2DInvalid;
}

- (void)switchToLocationMode {
    self.dateField.hidden = true;
    self.mapView.hidden = false;
}

- (IBAction)modeSelected:(id)sender {
    switch(self.modeSelector.selectedSegmentIndex) {
        case 0:
            [self switchToTimeMode];
            break;
        case 1:
            [self switchToLocationMode];
            break;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.hasCenteredMap) {;
        mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100, 100);
        self.hasCenteredMap = YES;
    }
}

- (void)handleMapLongPress:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = @"Set reminder here";
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:annotation];
        
        self.coordinateToRemind = coordinate;
    }
}

- (void)saveTapped:(id)sender {
    // Validate form
    // DatePicker should not be prior to today
    
    BOOL dateIsOlderThanNow = [self.dateField.date compare:[NSDate date]] == NSOrderedAscending;
    BOOL isReminderByDate = self.modeSelector.selectedSegmentIndex == 0;
    BOOL coordinateIsSet = CLLocationCoordinate2DIsValid(self.coordinateToRemind);
    if (dateIsOlderThanNow && isReminderByDate) {
        [self alertWithTitle:@"Hmmm" message:@"I can't remind you in the past"];
    } else if (!coordinateIsSet && !isReminderByDate) {
        [self alertWithTitle:@"Couldn't save" message:@"You must set a location for this reminder"];
    } else if (self.titleField.text.length == 0) {
        [self alertWithTitle:@"Couldn't save" message:@"Reminder must have a title"];
    } else {
        if (self.reminder) {
            [self editCurrentReminder];
        } else {
            [self createReminder];
        }
        if (self.reminder.date) {
            [NotificationService scheduleReminderNotification:self.reminder];
        } else {
            [self.appDelegate monitorRegionWithCenter:self.coordinateToRemind uuid:self.reminder.uuid];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)createReminder {
    User *user = [User getLoggedUser];
    self.reminder = [[Reminder alloc] initWithEntity:[NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:user.managedObjectContext] insertIntoManagedObjectContext:user.managedObjectContext];
    self.reminder.title = self.titleField.text;
    self.reminder.details = self.detailsField.text;
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    self.reminder.uuid = uuid;
    
    if (self.modeSelector.selectedSegmentIndex == 0) {
        self.reminder.lat = nil;
        self.reminder.lon = nil;
        self.reminder.date = [self dateWithZeroSeconds:self.dateField.date];
    } else {
        self.reminder.date = nil;
        self.reminder.lat = @(self.coordinateToRemind.latitude);
        self.reminder.lon = @(self.coordinateToRemind.longitude);
    }
    
    [user addRemindersObject:self.reminder];
    NSError *error = nil;
    [user.managedObjectContext save:&error];
}

- (void)editCurrentReminder {
    // Cancel either date or location motification
    [NotificationService cancelReminderNotification:self.reminder.uuid];
    [self.appDelegate cancelMonitoringRegionWithUUID:self.reminder.uuid];
    
    self.reminder.title = self.titleField.text;
    self.reminder.details = self.detailsField.text;
    
    self.reminder.uuid = [[NSUUID UUID] UUIDString];
    
    if (self.modeSelector.selectedSegmentIndex == 0) {
        self.reminder.lat = nil;
        self.reminder.lon = nil;
        self.reminder.date = [self dateWithZeroSeconds:self.dateField.date];
    } else {
        self.reminder.date = nil;
        self.reminder.lat = @(self.coordinateToRemind.latitude);
        self.reminder.lon = @(self.coordinateToRemind.longitude);
    }
    NSError *error = nil;
    [self.reminder.managedObjectContext save:&error];
}

- (NSDate *)dateWithZeroSeconds:(NSDate *)date
{
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    return  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
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
