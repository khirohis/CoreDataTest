//
//  CoreDataSaveOperation.m
//  CoreDataTest
//
//  Created by 小林博久 on 2014/10/22.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "CoreDataSaveOperation.h"
#import "CoreDataContextManager.h"
#import "ListElement.h"


@interface CoreDataSaveOperation ()

@property (strong, nonatomic) NSManagedObjectID *targetObjectId;
@property (strong, nonatomic) NSNumber *targetGroupType;
@property (strong, nonatomic) NSString *targetElementDescription;

- (void)managedContextDidSave:(NSNotification *)notification;
- (void)sendOnSave;

@end


@implementation CoreDataSaveOperation

- (instancetype)initWithObjectID:(id)objectId
                       groupType:(NSNumber *)groupType
              elementDescription:(NSString *)elementDescription
{
    self = [super init];
    if (self != nil) {
        _targetObjectId = objectId;
        _targetGroupType = groupType;
        _targetElementDescription = elementDescription;
    }

    return self;
}


- (void)main
{
    CoreDataContextManager *manager = [CoreDataContextManager sharedManager];
    NSManagedObjectContext *context = [manager managedObjectContext];
    if (context != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(managedContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:context];

        NSManagedObject *object = [context objectWithID:self.targetObjectId];
        if (object != nil) {
            ListElement *element = (ListElement *)object;
            element.groupType = self.targetGroupType;
            element.elementDescription = self.targetElementDescription;

            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}


- (void)managedContextDidSave:(NSNotification *)notification
{
    [self performSelectorOnMainThread:@selector(sendOnSave)
                           withObject:nil
                        waitUntilDone:YES];

    CoreDataContextManager *manager = [CoreDataContextManager sharedManager];
    [manager.mainManagedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                    withObject:notification
                                                 waitUntilDone:YES];
}

- (void)sendOnSave
{
    [self.listener onSave:self];
}


@end
