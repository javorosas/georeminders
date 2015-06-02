//
//  DetailViewController.m
//  GeoReminders
//
//  Created by Javier Rosas on 5/26/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"
#import "CreateViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Populate view
    self.titleLabel.text = self.reminder.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd, YYYY 'at' hh:mm a"];
//    dateFormatter.dateStyle = NSDateIntervalFormatterFullStyle;
    self.subtitleLabel.text = [dateFormatter stringFromDate: self.reminder.date];
    self.detailsTextView.text = self.reminder.details;
    
    // Add the edit button
    
    if (self.presentingViewController) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModal)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }else{
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    
}

-(void)dismissModal{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"Edit" sender:self.reminder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Edit"]) {
        CreateViewController *dest = (CreateViewController *)segue.destinationViewController;
        Reminder *reminder = (Reminder *)sender;
        dest.reminder = reminder;
    }
}


@end
