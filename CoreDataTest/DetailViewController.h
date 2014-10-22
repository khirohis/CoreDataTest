//
//  DetailViewController.h
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/21.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ListElement;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ListElement *detailItem;

@property (weak, nonatomic) IBOutlet UITextField *detailGroupTypeField;
@property (weak, nonatomic) IBOutlet UITextField *detailDescriptionField;

@end
