//
//  User.m
//  
//
//  Created by Javier Rosas on 5/21/15.
//
//

#import "User.h"
#import "Reminder.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation User

@dynamic name;
@dynamic facebookId;
@dynamic reminders;
@dynamic isLoggedIn;

static User *sharedUser = nil;

+ (instancetype)getLoggedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [User userFromDatabase];
    });
    return sharedUser;
}

+ (instancetype)userFromDatabase {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isLoggedIn = YES"];
    NSError *error;
    NSArray *fetchedUsers = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    User *user;
    if (fetchedUsers.count > 0) {
        user = (User *)fetchedUsers.firstObject;
        return user;
    } else {
        return nil;
    }
}

+ (void)setLoggedUser:(User *)user {
    sharedUser = user;
}

+ (void)saveIfNotExistsWithCompletionHandler:(void (^)(NSError *))handler {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = [User userFromDatabase];
    if (!user) {
        user = [[self alloc] initWithEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:appDelegate.managedObjectContext] insertIntoManagedObjectContext:appDelegate.managedObjectContext];
        FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
        FBSDKGraphRequest *graphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        [graphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                if (handler) {
                    handler(error);
                }
            } else {
                user.facebookId = token.userID;
                user.name = result[@"name"];
                user.isLoggedIn = YES;
                [user.managedObjectContext save:&error];
                [User setLoggedUser:user];
                if (handler) {
                    handler(error);
                }
            }
        }];
    } else if (handler) {
        handler(nil);
    }
}

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self) {
        
    }
    return self;
}

- (void)logOutWithCompletionHandler:(void (^)(NSError *))handler {
    self.isLoggedIn = false;
    NSError *error;
    [self.managedObjectContext save:&error];
    if (handler) {
        handler(error);
    }
}

@end
