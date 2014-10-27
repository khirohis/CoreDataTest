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
#import "List.h"
#import "ListOwner.h"


@interface CoreDataSaveOperation ()

- (void)changeList:(NSManagedObjectContext *)context;

- (ListOwner *)fetchListOwner:(NSManagedObjectContext *)context
                    groupType:(NSNumber *)groupType;

- (ListElement *)insertElementForContext:(NSManagedObjectContext *)context
                               elementId:(NSNumber *)elementId
                                   index:(NSNumber *)index
                               groupType:(NSNumber *)groupType
                      elementDescription:(NSString *)elementDescription;

- (ListElement *)updateElement:(ListElement *)object
                         index:(NSNumber *)index
                     groupType:(NSNumber *)groupType
            elementDescription:(NSString *)elementDescription;

- (void)managedContextDidSave:(NSNotification *)notification;
- (void)sendOnSave;

- (NSArray *)getDataList1;
- (NSArray *)getDataList2;

@end


@implementation CoreDataSaveOperation

- (instancetype)initWithListener:(id<CoreDataSaveListener>)listener
{
    self = [super init];
    if (self != nil) {
        _listener = listener;
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

        [self changeList:context];

        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)changeList:(NSManagedObjectContext *)context
{
    NSNumber *groupType = [NSNumber numberWithInt:1];
    
    static int flipFlop = 0;
    flipFlop = !flipFlop;
    NSArray *dataList = flipFlop != 0 ? [self getDataList1] : [self getDataList2];

    List *list;
    ListOwner *listOwner = [self fetchListOwner:context
                                      groupType:groupType];

    if (listOwner == nil) {
        listOwner = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ListOwner class])
                                                  inManagedObjectContext:context];
        list = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([List class])
                                             inManagedObjectContext:context];
        listOwner.groupType = groupType;
        [listOwner addListsObject:list];
    } else {
        list = [listOwner firstList];
    }

    int currentIndex = 0;
    for (NSDictionary *data in dataList) {
        NSNumber *elementId = [data objectForKey:@"elementId"];
        NSString *elementDescription = [data objectForKey:@"elementDescription"];

        BOOL found = NO;
        for (ListElement *element in list.listElements) {
            if ([elementId isEqualToNumber:element.elementId]) {
                [self updateElement:element
                              index:[NSNumber numberWithInt:currentIndex]
                          groupType:groupType
                 elementDescription:elementDescription];

                found = YES;
                break;
            }
        }

        if (!found) {
            ListElement *element = [self insertElementForContext:context
                                                       elementId:elementId
                                                           index:[NSNumber numberWithInt:currentIndex]
                                                       groupType:groupType
                                              elementDescription:elementDescription];

            [list addListElementsObject:element];
        }

        currentIndex++;
    }

    // delete elements
    NSMutableSet *deleteSet = [NSMutableSet set];

    for (ListElement *element in list.listElements) {
        BOOL found = NO;
        for (NSDictionary *data in dataList) {
            if ([element.elementId isEqualToNumber:[data objectForKey:@"elementId"]]) {
                found = YES;
                break;
            }
        }

        if (!found) {
            [deleteSet addObject:element];
        }
    }

    for (ListElement *element in deleteSet) {
        [context deleteObject:element];
    }
}

- (ListOwner *)fetchListOwner:(NSManagedObjectContext *)context
                  groupType:(NSNumber *)groupType
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ListOwner class])
                                                         inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupType == %d", 1];
    [fetchRequest setPredicate:predicate];

    NSArray *result = [context executeFetchRequest:fetchRequest
                                             error:nil];

    if (result != nil && result.count > 0) {
        return result.lastObject;
    }

    return nil;
}


- (ListElement *)insertElementForContext:(NSManagedObjectContext *)context
                               elementId:(NSNumber *)elementId
                                   index:(NSNumber *)index
                               groupType:(NSNumber *)groupType
                      elementDescription:(NSString *)elementDescription
{
    ListElement *element = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ListElement class])
                                                                  inManagedObjectContext:context];
    element.elementId = elementId;
    element.index = index;
    element.groupType = groupType;
    element.elementDescription = elementDescription;

    return element;
}

- (ListElement *)updateElement:(ListElement *)element
                         index:(NSNumber *)index
                     groupType:(NSNumber *)groupType
            elementDescription:(NSString *)elementDescription
{
    element.index = index;
    element.groupType = groupType;
    element.elementDescription = elementDescription;
    
    return element;
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


- (NSArray *)getDataList1
{
    return @[
             @{@"elementId": @0, @"elementDescription": @"kuma-0"},
             @{@"elementId": @1, @"elementDescription": @"kuma-1"},
             @{@"elementId": @2, @"elementDescription": @"kuma-2"},
             @{@"elementId": @3, @"elementDescription": @"kuma-3"},
             @{@"elementId": @4, @"elementDescription": @"kuma-4"},
             @{@"elementId": @5, @"elementDescription": @"kuma-5"},
             @{@"elementId": @6, @"elementDescription": @"kuma-6"},
             @{@"elementId": @7, @"elementDescription": @"kuma-7"},
             @{@"elementId": @8, @"elementDescription": @"kuma-8"},
             @{@"elementId": @9, @"elementDescription": @"kuma-9"}
             ];
}

- (NSArray *)getDataList2
{
    return @[
             @{@"elementId": @0, @"elementDescription": @"maku-0"},
             @{@"elementId": @2, @"elementDescription": @"maku-2"},
             @{@"elementId": @4, @"elementDescription": @"maku-4"},
             @{@"elementId": @6, @"elementDescription": @"maku-6"},
             @{@"elementId": @8, @"elementDescription": @"maku-8"},
             @{@"elementId": @10, @"elementDescription": @"maku-10"},
             @{@"elementId": @12, @"elementDescription": @"maku-12"},
             @{@"elementId": @14, @"elementDescription": @"maku-14"},
             @{@"elementId": @16, @"elementDescription": @"maku-16"},
             @{@"elementId": @18, @"elementDescription": @"maku-18"}
             ];
}

@end
