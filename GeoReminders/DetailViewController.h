//
//  DetailViewController.h
//  GeoReminders
//
//  Created by Javier Rosas on 5/26/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Reminder *reminder;

@end
