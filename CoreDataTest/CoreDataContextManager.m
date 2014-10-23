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

- (NSURL *)applicationDocumentsDirectory;

@end


@implementation CoreDataContextManager

@dynamic managedObjectModel;
@dynamic persistentStoreCoordinator;


+ (instancetype)sharedManager
{
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });

    return sharedInstance;
}


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
    static NSManagedObjectContext *context = nil;

    if (context != nil) {
        return context;
    }

    if (![NSThread isMainThread]) {
        return nil;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    });
    
    return context;
}


- (NSManagedObjectContext *)managedObjectContext
{
    if ([NSThread isMainThread]) {
        return [self mainManagedObjectContext];
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


- (void)saveContext:(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil && [managedObjectContext hasChanges]) {
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - private methods

- (NSURL *)applicationDocumentsDirectory
{
    NSArray *directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask];
    return [directories lastObject];
}


@end
