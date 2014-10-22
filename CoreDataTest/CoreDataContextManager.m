//
//  CoreDataContextManager.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/22.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "CoreDataContextManager.h"


@interface CoreDataContextManager ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;

//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end


@implementation CoreDataContextManager

@dynamic managedObjectModel;
@dynamic persistentStoreCoordinator;
@dynamic mainManagedObjectContext;


+ (instancetype)sharedManager
{
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });

    return sharedInstance;
}


- (NSManagedObjectContext *)managedObjectContext
{
    if ([NSThread isMainThread]) {
        return self.mainManagedObjectContext;
    }

    NSManagedObjectContext *context = nil;

    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = coordinator;
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }

    return context;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self mainManagedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark private methods

- (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel *model = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataTest"
                                                  withExtension:@"momd"];
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    });

    return model;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *coordinator = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataTest.sqlite"];

        NSError *error = nil;
        coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:nil
                                                 URL:storeURL
                                             options:nil
                                               error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    });

    return coordinator;
}

- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (![NSThread isMainThread]) {
        return nil;
    }

    static NSManagedObjectContext *context = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    });

    return context;
}


- (NSURL *)applicationDocumentsDirectory
{
    NSArray *directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask];
    return [directories lastObject];
}

@end
