//
//  CoreDataContextManager.h
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/22.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreDataContextManager : NSObject

+ (instancetype)sharedManager;

- (NSManagedObjectContext *)mainManagedObjectContext;
- (NSManagedObjectContext *)managedObjectContext;

- (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

@end
