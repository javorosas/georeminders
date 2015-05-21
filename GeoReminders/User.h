//
//  User.h
//  
//
//  Created by Javier Rosas on 5/21/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * facebookId;
@property (nonatomic, retain) NSSet *reminders;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRemindersObject:(NSManagedObject *)value;
- (void)removeRemindersObject:(NSManagedObject *)value;
- (void)addReminders:(NSSet *)values;
- (void)removeReminders:(NSSet *)values;

@end
