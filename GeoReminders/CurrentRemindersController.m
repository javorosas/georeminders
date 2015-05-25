//
//  SecondViewController.m
//  GeoReminders
//
//  Created by Javier Rosas on 5/21/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "CurrentRemindersController.h"
#import "User.h"
#import "AppDelegate.h"

@interface CurrentRemindersController ()

@property User *currentUser;

@end

@implementation CurrentRemindersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentUser = [User getLoggedUser];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:self.currentUser.name delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

-(void)viewDidAppear:(BOOL)animated {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hello!" message:self.currentUser.name preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
