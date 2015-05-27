//
//  Reminder.h
//  GeoReminders
//
//  Created by Javier Rosas on 5/21/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSDate * createdOn;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber *radius;
@property (nonatomic, retain) User *user;

@end
