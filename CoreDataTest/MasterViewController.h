//
//  MasterViewController.h
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/21.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "CoreDataSaveOperation.h"


@interface MasterViewController : UITableViewController <CoreDataSaveListener>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)didChangeObjectID:objectId
                groupType:groupType
       elementDescription:elementDescription;

@end
