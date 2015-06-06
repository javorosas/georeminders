//
//  CreateViewController.h
//  GeoReminders
//
//  Created by Javier Rosas on 5/26/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Reminder.h"

@interface CreateViewController : UIViewController<MKMapViewDelegate>

@property Reminder *reminder;

@end
