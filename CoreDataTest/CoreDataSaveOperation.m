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

@end
